// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TestTemp {
    bytes4 public selector1 = bytes4(keccak256("burn(uint256)"));
    bytes4 public selector2 = bytes4(keccak256("collate_propagate_storage(bytes16)"));
    event Input(address indexed from, uint256 value);
    
    function show() public  {
        emit Input(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4, 213);
    }
}
