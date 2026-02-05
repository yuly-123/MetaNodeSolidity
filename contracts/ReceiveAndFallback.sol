// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * payable、transfer、call、receive、fallback、转账相关功能演示。
 */
contract Test {
    event Received(address s, uint256 v);
    event Fallbacked(address s, uint256 v);
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
    // fallback() external payable {
    //     emit Fallbacked(msg.sender, msg.value);
    // }
    fallback() external {
        emit Fallbacked(0x0000000000000000000000000000000000000000, 0);
    }
    function test1(uint256 amount) public pure returns(bytes calldata, uint256) {
        return (msg.data, amount);
    }
    function test2(uint256 amount) public payable returns(bytes calldata, uint256) {
        return (msg.data, amount);
    }
}
contract Caller {
    Test test;
    constructor(address payable _test) payable {
        // _test 必须是一个 payable 地址，否则会编译错误
        // TypeError: Explicit type conversion not allowed from non-payable "address" to "contract Test", which has a payable fallback function.
        // 类型错误：不允许从非支付地址"address"显式类型转换为具有可支付回退函数的合约"Test"。
        test = Test(_test);
    }
    // 调用此函数时，传入的eth值。
    function pay1() public payable returns(uint256) {
        return msg.value;
    }
    // 本合约地址的余额值，本次调用函数时传入的eth值也计算在内。
    function pay2() public payable returns(uint256) {
        return address(this).balance;
    }
    // A：函数不使用 payable 修饰符，调用时可以传入eth，也可以不传入eth，都可以调用成功，但转入的eth不会到账。
    function payA() public pure returns(bool) {
        return (true);
    }
    // B：函数使用 payable 修饰符，调用时可以传入eth，也可以不传入eth，都可以调用成功，转入的eth会到账。
    function payB() public payable returns(bool) {
        return (true);
    }
    // C：transfer()，转入0个eth，会触发 Test 合约的 receive() 函数。
    function payC() public payable returns(bool) {
        payable(address(test)).transfer(0 ether);   // 从本合约余额支付，没有的话，调用此函数时需传入足够量的eth。
        return (true);
    }
    // D：transfer()，转入2个eth，会触发 Test 合约的 receive() 函数，前提是本合约余额有足够的eth支付。
    function payD() public payable returns(bool) {
        payable(address(test)).transfer(2 ether);   // 从本合约余额支付，没有的话，调用此函数时需传入足够量的eth。
        return (true);
    }
    // E：call()，不转入eth，会触发 Test 合约的 receive() 函数。
    function payE() public payable returns(bool, bytes memory) {
        (bool success, bytes memory data) = address(test).call(""); // 从本合约余额支付，没有的话，调用此函数时需传入足够量的eth。
        return (success, data);
    }
    // F：call()，转入0个eth，会触发 Test 合约的 receive() 函数。
    function payF() public payable returns(bool, bytes memory) {
        (bool success, bytes memory data) = address(test).call{value: 0 ether}(""); // 从本合约余额支付，没有的话，调用此函数时需传入足够量的eth。
        return (success, data);
    }
    // G：call()，转入2个eth，会触发 Test 合约的 receive() 函数，前提是本合约有足够的eth支付。
    function payG() public payable returns(bool, bytes memory) {
        (bool success, bytes memory data) = address(test).call{value: 2 ether}(""); // 从本合约余额支付，没有的话，调用此函数时需传入足够量的eth。
        return (success, data);
    }
    // H：test1()，其它合约函数调用，直接调用不使用 payable 修饰符的函数，传入eth时，编译错误。
    // TypeError: Cannot set option "value" on a non-payable function type.
    // 类型错误：不能在非支付函数类型上设置“value”选项。
    function payH() public payable {
        // test.test1{value: msg.value}(213);
    }
    // I：test1()，其它合约函数调用，直接调用不使用 payable 修饰符的函数，不传入eth，正常调用。
    function payI() public payable {
        test.test1(213);
    }
    // J：test1()，其它合约函数调用，call调用不使用 payable 修饰符的函数，传入eth时，本函数调用成功，call函数调用返回false，eth只打到了本合约余额，不会转到对方合约余额。
    function payJ() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test1(uint256)", 213);
        (bool success, bytes memory data) = address(test).call{value: msg.value}(msgData);
        return (success, data);
    }
    // K：test1()，其它合约函数调用，call调用不使用 payable 修饰符的函数，不传入eth，正常调用。
    function payK() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test1(uint256)", 213);
        (bool success, bytes memory data) = address(test).call(msgData);
        return (success, data);
    }
    // L：test2()，其它合约函数调用，直接调用使用 payable 修饰符的函数，传入eth时，正常调用，不会触发 Test 合约的 receive() 函数。
    function payL() public payable {
        test.test2{value: msg.value}(213);
    }
    // M：test2()，其它合约函数调用，直接调用使用 payable 修饰符的函数，不传入eth，正常调用，不会触发 Test 合约的 receive() 函数。
    function payM() public payable {
        test.test2(213);
    }
    // N：test2()，其它合约函数调用，call调用使用 payable 修饰符的函数，传入eth时，正常调用，不会触发 Test 合约的 receive() 函数。
    function payN() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test2(uint256)", 213);
        (bool success, bytes memory data) = address(test).call{value: msg.value}(msgData);
        return (success, data);
    }
    // O：test2()，其它合约函数调用，call调用使用 payable 修饰符的函数，不传入eth，正常调用，不会触发 Test 合约的 receive() 函数。
    function payO() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test2(uint256)", 213);
        (bool success, bytes memory data) = address(test).call(msgData);
        return (success, data);
    }
    // P：fallback 为 payable 时测试，调用合约不存在的函数，传入eth时，本函数调用成功，call函数调用返回true，会触发 Test 合约的 fallback() 函数，eth会打到对方合约账户余额。
    function payP() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test(uint256)", 213);
        (bool success, bytes memory data) = address(test).call{value: msg.value}(msgData);
        return (success, data);
    }
    // Q：fallback 为 payable 时测试，调用合约不存在的函数，不传入eth时，本函数调用成功，call函数调用返回true，会触发 Test 合约的 fallback() 函数。
    function payQ() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test(uint256)", 213);
        (bool success, bytes memory data) = address(test).call(msgData);
        return (success, data);
    }
    // R：fallback 无 payable 时测试，调用合约不存在的函数，传入eth时，本函数调用成功，call函数调用返回false，不会触发 Test 合约的 fallback() 函数，eth不会打到对方合约账户余额。
    function payR() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test(uint256)", 213);
        (bool success, bytes memory data) = address(test).call{value: msg.value}(msgData);
        return (success, data);
    }
    // S：fallback 无 payable 时测试，调用合约不存在的函数，不传入eth时，本函数调用成功，call函数调用返回true，会触发 Test 合约的 fallback() 函数。
    function payS() public payable returns(bool, bytes memory) {
        // 生成 msg.data 值
        bytes memory msgData = abi.encodeWithSignature("test(uint256)", 213);
        (bool success, bytes memory data) = address(test).call(msgData);
        return (success, data);
    }
}
