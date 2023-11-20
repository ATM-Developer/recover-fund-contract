// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/interface/IERC20.sol";
import "contracts/interface/Ifund.sol";
import "contracts/common/Admin.sol";
import "contracts/common/Initialize.sol";

/// @title Staker contarct
/// @notice Only inverster of RecoverFund can staking. this contract is a soft staker, users can unstaker anytime. 
contract Staker is Admin, Initialize {
    IERC20  public LUCA;
    Ifund   public FUND;
    uint256 public SEASON;

    struct StakerInfo{                   // Staker activit information
        uint256 unclaimRewards;          // 300,000 LUCA per season
        uint256 stakeTop;                // 700,000 LUCA per season
        uint256 rewardRate;              // reward of per token per second
        uint256 startTime;               // start of current activit
        uint256 endTime;                 // end of current activit
        uint256 totalStaked;             // vaule of staked 
    }

    struct StakingInfo {                 // User staked information
        uint256 stakedAmount;          
        uint256 stakingStartTime;     
        uint256 lastClaimTime;
        uint256 totalRewardsEarned;
    }

    mapping(uint256 => StakerInfo) public stakerInfo;    //season => StakerInfo
    mapping(uint256 => mapping(address => StakingInfo)) public stakingInfo;  //season => (user => StakingInfo)
    

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount, uint256 reward);
    event RewardClaimed(address indexed user, uint256 reward);

    modifier auth() {
        require(FUND.investOf(msg.sender) > 0, "Stake: Only invester can call");
        _;
    }

    function init(address luca, address fund) public noinit {
        (LUCA, FUND) = (IERC20(luca), Ifund(fund));
        SEASON = 1;
    }

    function setStaker(uint256 season, uint256 start) public admin{
        require(season == SEASON++, "Staker: invalid season");
        IERC20(LUCA).transfer(address(this), 300000e18);
        stakerInfo[season] = StakerInfo(                
            300000e18,                                //totalreward
            700000e18,                                //stakeTop
            55114638447971781305,                     //rewardRate = totalreward * 1e27 / stakeTop / 90 days
            start,                                    //startTime
            start+ 90 days,                           //endTime
            0                                         //totalStaked
        );
    }

    function alive() public view returns(bool){
        StakerInfo memory s = stakerInfo[SEASON];
        return block.timestamp >= s.startTime && block.timestamp <= s.endTime;
    }

    function calculateStakeLimit(address user) public view returns (uint256) {
        return (FUND.investOf(user) * stakerInfo[SEASON].stakeTop) / FUND.totalFund();
    }

    function calculatePendingReward(uint256 season, address user) internal view returns (uint256) {
        StakerInfo memory s = stakerInfo[season];
        StakingInfo memory u = stakingInfo[season][user];

        if (u.stakedAmount == 0) {return 0;}

        uint256 unclaimedDuration = block.timestamp < s.endTime ? block.timestamp - u.lastClaimTime : s.endTime - u.lastClaimTime;
        return (u.stakedAmount * s.rewardRate * unclaimedDuration) / 1e27;
    }

    function stake(uint256 amount) external auth {
        StakerInfo storage s = stakerInfo[SEASON];
        require(
            block.timestamp > s.startTime && block.timestamp < s.endTime,
            "Staker: Activit not start or ended"
        );
        
        StakingInfo storage u = stakingInfo[SEASON][msg.sender];
        require(
            amount > 0 && u.stakedAmount + amount <=calculateStakeLimit(msg.sender),
            "Staker: Amount out of limlt"
        );
        if (u.stakedAmount > 0) {
            uint256 pendingReward = calculatePendingReward(SEASON, msg.sender);
            if (pendingReward > 0) {
                s.unclaimRewards -= pendingReward;
                LUCA.transfer(msg.sender, pendingReward);
                emit RewardClaimed(msg.sender, pendingReward);
            }
        }

        LUCA.transferFrom(msg.sender, address(this), amount);

        u.stakedAmount += amount;
        u.stakingStartTime = block.timestamp;
        u.lastClaimTime = block.timestamp;

        s.totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        StakerInfo storage s = stakerInfo[SEASON];
        StakingInfo storage u= stakingInfo[SEASON][msg.sender];
        require(u.stakedAmount > 0, "Staker: No tokens staked");

        uint256 pendingReward = calculatePendingReward(SEASON, msg.sender);
        if (pendingReward > 0) {
            s.unclaimRewards -= pendingReward;
            LUCA.transfer(msg.sender, pendingReward);
            emit RewardClaimed(msg.sender, pendingReward);
        }

        uint256 stakedAmount = u.stakedAmount;
        LUCA.transfer(msg.sender, stakedAmount);

        u.stakedAmount = 0;
        u.stakingStartTime = 0;
        u.lastClaimTime = 0;
        u.totalRewardsEarned += pendingReward;

        s.totalStaked -= stakedAmount;
        emit Unstaked(msg.sender, stakedAmount, pendingReward);
    }

    function claimReward() external {
        StakerInfo storage s = stakerInfo[SEASON];
        StakingInfo storage u = stakingInfo[SEASON][msg.sender];
        require(u.stakedAmount > 0, "No tokens staked");

        uint256 pendingReward = calculatePendingReward(SEASON, msg.sender);
        require(pendingReward > 0, "No pending reward to claim");

        u.lastClaimTime = block.timestamp;
        s.unclaimRewards -= pendingReward;
        LUCA.transfer(msg.sender, pendingReward);

        emit RewardClaimed(msg.sender, pendingReward);
    }
}
