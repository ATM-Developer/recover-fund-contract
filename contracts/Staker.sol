// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/interface/IERC20.sol";
import "contracts/interface/Ifund.sol";
import "contracts/common/Admin.sol";
import "contracts/common/Initialize.sol";

/// @title Staker contarct
/// @notice Only inverster of RecoverFund can stake
contract Staker is Admin, Initialize {
    IERC20 public LUCA;
    Ifund public FUND;
    uint256 public totalStaked;
    uint256 public rewardRate;
    uint256 public totalRewards;
    uint256 public stakeTop;
    uint256 public startTime;
    uint256 public endTime;

    struct StakingInfo {
        uint256 stakedAmount;
        uint256 stakingStartTime;
        uint256 lastClaimTime;
        uint256 totalRewardsEarned;
    }

    mapping(address => StakingInfo) public stakingInfo;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event RewardClaimed(address indexed user, uint256 reward);

    function init(address luca, address fund, uint256 start) public noinit {
        LUCA = IERC20(luca);
        FUND = Ifund(fund);
        startTime = start;
        endTime = start + 90 days;
        totalRewards = 300000e18;
        stakeTop = 700000e18;
        rewardRate = (1e27 * totalRewards) / stakeTop / 90 days;
    }

    modifier auth() {
        require(FUND.investOf(msg.sender) > 0, "Stake: Only invester can call");
        _;
    }

    function calculateStakeLimit(address user) public view returns (uint256) {
        return (FUND.investOf(user) * stakeTop) / FUND.totalFund();
    }

    function calculatePendingReward(
        address user
    ) internal view returns (uint256) {
        StakingInfo storage userStaking = stakingInfo[user];
        uint256 stakedAmount = userStaking.stakedAmount;
        uint256 stakingStartTime = userStaking.stakingStartTime;
        uint256 lastClaimTime = userStaking.lastClaimTime;

        if (stakedAmount == 0 || stakingStartTime == 0) {
            return 0;
        }

        //uint256 stakingDuration = block.timestamp - stakingStartTime;
        uint256 unclaimedDuration = block.timestamp < endTime
            ? block.timestamp - lastClaimTime
            : endTime - lastClaimTime;

        uint256 reward = (stakedAmount * rewardRate * unclaimedDuration) / 1e27;

        return reward;
    }

    function stake(uint256 amount) external auth {
        require(
            block.timestamp > startTime && block.timestamp < endTime,
            "Staker: Activit not start or ended"
        );
        StakingInfo storage userStaking = stakingInfo[msg.sender];
        require(
            amount > 0 &&
                userStaking.stakedAmount + amount <=
                calculateStakeLimit(msg.sender),
            "Staker: Amount out of limlt"
        );
        if (userStaking.stakedAmount > 0) {
            uint256 pendingReward = calculatePendingReward(msg.sender);
            if (pendingReward > 0) {
                totalRewards -= pendingReward;
                LUCA.transfer(msg.sender, pendingReward);
                emit RewardClaimed(msg.sender, pendingReward);
            }
        }

        LUCA.transferFrom(msg.sender, address(this), amount);

        userStaking.stakedAmount += amount;
        userStaking.stakingStartTime = block.timestamp;
        userStaking.lastClaimTime = block.timestamp;

        totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        StakingInfo storage userStaking = stakingInfo[msg.sender];
        require(userStaking.stakedAmount > 0, "Staker: No tokens staked");

        uint256 pendingReward = calculatePendingReward(msg.sender);
        if (pendingReward > 0) {
            totalRewards -= pendingReward;
            LUCA.transfer(msg.sender, pendingReward);
            emit RewardClaimed(msg.sender, pendingReward);
        }

        uint256 stakedAmount = userStaking.stakedAmount;
        LUCA.transfer(msg.sender, stakedAmount);

        userStaking.stakedAmount = 0;
        userStaking.stakingStartTime = 0;
        userStaking.lastClaimTime = 0;
        userStaking.totalRewardsEarned += pendingReward;

        totalStaked -= stakedAmount;
        emit Unstaked(msg.sender, stakedAmount, pendingReward);
    }

    function claimReward() external {
        StakingInfo storage userStaking = stakingInfo[msg.sender];
        require(userStaking.stakedAmount > 0, "No tokens staked");

        uint256 pendingReward = calculatePendingReward(msg.sender);
        require(pendingReward > 0, "No pending reward to claim");

        userStaking.lastClaimTime = block.timestamp;
        totalRewards -= pendingReward;
        LUCA.transfer(msg.sender, pendingReward);

        emit RewardClaimed(msg.sender, pendingReward);
    }
}
