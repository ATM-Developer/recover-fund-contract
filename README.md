# ATM RecoverFund Contracts

## Intraduction

On the basis of ATM [recover plan](https://www.atm.network/#/noticeDetails?id=66 ), this project including two major contracts `RcoverFund` and `Staker`. The function of RecoverFund is allow users to invest `USDC` and allow mangers sent proposal to buyback `LUCA` or vote for proposal. And the Staker contract allow the invester to stake `LUCA` and get rewards.


## Contract Details

### 1. RecoverFund

```js
    //A proposal passed represents will spent a specific number of USDC to buyback and burn LUCA  
    struct Proposal{
        address     sender;   //proposal sender
        uint256     cost;     //the number of USDC 
        uint256     expire;   //expire time
        uint256     line;     //current pass threshould
        address[]   agree;    //agree list
        address[]   disagree; //disagree list
        uint256     statu;    //0: pending;  1: passed;  2: unpassed
    }
```

#### Reade Functions

**1.1 totalFund**: return a `uint256` number that represents how much `USDC` have been fund

**1.2 endTime**: return a `uint256` number that is a timestemp of activit end

**1.3 investOf**:  `investOf(address)` query funded amount by address

**1.4 pId**:  return a `uint256` number that represents how much `Proposal` have been sent

**1.5 proposal**: `proposal(uint256)` query a `Proposal` infomation by `pId`

#### Write Functions

**1.6 rely**: `rely(address)` rely a address, then that address will get right to sent and vote proposal

**1.7 deny**: `deny(address)` deny a address, then that address will lost right

**1.8 sentProposal**: `sentProposal(uint256)` sent a buyback proposal

**1.9 vote**: `vote(bool)` vote for new proposal

---

### 2. Staker

The Staker contract allow inverster to stake specific number of `LUCA`, and the number decide on how much USDC user have invested. The mortgage activity lasts for eight years, once a year for three months each time.
The maximum mortgage allowed in each campaign is `700,000` `LUCA` and the total reward is `300,000` `LUCA`.

`Note: The stake activit need after inverst end`

```js
    //staking info 
    struct StakingInfo {
        uint256     stakedAmount;
        uint256     stakingStartTime;
        uint256     lastClaimTime;
        uint256     totalRewardsEarned;
    }
   
   //key words
   rewardRate = totalRewards / takeTop / 90 days     
   rewards = takeTime * rewardRate * stakedAmount 

    
```

#### Reade Functions

**2.1 startTime**: return a `uint256` number that is timestemp of activite start

**2.2 endTime**: return a `uint256` number that is timestemp of activite end

**2.3 rewardRate**: return a `uint256` number that represents reward speed per LUCA per second

**2.4 stakeTop**: return a `uint256` number that is the limit of stake

**2.5 totalRewards**: return a `uint256` number that is the total number of reward

**2.6 tatalStaked**: retuer a `uint256` number that is the number of staked

**2.7 calculateStakeReward**: `calculatePendingReward(address)` return a `uint256` number that is the number of rewrad

**2.8 stakingInfo** `stakingInfo(address)` return a struct `StakingInfo`

#### Write Functions

**2.9 stake**: `stake(uint256)` stake LUCA, need approve LUCA for staker contarct befor call this function

**2.10 unstake**: unstake LUCA

**2.11 claiReward**: claim reward

## Test Env

```js
BNB TestNet:

pancakeSwapRouter:   0xCc7aDc94F3D80127849D2b41b6439b7CF1eB4Ae0
LUCA:   0xD7a1cA21D73ff98Cc64A81153eD8eF89C2a1EfEF
BUSD:   0xE0dFffc2E01A7f051069649aD4eb3F518430B6a4
Pair:   0x36b20fDB728771484bd7F9E5b124A19272c1FDC0

RecoverFundProxy: 0xA1AE8ab06202a94eb10Fc14e8263D26bC5D898F2
StakerProxy: 0x4793e9CA5AFfCe4c7FB54fc99cECA0CeBE46fFB6
```
