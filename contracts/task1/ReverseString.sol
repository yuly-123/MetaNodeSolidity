// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * 反转字符串 (Reverse String)
 * 反转一个字符串。输入 "abcde"，输出 "edcba"
 */
contract ReverseString {
    function reverseString(string memory s) public pure returns (string memory rs) {
        bytes memory sBytes = bytes(s);
        bytes memory rsBytes = new bytes(sBytes.length);

        uint256 j = 0;
        for (uint256 i = sBytes.length - 1; i >= 0; i--) {
            rsBytes[j] = sBytes[i];
            j++;
            if (i == 0) {
                break;
            }
        }

        return string(rsBytes);
    }
}
