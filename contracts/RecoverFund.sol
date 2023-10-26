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

    function _setLUCA(address luca) internal {
        LUCA = luca;
    }

    // wrapping Manager contract
    function set(uint256 t, uint256 r) public admin {
        _set(t, r);
    }

    function rely(address guy) public admin {
        _rely(guy);
    }

    function deny(address guy) public admin {
        _deny(guy);
    }

    function afterPass(uint256 tokenIn) internal override {
        _buybackAndBurn(USDC, LUCA, tokenIn);
    }

    function init(
        address router,
        address luca,
        address usdc,
        uint256 votetime,
        uint256 thershold,
        uint256 endtime,
        address[] calldata mngs
    ) external noinit {
        _setRouter(router);
        _setUSDC(usdc);
        _setLUCA(luca);
        _setEndtime(endtime);
        _set(votetime, thershold);
        for (uint i = 0; i < mngs.length; i++) {
            _rely(mngs[i]);
        }
    }
}
