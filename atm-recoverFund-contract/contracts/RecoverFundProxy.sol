// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/common/Proxy.sol";

contract RecoverFundProxy is Proxy{
    constructor(address recoverFund){
        _setAdmin(msg.sender);
        _setLogic(recoverFund);
    }
}