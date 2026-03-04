// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TestTemp {
    event Input(address indexed from, uint256 value);
    function show() public  {
        emit Input(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 213);
    }
}
