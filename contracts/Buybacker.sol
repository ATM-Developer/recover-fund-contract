// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IrecoverFund {
      function buybackeAndBurn(uint256 amtIn, uint256 minut) external;
      function balance() external returns(uint256);
      function endtime() external returns(uint256);
}

contract Buybacker {
      address public recoverFund;
      address public operator;
      mapping(uint256=>uint256) public cost; 

      uint256 constant dailyMaxCost = 30000e18;

      event BuybackeEvent(uint256 indexed dayIndex,uint256 timestamp, uint256 amount);

      constructor(address _recoverFund, address _operator){
            recoverFund = _recoverFund;
            operator = _operator;
      }

      function execBuyback(uint256 amt) external{
            require(block.timestamp > IrecoverFund(recoverFund).endtime(),"Only after recoverFund end");
            require(msg.sender == operator, "Only operator is allowed");
            require(amt > 0, "Invalid amount");

            uint256 balance = IrecoverFund(recoverFund).balance();
            uint256 amount =  amt * 1e18;
            if (amount > balance) amount = balance;

            uint256 day = block.timestamp / 1 days ;
            cost[day] += amount;
            require(cost[day] <= dailyMaxCost, "Out of daily max cost");

            IrecoverFund(recoverFund).buybackeAndBurn(amount, 0);
            emit BuybackeEvent(day, block.timestamp, amount);    
      }

      function execBuyback(uint256 amtIn, uint256 minOut) external{
            require(block.timestamp > IrecoverFund(recoverFund).endtime(),"Only after recoverFund end");
            require(msg.sender == operator, "Only operator is allowed");
            require(amtIn > 0, "Invalid amount");

            uint256 balance = IrecoverFund(recoverFund).balance();

            if (amtIn > balance) amtIn = balance;

            uint256 day = block.timestamp / 1 days ;
            cost[day] += amtIn;
            require(cost[day] <= dailyMaxCost, "Out of daily max cost");

            IrecoverFund(recoverFund).buybackeAndBurn(amtIn, minOut);
            emit BuybackeEvent(day, block.timestamp, amtIn);    
      }

}