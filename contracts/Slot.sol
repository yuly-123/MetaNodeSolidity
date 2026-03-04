// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract Slot {
    uint256 public x = 42; // 位于 slot 0
    uint256 public y = 88; // 位于 slot 1

    function getSlotInfo() public pure returns (uint256 slotX, uint256 slotY) {
        assembly {
            slotX := x.slot // 结果为 0
            slotY := y.slot // 结果为 1
        }
    }
}
