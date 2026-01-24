// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * 募集资金，目标10ETH，最少捐献1ETH，限时7天，成功募集，从合约取出资金，超时募集不足，捐献者调用接口取回资金。
 */
contract Crowdfunding {
    enum State { Fundraising, Success, Failed, Withdrawn }// 募集状态：募集中，成功，失败，已提取。
    State public currentState;// 当前募集状态
    address public immutable owner;// 项目发起人
    uint256 public immutable deadline;// 筹款截止时间
    uint256 public immutable goalAmount;// 目标筹款金额（wei）
    uint256 public constant MIN_CONTRIBUTION = 1 ether;// 最小捐献金额
    uint256 public currentRaisedAmount;// 当前筹款金额（wei）
    mapping(address => uint256) public contributions;// 每个地址的捐献金额
    event StateChanged(State newState);
    event ContributionReceived(address indexed contributor, uint256 amount, uint256 currentTotal);// 捐献
    event FundsWithdrawn(address indexed recipient, uint256 amount);// 提取
    event RefundIssued(address indexed contributor, uint amount);// 返还

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    modifier inState(State _state) {
        require(currentState == _state, "Invalid state");
        _;
    }
    constructor(uint _goalAmount, uint _durationInMinutes) {
        require(_goalAmount > 0, "Invalid amount");
        require(_durationInMinutes > 0 && _durationInMinutes <= 90, "Invalid duration");
        owner = msg.sender;
        deadline = block.timestamp + (_durationInMinutes * 1 minutes);
        goalAmount = _goalAmount;
        currentState = State.Fundraising;
        emit StateChanged(currentState);
    }
    // 捐献
    function contribute() public payable inState(State.Fundraising) {
        require(msg.value >= MIN_CONTRIBUTION, "Contribution must be at least MIN_CONTRIBUTION");
        require(block.timestamp <= deadline, "Crowdfunding has ended");

        contributions[msg.sender] += msg.value;
        currentRaisedAmount += msg.value;

        if (currentRaisedAmount >= goalAmount) {
            currentState = State.Success;
            emit StateChanged(currentState);
        }

        emit ContributionReceived(msg.sender, msg.value, currentRaisedAmount);
    }
    // 提取
    function withdrawFunds() public onlyOwner inState(State.Success) {
        currentState = State.Withdrawn;
        emit StateChanged(currentState);

        uint256 amount = address(this).balance;
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Failed to withdraw Funds");

        emit FundsWithdrawn(owner, amount);
    }
    // 返还
    function refund() public inState(State.Failed) {
        uint256 amountToRefund = contributions[msg.sender];
        require(amountToRefund > 0, "No contribution to refund");
        
        contributions[msg.sender] = 0;
        (bool success, ) = payable(msg.sender).call{value: amountToRefund}("");
        require(success, "Failed to refund");
        
        emit RefundIssued(msg.sender, amountToRefund);
    }
}
