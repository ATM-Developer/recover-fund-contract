// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Ifund {
    function investOf(address) external view returns (uint256);

    function totalFund() external view returns (uint256);

    function endtime() external view returns (uint256);
}
