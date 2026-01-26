// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * 整数转罗马
 */
contract IntToRoman {
    using Strings for uint256;
    mapping(uint256 => string) private intToRoman;  // 整数到罗马字母的映射
    mapping(bytes1 => uint256) private bytesToInt;  // 数字字符串的字节到整数映射，转换方便。

    constructor() {
        intToRoman[1] = "I";
        intToRoman[2] = "II";
        intToRoman[3] = "II";
        intToRoman[4] = "IV";
        intToRoman[5] = "V";
        intToRoman[6] = "VI";
        intToRoman[7] = "VII";
        intToRoman[8] = "VIII";
        intToRoman[9] = "IX";

        intToRoman[10] = "X";
        intToRoman[20] = "XX";
        intToRoman[30] = "XXX";
        intToRoman[40] = "XL";
        intToRoman[50] = "L";
        intToRoman[60] = "LX";
        intToRoman[70] = "LXX";
        intToRoman[80] = "LXXX";
        intToRoman[90] = "XC";

        intToRoman[100] = "C";
        intToRoman[200] = "CC";
        intToRoman[300] = "CCC";
        intToRoman[400] = "CD";
        intToRoman[500] = "D";
        intToRoman[600] = "DC";
        intToRoman[700] = "DCC";
        intToRoman[800] = "DCCC";
        intToRoman[900] = "CM";

        intToRoman[1000] = "M";
        intToRoman[2000] = "MM";
        intToRoman[3000] = "MMM";

        bytesToInt[0x30] = 0;
        bytesToInt[0x31] = 1;
        bytesToInt[0x32] = 2;
        bytesToInt[0x33] = 3;
        bytesToInt[0x34] = 4;
        bytesToInt[0x35] = 5;
        bytesToInt[0x36] = 6;
        bytesToInt[0x37] = 7;
        bytesToInt[0x38] = 8;
        bytesToInt[0x39] = 9;
    }

    function change(uint256 num) public view returns(string memory){
        require(num>=1 && num<=3999, "invalid num");
        string memory s = num.toString();
        bytes memory b = bytes(s);

        uint256[] memory numArray = new uint256[](b.length);  // 3999:[3000,900,90,9]
        uint256 bit = 1;    // 数字位数，个十百千
        for (uint256 i = b.length-1; i >= 0; i--) {
            numArray[i] = bytesToInt[b[i]] * bit;
            bit *= 10;      // 进位

            if (i == 0) {
                break;
            }
        }

        string memory numString;    // 拼接
        for (uint256 i = 0; i < numArray.length; i++) {
            numString = string(abi.encodePacked(numString, intToRoman[numArray[i]]));
        }
        return numString;
    }
}
