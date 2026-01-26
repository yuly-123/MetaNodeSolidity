// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

// 在一个有序数组中查找目标值。
contract BinarySearch {
    function search(uint256[] memory nums, uint256 value) public pure returns(uint256) {
        uint256 left = 0;
        uint256 right = nums.length;

        while(true) {
            uint256 middle = (right + left) / 2;
            if (value == nums[middle]) {
                return middle;
            } else if (value < nums[middle]) {
                right = middle;
            } else if (value > nums[middle]) {
                left = middle;
            }
            if (left+1 == right) {    // 最后一组范围都没有返回middle，value在nums中不存在
                return 0;
            }
        }
        return 0;
    }
}
