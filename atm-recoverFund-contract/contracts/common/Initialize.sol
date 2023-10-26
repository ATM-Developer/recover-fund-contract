
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Initialize {
    bool private initialized;
    
    modifier noinit(){
        require(!initialized, "initialized");
        _;
        initialized = true;
    }
}