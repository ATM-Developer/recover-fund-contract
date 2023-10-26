// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "contracts/common/Proxy.sol";

contract StakerProxy is Proxy{
    constructor(address staker){
        _setAdmin(msg.sender);
        _setLogic(staker);
    }
}