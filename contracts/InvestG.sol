//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./InvestTokenG.sol";

contract InvestG {
    InvestTokenG investTokenG;
    mapping(address => uint256) public tokenInvestments;
    mapping(address => uint256) public etherInvestments;
    uint16 countedBlock = 0;
    address owner;

    constructor() {
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
            percents();
            countedBlock = 0; 
        }

    }

    function percents() private {
        tokenInvestments[msg.sender] +=  tokenInvestments[msg.sender] * 105 / 100 - tokenInvestments[msg.sender];
        etherInvestments[msg.sender] +=  etherInvestments[msg.sender] * 105 / 100 - tokenInvestments[msg.sender];
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
