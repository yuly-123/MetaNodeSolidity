// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract UserManager {
    address[] public users;                     // 存储用户地址
    mapping(address => bool) public isUser;     // 用户是否存在
    mapping(address => uint) public userIndex;  // 用户在数组中的下标
    uint public constant MAX_USERS = 1000;      // 用户地址数组的元素个数上限

    // 添加用户
    function addUser(address user) public {
        require(user != address(0), "Invalid address");             // 用户地址不能是0地址
        require(!isUser[user], "User already exists");              // 如果用户已经存在，不能重复添加用户
        require(users.length < MAX_USERS, "Maximum users reached"); // 用户地址数组元素个数不能超过1000个

        users.push(user);                   // 用户地址数组
        isUser[user] = true;                // 用户是否存在
        userIndex[user] = users.length - 1; // 用户地址在数组中的下标
    }

    // 删除用户（快速删除）
    function removeUser(address user) public {
        require(isUser[user], "User does not exist");   // 用户必须存在

        uint index = userIndex[user];       // 取得用户在数组中的下标
        uint lastIndex = users.length - 1;  // 取得用户数组的最后一个元素的下标

        if(index != lastIndex) {            // 如果不是最后一个元素，用最后一个替换
            address lastUser = users[lastIndex];    // 获取数组中最后一个用户
            users[index] = lastUser;        // 要删除的用户替换为最后一个用户
            userIndex[lastUser] = index;    // 更新最后一个用户元素的下标为删除的位置
        }

        users.pop();                        // 删除数组中最后一个元素
        delete isUser[user];                // 用户是否存在改为false
        delete userIndex[user];             // 用户在数组中的下标位置改为0（有疑问）
    }

    // 获取指定范围的用户
    function getUsersRange(uint start, uint end) public view returns (address[] memory) {
        require(start < end, "Invalid range");
        require(end <= users.length, "End exceeds array length");

        address[] memory result = new address[](end - start);
        for(uint i = start; i < end; i++) {
            result[i - start] = users[i];
        }
        return result;
    }

    // 获取用户数量
    function getUserCount() public view returns (uint) {
        return users.length;
    }

    // 获取所有用户
    function getAllUsers() public view returns (address[] memory) {
        return users;
    }
}
