// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./IERC20.sol";

contract CRORE is IERC20 {
    uint256 public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    string public name = "Crore Coin";
    string public symbol = "CRO";
    uint8 public decimals = 7;

    constructor(uint256 total) {
        totalSupply = total;
        balanceOf[msg.sender] = totalSupply;
    }

    error NotEnoughFunds(uint requested, uint available);

    function transfer(address recipient, uint amount) external returns (bool) {
        if (balanceOf[msg.sender] < amount) {
            revert NotEnoughFunds({requested: amount, available: balanceOf[msg.sender]});
        }
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        if (balanceOf[msg.sender] < amount) {
            revert NotEnoughFunds({requested: amount, available: balanceOf[msg.sender]});
        }
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    error LackApprovedFunds(uint requested, uint approved);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        uint approvedFunds = allowance[sender][msg.sender];
        if (approvedFunds < amount) {
            revert LackApprovedFunds({requested: amount, approved: approvedFunds});
        }
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }
}
