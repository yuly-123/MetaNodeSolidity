// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

// 将两个有序数组合并为一个有序数组。
contract MergeSortedArray {
    function merge(uint256[] calldata a, uint256[] calldata b) public pure returns(uint256[] memory) {
        uint256 aLen = a.length;
        uint256 bLen = b.length;
        uint256[] memory c = new uint256[](aLen + bLen);    // 合并
        for (uint256 i = 0; i < aLen; i++) {
            c[i] = a[i];
        }
        for (uint256 i = 0; i < bLen; i++) {
            c[i+aLen] = b[i];
        }
        return c;
    }
}
