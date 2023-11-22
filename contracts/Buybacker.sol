
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IrecoverFund {
      function buybackeAndBurn(uint256 tokenIn) external;
      function balance() external returns(uint256);
}

contract Buybacker {
      address public recoverFund;
      address public operator;
      mapping(uint256=>uint256) public cost; 

      uint256 constant baseCost = 15_000e18;
      uint256 constant dailyMaxCost = 30_000e18;
    

      event BuybackeEvent(uint256 indexed dayIndex,uint256 timestamp, uint256 amount);

      constructor(address _recoverFund, address _operator){
            recoverFund = _recoverFund;
            operator = _operator;
      }

      function execBuyback() external{
            require(msg.sender == operator, "Only operator is allowed");

            uint256 balance = IrecoverFund(recoverFund).balance();
            uint256 amount = balance >= baseCost ? baseCost : balance;
            
            uint256 day = block.timestamp / 1 days ;
            cost[day] += amount;
            require(cost[day] <= dailyMaxCost, "Out of daily max cost");

            IrecoverFund(recoverFund).buybackeAndBurn(amount);
            emit BuybackeEvent(day, block.timestamp, amount);    
      }
}