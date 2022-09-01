// SPDX-License-Identifier: GPL-3
// classic reentrancy vuln

pragma solidity 0.8.7;

contract FortKnot {
  mapping (address => uint256) public balances;

  function deposit() external payable {
    balances[msg.sender] += msg.value;
  }

  function withdraw() external {
    uint256 balance = balances[msg.sender];
    require(balance > 0, "withdraw what");
      (bool success, ) = msg.sender.call{value: balance}("");  // ext call before accounting
      require(success, "withdraw how");
      balances[msg.sender] = 0;
    }
}
