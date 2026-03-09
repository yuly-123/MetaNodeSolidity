// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/*
 * 当你声明一个 public 状态变量时，编译器会自动为它生成一个同名的 Getter 函数。
 */
interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract ERC20 is IERC20 {
    mapping(address => uint256) public balanceOf;
    // 状态变量自动生成的 Getter 函数
    // 0x70a08231
    bytes4 public selector = bytes4(keccak256("balanceOf(address)"));
    // 低级调用本合约
    // 0x70a082310000000000000000000000005b38da6a701c568545dcfcb03fcb875f56beddc4
    bytes public cSelector = abi.encodeWithSelector(0x70a08231, 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);

    fallback() external  {

    }
    constructor(address addr) {
        balanceOf[addr] = 312;  // 使用状态变量访问
    }
}

contract Customer {
    function show(address addr) external returns(uint256) {
        ERC20 erc = new ERC20(addr);
        // 下面这行代码会编译报错
        // TypeError: Indexed expression has to be a type, mapping or array (is function (address) view external returns (uint256))
        // erc.balanceOf[addr];
        return erc.balanceOf(addr); // 无法使用状态变量访问，只能使用 Getter 函数访问
    }
}
