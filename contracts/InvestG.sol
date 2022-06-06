//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


import "hardhat/console.sol";
import "./InvestTokenG.sol";

contract InvestG {
    InvestTokenG investTokenG;
    mapping(address => uint256) public tokenInvestments;
    mapping(address => uint256) public etherInvestments;
    
    address owner;

    constructor(InvestTokenG _token) {
        require(address(_token) != address(0), "Zero address is not allowed!");
        investTokenG = _token;
		owner = msg.sender;
    } 

    function invest(uint256 _tokenval ) external payable {
        console.log(block.number);
        
        
        if(msg.value > 0) {
            etherInvestments[msg.sender] = msg.value;
        } else {
            tokenInvestments[msg.sender] = _tokenval;
        }
        

    }

    function percents() private {
        tokenInvestments[msg.sender] +=  tokenInvestments[msg.sender] * 105 / 100 - tokenInvestments[msg.sender];
        etherInvestments[msg.sender] +=  etherInvestments[msg.sender] * 105 / 100 - tokenInvestments[msg.sender];
    }

    function withdrawEth(uint256 _amount) external {
		require(_amount <= address(this).balance, "Error");
		payable(msg.sender).transfer(_amount);
	}

    function withdrawToken(uint256 _amount) external {
		require(_amount <= address(this).balance, "Error");
		payable(msg.sender).transfer(_amount);
	}
}
