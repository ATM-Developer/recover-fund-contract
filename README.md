# ATM RecoverFund Contract

## Contratc Details

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

**1.8 deny**: `deny(address)` rely a address, then that can sent and vote proposal

**1.8 rely**: `rely(address)` rely a address

**1.8 sentProposal**: `sentProposal(uint256)` sent a buyback proposal

**1.8 vote**: `vote(bool)` vote for new proposal

---

### 2. Staker

#### Reade Functions

#### Write Functions

## Test Env

```js
BNB TestNet:

pancakeSwapRouter:   0xCc7aDc94F3D80127849D2b41b6439b7CF1eB4Ae0
LUCA:   0xD7a1cA21D73ff98Cc64A81153eD8eF89C2a1EfEF
BUSD:   0xE0dFffc2E01A7f051069649aD4eb3F518430B6a4
Pair:   0x36b20fDB728771484bd7F9E5b124A19272c1FDC0

RecoverFundProxy: 0xA1AE8ab06202a94eb10Fc14e8263D26bC5D898F2
StakerProxy: come soon...


```