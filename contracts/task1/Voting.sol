// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * 创建一个名为Voting的合约，包含以下功能：
 * 一个mapping，来存储候选人的得票数
 * 一个vote函数，允许用户投票给某个候选人
 * 一个getVotes函数，返回某个候选人的得票数
 * 一个resetVotes函数，重置所有候选人的得票数
 */
contract Voting {
    mapping(address => uint256) private candidateVote;  // 候选人得票数
    address[] private candidateArrys;                   // 候选人数组
    mapping(address => bool) private voter;             // 投票人是否投票

    // 投票
    function vote(address candidate) public {
        require(candidate != msg.sender, "can not vote for self");
        require(!voter[msg.sender], "only vote once");
        voter[msg.sender] = true;                       // 标记投票

        if (candidateVote[candidate] == 0) {
            candidateArrys.push(candidate);             // 收集候选人地址
        }
        candidateVote[candidate] += 1;                  // 候选人票数加一
    }
    // 返回某个候选人的得票数
    function getVotes(address candidate) public view returns(uint256) {
        return candidateVote[candidate];
    }
    // 重置所有候选人的得票数
    function resetVotes() public {
        uint256 len = candidateArrys.length;
        for (uint256 i = 0; i < len; i++) {
            delete candidateVote[candidateArrys[i]];    // 清空候选人得票数
        }
        delete candidateArrys;                          // 清空候选人数组
    }
    // 返回候选人数组
    function getCandidateArrays() public view returns(address[] memory) {
        return candidateArrys;
    }
}
