# ATM RecoverFund Contracts

## Intraduction

On the basis of ATM [recover plan](https://www.atm.network/#/noticeDetails?id=66 ), this project including two major contracts `RcoverFund` and `Staker`. The function of RecoverFund is allow users to invest `USDC` and allow mangers sent proposal to buyback `LUCA` or vote for proposal. And the Staker contract allow the invester to stake `LUCA` and get rewards.


## Contract Details

### 1. RecoverFund

#### Reade Functions

**1.1 totalFund**: return a `uint256` number that represents how much `USDC` have been fund

**1.2 endTime**: return a `uint256` number that is a timestemp of activit end

**1.3 investOf**:  `investOf(address)` query funded amount by address

**1.4 Buybacker**: return a `address` that is the contract address of the `buyback` operator

#### Write Functions

**1.5 invest**: `invest(uint256)` invest `USDC` to recoverFund contract

**1.6 buybackAndBurn**:  cost `USDC` to buyback `LUCA` and burn it, only `Buybacker` can call this function

**1.7 setBuybacker**: setup `Buybacker` address, only ATM manager contract can call this function

---

### 2. Staker

The Staker contract allow recoverFund investor to stake specific number of `LUCA`, the amount a user can stake depends on the user's invest ratio. The stake activity lasts for eight years, once a year for three months each time.
The maximum mortgage allowed in each campaign is `700,000` `LUCA` and the total reward is `300,000` `LUCA`.



`Note: The stake activity need after invest end`



```js

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
    
    mapping(uint256 => StakerInfo) public stakerInfo;                          //season => StakerInfo
    mapping(uint256 => mapping(uint256 => StakingInfo)) public stakingInfo;    //season => stakingId => StakingInfo
   
    
```

#### Reade Functions

all public variables are readable, the same with reade functions.
**2.1 alive**: return a `bool` , `true` express activity in progress, `false` otherwise

**2.2 calculateStakeSpace(address)**: calculate user's stake space

**2.3 calculateStakeReward**: `calculatePendingReward(address)` return a `uint256` number that is the number of rewards

**2.4 getStakeds**: `getStakeds(uint256 season, address user)` return staked list


#### Write Functions

**2.5 stake**: `stake(uint256)` stake LUCA, need approve LUCA for staker contract before call this function

**2.6 unstake**: `unstake(uint256 season, uint256 id)` unstake LUCA, it will release staked and give rewards


### 3. Buybacker
Buybacker contract is the only operator of `buybackAndBurn` by `execBuyback(uint256 amtIn, uint245 minOut)` function.


#### Write Functions
**3.1 execBuyback**: `execBuyback(uint256 amtIn, uint245 minOut)` execute buyback, `amtIn` is the amount will be cost and   `minOut` is the amount of LUCA that will be burn



## contracts

| NAME | BNB TEST | BNB MAIN |
|  :----:   |    :---   | :--- |
| LUCA         | 0xD7a1cA21D73ff98Cc64A81153eD8eF89C2a1EfEF | 0x51e6ac1533032e72e92094867fd5921e3ea1bfa0 |
| USDC         | 0xE0dFffc2E01A7f051069649aD4eb3F518430B6a4 | 0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d |
| Router       | 0xCc7aDc94F3D80127849D2b41b6439b7CF1eB4Ae0 | 0x10ED43C718714eb63d5aA57B78B54704E256024E |
| RecoverFund  | 0xA1AE8ab06202a94eb10Fc14e8263D26bC5D898F2 | 0xcBa0D4bd0A6aDadA793592823524C1Ccb670EcD1 |
| Buybacker    | 0x73C51Afe44ae68346B451fd9382Ad6D623e71856 | 0xdF38c05520378991d107E27d32d86B85Ff8b7472 |
| Staker       | coming soon... | coming soon... |
