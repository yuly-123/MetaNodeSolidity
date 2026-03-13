// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "forge-std/Test.sol";
import "../contracts/Flashloan/UniswapV2Flashloan.sol";

address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

contract UniswapV2FlashloanTest is Test
{
    IWETH private weth = IWETH(WETH);
    UniswapV2Flashloan private flashloan;
    function setUp() public {
        flashloan = new UniswapV2Flashloan();
    }

    function testFlashloan() public {
        // 换weth，并转入flashloan合约，用做手续费
        weth.deposit{value: 1e18}();                // 存款，钱包账户地址 到 weth 合约，转入实际的ETH，获得ERC20代币，
        weth.transfer(address(flashloan), 1e18);    // 借钱，weth 合约中的代币，钱包账户地址 转到 闪电贷地址，
        flashloan.flashloan(100 * 1e18);            // 闪电贷
    }

    // 手续费不足，会revert
    function testFlashloanFail() public {
        // 换weth，并转入flashloan合约，用做手续费
        weth.deposit{value: 1e18}();                // 存款，钱包账户地址 到 weth 合约，转入实际的ETH，获得ERC20代币，
        weth.transfer(address(flashloan), 3e17);    // 借钱，weth 合约中的代币，钱包账户地址 转到 闪电贷地址，
        vm.expectRevert();                          // 手续费不足
        flashloan.flashloan(100 * 1e18);            // 闪电贷
    }
}
