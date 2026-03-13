// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

// UniswapV2闪电贷回调接口
interface IUniswapV2Callee
{
    function uniswapV2Call(address sender, uint amount0, uint amount1, bytes calldata data) external;
}

// 工厂合约，两个代币生成一个合约。
interface IUniswapV2Factory
{
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}

// 由工厂合约创建的合约
interface IUniswapV2Pair
{
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function token0() external view returns (address);
    function token1() external view returns (address);
}

// 一种代币
interface IWETH is IERC20
{
    function deposit() external payable;
    function withdraw(uint amount) external;
}

library PoolAddress
{
    bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;

    struct PoolKey {
        address token0;
        address token1;
        uint24 fee;
    }

    function getPoolKey(address tokenA, address tokenB, uint24 fee) internal pure returns (PoolKey memory) {
        if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
        return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
    }

    function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
        require(key.token0 < key.token1);
        pool = address(
            uint160(
                uint(
                    keccak256(
                        abi.encodePacked(
                            hex"ff",
                            factory,
                            keccak256(abi.encode(key.token0, key.token1, key.fee)),
                            POOL_INIT_CODE_HASH
                        )
                    )
                )
            )
        );
    }
}

interface IUniswapV3Pool
{
    function flash(address recipient, uint amount0, uint amount1, bytes calldata data) external;
}

// AAVE V3 Pool interface
interface ILendingPool {
    // flashloan of single asset
    function flashLoanSimple(address receiverAddress, address asset, uint256 amount, bytes calldata params, uint16 referralCode) external;
    // get the fee on flashloan, default at 0.05%
    function FLASHLOAN_PREMIUM_TOTAL() external view returns (uint128);
}
