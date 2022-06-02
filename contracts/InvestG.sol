//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract InvestG is ERC20 {
    mapping(address => uint256) public tokenInvestments;
    mapping(address => uint256) public etherInvestments;
    uint16 countedBlock = 0;
    address owner;

    constructor() ERC20("InvestG", "ING") {
		owner = msg.sender;
    }

	modifier onlyOwner {
		require(msg.sender == owner, "CoinFlip: Only owner");
		_;
	}

    function invest(uint256 _tokenval ) external payable {
        countedBlock++;
        
        if(msg.value > 0) {
            etherInvestments[msg.sender] = msg.value;
        } else {
            tokenInvestments[msg.sender] = _tokenval;
        }
        if(countedBlock == 5) {
            percents(msg.sender);
            countedBlock = 0; 
        }

    }

    function percents(address _investor) private {
        tokenInvestments[_investor] +=  tokenInvestments[_investor] * 5 / 100;
        etherInvestments[_investor] +=  etherInvestments[_investor] * 5 / 100;
    }

    function withdrawEth(uint256 _amount) payable external onlyOwner {
		require(_amount <= address(this).balance, "Error");
		payable(msg.sender).transfer(_amount);
	}

    function withdrawToken(uint256 _amount) external onlyOwner {
		require(_amount <= address(this).balance, "Error");
		payable(msg.sender).transfer(_amount);
	}
}
