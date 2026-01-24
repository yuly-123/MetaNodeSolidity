// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    function foo() public virtual returns(string memory) {
        return "A";
    }
}
contract B {
    function foo() public virtual returns(string memory) {
        return "B";
    }
}
contract C is A, B{
    function foo() public pure override(A, B) returns(string memory) {
        return "C";
    }
}
