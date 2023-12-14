// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/interface/IERC20.sol";
import "contracts/interface/IPancakeRouter02.sol";

/// @title pancakeHelper contarct
/// @notice rpovider pancakeSwap swap function
contract PancakeHelper {
    address public pancakeRouter;
  
    function _setRouter(address router) internal  {
        pancakeRouter = router;
    }

    function calculateAmountOutMin(
        address tokenIn,
        address tokenOut,
        uint amountIn
    ) public view returns (uint) {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;
        uint[] memory amounts = IPancakeRouter02(pancakeRouter).getAmountsOut(amountIn, path);
        return amounts[1] - (amounts[1] / 10);  //Slippage Tolerance: 10%
    }

    function _swapTokens(
        address tokenIn,
        address tokenOut,
        uint amountIn,
        uint amountOutMin, 
        address to,
        uint deadline
    ) internal {
        address[] memory path = new address[](2);
        path[0] = tokenIn;
        path[1] = tokenOut;

        require(IERC20(tokenIn).approve(pancakeRouter, amountIn), "Approval failed");

        IPancakeRouter02(pancakeRouter).swapExactTokensForTokens(
            amountIn,
            amountOutMin,
            path,
            to,
            deadline
        );
    }

    function _buybackAndBurn(        
        address tokenIn,
        address tokenOut,
        uint amountIn,
        uint amountOutMin  
    ) internal {
        _swapTokens(tokenIn, tokenOut, amountIn, amountOutMin, address(this), block.timestamp);
        IERC20(tokenOut).burn(IERC20(tokenOut).balanceOf(address(this)));
    }
}