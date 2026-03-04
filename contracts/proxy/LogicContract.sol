// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * LogicContract逻辑合约，执行被委托的调用
 */
contract LogicContract {
    address public implementation; // 与Proxy保持一致，防止插槽冲突
    uint public x = 99;
    event CallSuccess();

    // 这个函数会释放LogicCalled并返回一个uint。
    // 函数selector: 0xd09de08a
    function increment() external returns(uint) {
        emit CallSuccess();
        return x + 1;
    }
}
