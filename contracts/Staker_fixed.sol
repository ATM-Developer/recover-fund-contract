// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/interface/IERC20.sol";
import "contracts/interface/Ifund.sol";
import "contracts/common/Admin.sol";
import "contracts/common/Initialize.sol";

/// @title Staker contarct
/// @notice Only inverster of RecoverFund can staking. once LUCA be staked, that will be locked 90 days. 
contract Staker is Admin, Initialize {
    IERC20  public LUCA;
    Ifund   public FUND;
    uint256 public SEASON;
    
    struct StakerInfo{                   // Staker activit information
        uint256 unclaimRewards;          // 300,000 LUCA per season in the beging process
        uint256 stakeableSpace;          // 700,000 LUCA per season in the beging process
        uint256 rewardRate;              // reward of per token
        uint256 lockDuration;            // lock duration
        uint256 startTime;               // start of current activit
        uint256 endTime;                 // end of current activit
        uint256 totalStaked;             // vaule of staked 
    }

    struct StakingInfo {                 // User staked information
        address owner;
        uint256 stakedAmount;          
        uint256 stakedTime;   
        uint256 releaseTime;   
        uint256 claimTime;
        uint256 rewardsEarned;
    }
    
    uint256 internal _id;
    mapping(uint256 => StakerInfo) public stakerInfo;                          //season => StakerInfo
    mapping(uint256 => mapping(uint256 => StakingInfo)) public stakingInfo;    //season => stakingId => StakingInfo
    mapping(address => mapping(uint256 => uint256[])) internal _stakings;      //user => season => stakingId list

    event Staked(address indexed user, uint256 season, uint256 amount);
    event Unstaked(address indexed user, uint256 season, uint256 amount, uint256 reward);
    
    modifier auth() {
        require(FUND.investOf(msg.sender) > 0, "Staker: Only invester can call");
        _;
    }

    function init(address luca, address fund) public noinit {
        (LUCA, FUND) = (IERC20(luca), Ifund(fund));
    }

    function setStaker(uint256 start) public {
        require(block.timestamp > stakerInfo[SEASON].endTime, "Staker: Activity in progress");
        SEASON++;
        
        IERC20(LUCA).transferFrom(msg.sender, address(this), 300000e18);
        _id = 0;
        stakerInfo[SEASON] = StakerInfo(
            300000e18,                                //totalreward
            700000e18,                                //stakeTop
            428571428571428571428571428,              //rewardRate = totalreward * 1e27 / stakeTop 
            90 days,                                  //lock duration
            start,                                  //startTime
            start+ 90 days,                         //endTime
            0                                         //totalStaked
        );
    }

    function alive() public view returns(bool){
        StakerInfo memory s = stakerInfo[SEASON];
        return block.timestamp >= s.startTime && block.timestamp <= s.endTime;
    }

    function calculateStakeSpace(address user) public view returns (uint256) {
        uint256 staked; 
        uint256[] memory stakedIds = _stakings[msg.sender][SEASON];
        for(uint256 i = 0; i < stakedIds.length; i++){
            staked += stakingInfo[SEASON][stakedIds[i]].stakedAmount;
        }

        return ((FUND.investOf(user) * 700000e18) / FUND.totalFund()) - staked;
    }

    function calculateReward(uint256 staked) internal view returns (uint256) {
        return staked * stakerInfo[SEASON].rewardRate / 1e27;
    }

    function stake(uint256 amount) external auth returns (uint256) {
        StakerInfo storage s = stakerInfo[SEASON];
        require(block.timestamp > s.startTime && block.timestamp < s.endTime, "Staker: Activit not start or ended");
        require(amount <= s.stakeableSpace && amount <= calculateStakeSpace(msg.sender),"Staker: Amount out of space");
      
        LUCA.transferFrom(msg.sender, address(this), amount);

        //storage staking information
        stakingInfo[SEASON][_id++] = StakingInfo(
            msg.sender,
            amount,
            block.timestamp,
            block.timestamp + 90 days,
            0,
            0
        );

        //update StakerInfo
        s.stakeableSpace -= amount;
        s.totalStaked += amount;

        //update user staking list
        _stakings[msg.sender][SEASON].push(_id); 
        emit Staked(msg.sender,SEASON ,amount);

        return _id;
    }

    function unstake(uint256 season, uint256 id) external {
        StakerInfo storage s = stakerInfo[season];
        StakingInfo storage u= stakingInfo[season][id];
        
        require(u.stakedAmount > 0, "Staked: stakerId unexist");
        require(u.claimTime == 0, "Staker: already claimed");
        require(u.owner == msg.sender, "Staker: Only onwer can call");
        require(u.releaseTime <= block.timestamp, "Staker: On lock");

        uint256 reward = calculateReward(u.stakedAmount);
        if (reward > 0) {
            //update Staker Information
            s.totalStaked -= u.stakedAmount;
            s.unclaimRewards -= reward;


            //update user staking information
            u.claimTime = block.timestamp;
            u.rewardsEarned = reward;

            //release staked
            LUCA.transfer(msg.sender, u.stakedAmount);
            //claim reward
            LUCA.transfer(msg.sender, reward);

            emit Unstaked(msg.sender, season, u.stakedAmount, reward);
        }
    } 
}
