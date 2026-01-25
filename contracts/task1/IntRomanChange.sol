// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * 整数转罗马数字
 */
contract IntRomanChange {
    // mapping(string => uint) private romanToInt; // 罗马字母到整数映射
    // mapping(string => uint) private romanToInt2;// 罗马字母到整数映射
    mapping(bytes1 => uint) private byteToInt;  // 罗马字母的字节到整数映射
    // mapping(bytes2 => uint) private byteToInt2; // 罗马字母的字节到整数映射

    constructor() {
        // romanToInt["I"] = 1;
        // romanToInt["V"] = 5;
        // romanToInt["X"] = 10;
        // romanToInt["L"] = 50;
        // romanToInt["C"] = 100;
        // romanToInt["D"] = 500;
        // romanToInt["M"] = 1000;
        // romanToInt2["IV"] = 4;
        // romanToInt2["IX"] = 9;
        // romanToInt2["XL"] = 40;
        // romanToInt2["XC"] = 90;
        // romanToInt2["CD"] = 400;
        // romanToInt2["CM"] = 900;
        byteToInt[0x49] = 1;
        byteToInt[0x56] = 5;
        byteToInt[0x58] = 10;
        byteToInt[0x4c] = 50;
        byteToInt[0x43] = 100;
        byteToInt[0x44] = 500;
        byteToInt[0x4d] = 1000;
        // byteToInt2[0x4956] = 4;
        // byteToInt2[0x4958] = 9;
        // byteToInt2[0x584c] = 40;
        // byteToInt2[0x5843] = 90;
        // byteToInt2[0x4344] = 400;
        // byteToInt2[0x434d] = 900;
    }

    function change(string memory s) public view returns(uint256){
        bytes memory romanNum = bytes(s);               // string转换成bytes
        uint256 len = romanNum.length;
        require(len>=1 && len<=15, "invalid string length");    // 1 <= s.length <= 15
        for (uint256 i = 0; i < len; i++) {
            require(byteToInt[romanNum[i]] != 0, "invalid string"); // s 仅含字符 ('I', 'V', 'X', 'L', 'C', 'D', 'M')
        }

        if (len == 1) {
            return byteToInt[romanNum[0]];  // 一个字母直接返回，不需要计算。
        }

        uint256[] memory numArray = new uint[](len);    // bytes转换成uint256
        for (uint256 i = 0; i < len; i++) {
            numArray[i] = byteToInt[romanNum[i]];
        }

        // 6种特殊情况计算：
        // I 可以放在 V (5) 和 X (10) 的左边，来表示 4 和 9。
        // X 可以放在 L (50) 和 C (100) 的左边，来表示 40 和 90。 
        // C 可以放在 D (500) 和 M (1000) 的左边，来表示 400 和 900。
        for (uint256 i = 0; i < len-1; i++) {           // 减1防止i+1数组下标越界
            if (numArray[i]==1 && numArray[i+1]==5) {
                numArray[i] = 0;
                numArray[i+1] = 4;
                i++;
            } else if (numArray[i]==1 && numArray[i+1]==10) {
                numArray[i] = 0;
                numArray[i+1] = 9;
                i++;
            } else if (numArray[i]==10 && numArray[i+1]==50) {
                numArray[i] = 0;
                numArray[i+1] = 40;
                i++;
            } else if (numArray[i]==10 && numArray[i+1]==100) {
                numArray[i] = 0;
                numArray[i+1] = 90;
                i++;
            } else if (numArray[i]==100 && numArray[i+1]==500) {
                numArray[i] = 0;
                numArray[i+1] = 400;
                i++;
            } else if (numArray[i]==100 && numArray[i+1]==1000) {
                numArray[i] = 0;
                numArray[i+1] = 900;
                i++;
            }
        }

        uint256 sum;            // 求和
        for (uint256 i = 0; i < len; i++) {
            sum += numArray[i];
        }
        return sum;
    }
}
