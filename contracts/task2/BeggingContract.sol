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
        payable(msg.sender).transfer(address(this).balance);

        emit WithdrawEvent(msg.sender, address(this).balance);
    }

    // 查询
    function getDonation(address donor) public view returns(uint256) {
        return donations[donor];
    }
}
