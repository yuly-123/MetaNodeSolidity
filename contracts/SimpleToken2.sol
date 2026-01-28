// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/**
 * 1.部署SimpleToken合约
 * 2.复制SimpleToken合约地址
 * 3.部署TokenSwap合约同时填入复制的SimpleToken合约地址，界面上VALUE框中，选择Ether，输入10个。
 * 4.调用SimpleToken合约的 approve 函数给 TokenSwap 合约地址授权"1000000000000000000"个。
 * 5.调用TokenSwap合约的swap()函数，输入"500000000000000000"个。
 * 6.查看日志decoded output：
 *  {
 *	    "0": "address: 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4", // 钱包账户地址
 *	    "1": "address: 0x3328358128832A260C76A4141e19E2A943CD4B6D"  // TokenSwap合约地址
 *  }
 */
interface IERC20 {
    function approve(address spender, uint256 amount) external;
    function transferFrom(address from, address to, uint256 amount) external returns(address);
}
contract SimpleToken {
    mapping(address => uint256) public _balances;
    mapping(address => mapping(address => uint256)) public _allowances;
    constructor() {
        _balances[msg.sender] = 100 * 10**18;
    }
    function approve(address spender, uint256 amount) external {
        _allowances[msg.sender][spender] = amount;
    }
    function transferFrom(address from, address to, uint256 amount) external returns(address) {
        _allowances[from][msg.sender] -= amount;
        _balances[from] -= amount;
        _balances[to] += amount;
        return msg.sender;
    }
}
contract TokenSwap {
    IERC20 public simpleToken;
    constructor(address _simpleToken) payable {
        simpleToken = IERC20(_simpleToken);
    }
    function swap(uint256 amount) public returns(address, address) {
        return (msg.sender, simpleToken.transferFrom(msg.sender, address(this), amount));
        // simpleToken.transferFrom()里面的代码中msg.sender是谁，是本合约TokenSwap地址，还是钱包账户地址。
        // 答：return (钱包账户地址，本合约TokenSwap地址);
        // 本合约账户中必须有足够的ETH来支付调用 simpleToken.transferFrom() 函数的gas费。
    }
}
