// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Visibility {
    function a(uint256 a) public pure returns (bytes memory, bytes4) {
        return (msg.data, msg.sig);
    }
}
