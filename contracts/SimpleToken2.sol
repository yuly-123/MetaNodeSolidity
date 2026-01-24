// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract SimpleToken {
    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public _allowances;

    constructor() {
        _balances[msg.sender] = 100 * 10**18;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(_balances[msg.sender] >= amount, "Insufficient balance");
        _balances[msg.sender] -= amount;
        _balances[to] += amount;
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        require(_allowances[from][msg.sender] >= amount, "Insufficient allowance");
        require(_balances[from] >= amount, "Insufficient balance");
        
        _allowances[from][msg.sender] -= amount;
        _balances[from] -= amount;
        _balances[to] += amount;
        return true;
    }
}

contract TokenSwap {
    IERC20 public tokenA;

    constructor(address _tokenA) {
        tokenA = IERC20(_tokenA);
    }

    function swap(uint256 amountA) external {
        tokenA.transferFrom(msg.sender, address(this), amountA);
        // tokenA.transfer()里面的代码中msg.sender是谁，是当前合约地址，还是钱包账户地址。
    }
}
