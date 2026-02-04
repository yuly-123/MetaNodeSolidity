// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TestTemp {
    uint256 public a = 100;

    function test() public payable returns(bytes calldata) {
        return msg.data;
    }
    receive() external payable {
        a = 101;
    }
    fallback() external payable {
        a = 102;
    }
}
contract Test {
    TestTemp test;

    constructor(address payable _test) {
        test = TestTemp(_test);
    }
    function pay1() public payable returns(bool, bytes memory) {
        (bool success, bytes memory data) = address(test).call{value: msg.value}("");   // 触发TestTemp合约的receive()函数
        return (success, data);
    }
    function pay2() public payable {
        test.test{value: msg.value}();  // 不会触发TestTemp合约的receive()函数
    }
    function pay3() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test(uint256)", 213);   // 调用合约不存在的函数
        (bool success, bytes memory data) = address(test).call{value: msg.value}(msgData);  // 触发TestTemp合约的fallback()函数
        return (success, data);
    }
}
