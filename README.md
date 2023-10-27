# ATM RecoverFund Contract

## Contract Details

### 1. RecoverFund

```js
    struct Proposal{
        address sender;   
        uint256 cost;     
        uint256 expire;
        uint256 line;
        address[] agree;
        address[] disagree;
        uint256 statu; //0: pending; 1: passed; 2: unpassed
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
```js
        struct StakingInfo {
        uint256 stakedAmount;
        uint256 stakingStartTime;
        uint256 lastClaimTime;
        uint256 totalRewardsEarned;
    }
    
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
StakerProxy: 0x7fe395a1200F7f7879AA992130Fe5f610c6e318D
```
