// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * 讨饭
 */
contract BeggingContract is Ownable {
    mapping(address => uint256) private donations;// 每个地址的捐献金额

    event DonateEvent(address indexed donor, uint256 amount);// 捐献事件
    event WithdrawEvent(address indexed payee, uint256 amount);// 提取事件

    constructor() Ownable(msg.sender) {

    }

    // 捐赠
    function donate() public payable {
        require(msg.value > 0, "invalid amount");
        donations[msg.sender] += msg.value;

        emit DonateEvent(msg.sender, msg.value);
    }

    // 提取
    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        // 使用 Sepolia fork 环境调用会失败
        // payable(msg.sender).transfer(amount);

        // 使用 Sepolia fork 环境没有报错，合约账户余额清零，但钱包没有收到钱
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "call failed");

        emit WithdrawEvent(msg.sender, amount);
    }

    // 查询
    function getDonation(address donor) public view returns(uint256) {
        return donations[donor];
    }
}
