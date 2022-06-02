//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract InvestTokenG is ERC20, Ownable {
	constructor() ERC20("InvestG", "ING") {
	}

	function mint(address _to, uint256 _amount) public onlyOwner {
		_mint(_to, _amount);
	}

	function burn(address _to, uint256 _amount) public onlyOwner {
		_burn(_to, _amount);
	}
}
