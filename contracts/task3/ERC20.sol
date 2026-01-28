// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    mapping(address account => uint256 amount) private _balances;
    mapping(address account => mapping(address apender => uint256 amount)) private _allowances;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual returns(string memory) {
        return _name;
    }

    function symbol() public view virtual returns(string memory) {
        return _symbol;
    }

    function totalSupply() public view virtual returns(uint256) {
        return _totalSupply;
    }

    function decimals() public view virtual returns(uint8) {
        return 18;
    }

    function balanceOf(address account) public view virtual returns(uint256) {
        return _balances[account];
    }

    function allowance(address owner, address spender) public view virtual returns(uint256) {
        return _allowances[owner][spender];
    }

    // 转账
    function transfer(address to, uint256 value) public virtual returns(bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            _totalSupply += value;  // 凭空造币
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked { _balances[from] = fromBalance - value; }
        }

        if (to == address(0)) {
            unchecked { _totalSupply -= value; }    // 销毁币
        }else {
            unchecked { _balances[to] += value; }
        }

        emit Transfer(from, to, value);
    }

    // 授权
    function approve(address spender, uint256 value) public virtual returns(bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    // 授权转账
    function transferForm(address from, address to, uint256 value) public virtual returns(bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);  // 检查授权额度
        _transfer(from, to, value);
        return true;
    }

    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);  // 当前授权额度
        if (currentAllowance < type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked { _approve(owner, spender, value, false); }
        }
    }

    // 造币
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    // 销毁
    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }
}
