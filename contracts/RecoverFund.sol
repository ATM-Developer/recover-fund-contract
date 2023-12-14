// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/common/Admin.sol";
import "contracts/common/Initialize.sol";
import "contracts/Manager.sol";
import "contracts/PancakeHelper.sol";
import "contracts/Fund.sol";


/// @title ATM Recover Fund contract
/// @notice user can invest in this contarct, and managers can sent a proposal to spent funds to buyback and burn LUCA  
contract RecoverFund is Admin, Manager, Fund, PancakeHelper, Initialize {
    address public LUCA;
    address public Buybacker;

    function _setLUCA(address luca) internal {
        LUCA = luca;
    }

    function setBuybacker(address buybacker) admin public {
        Buybacker = buybacker;
    }

    function buybackeAndBurn(uint256 amtIn, uint256 minOut) external {
        require(msg.sender == Buybacker,  "Only Buybacker");
        _buybackAndBurn(USDC, LUCA, amtIn, minOut);
    }

    function init(
        address router,
        address luca,
        address usdc,
        uint256 endtime
    ) external noinit {
        _setRouter(router);
        _setUSDC(usdc);
        _setLUCA(luca);
        _setEndtime(endtime);
    }
}
