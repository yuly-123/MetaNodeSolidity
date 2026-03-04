// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * CallerContract呼叫合约，调用代理合约，并获取执行结果
 */
contract CallerContract{
    address public proxy; // 代理合约地址

    constructor(address proxy_){
        proxy = proxy_;
    }

    // 通过代理合约调用 increase()函数
    function increase() external returns(uint) {
        ( , bytes memory data) = proxy.call(abi.encodeWithSignature("increment()"));
        return abi.decode(data, (uint));
    }
}
