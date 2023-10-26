
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "contracts/interface/IERC20.sol";

/// @title Fund contartc
/// @notice storege funds info
contract Fund {
    address public USDC;
    uint256 public totalFund;
    uint256 public endtime; 
    mapping (address => uint256) public investOf; 

    event Invest(address user, uint256 amount);

    function _setUSDC(address usdc) internal {
        USDC = usdc;
    }

    function _setEndtime(uint256 end) internal {
        endtime = end;
    }

    function balance() public view returns(uint256){
        return IERC20(USDC).balanceOf(address(this));
    }

    function invest(uint256 amount) external {
        require(block.timestamp < endtime, "Fund: activit ended");
        IERC20(USDC).transferFrom(msg.sender, address(this), amount);
        investOf[msg.sender] += amount;
        totalFund += amount;
        emit Invest(msg.sender, amount);
    }
}

