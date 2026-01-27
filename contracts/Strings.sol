// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

library HyStrings {
    // 字符串转整数
    function stringToUint(string memory s) public pure returns(uint256) {
        bytes memory b = bytes(s);
        uint256 result = 0;
        for (uint256 i = 0; i < b.length; i++) {
            uint256 digit = uint256(uint8(b[i]));
            require(digit >= 48 && digit <=57, "Invalid character");// ASCII '0' = 48
            digit = digit - 48;
            result = result * 10 + digit;   // 每一次都把前面的数扩大10倍
        }
        return result;
    }
}
