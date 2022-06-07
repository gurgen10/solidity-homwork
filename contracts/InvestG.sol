//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "hardhat/console.sol";
import "./InvestTokenG.sol";

contract InvestG {
    using SafeERC20 for InvestTokenG;
    InvestTokenG public investTokenG;
    mapping(address => uint256) public tokenInvestments;
    mapping(address => uint256) public etherInvestments;
    mapping(address => uint256) public tokenRewards;
    mapping(address => uint256) public etherRewards;
    mapping(address => uint256[]) public blockNumbers;
    uint256 public tokenReword;
    uint256 public etherReword;

    constructor(address _token) {
        require(address(_token) != address(0), "Zero address is not allowed!");
        investTokenG = InvestTokenG(_token);
    } 

    function invest(uint256 _tokenVal ) external payable {
        require(_tokenVal > 0 || msg.value > 0, "Amount cant't be zero!");
        
        if(_tokenVal > 0) {
            tokenInvestments[msg.sender] += _tokenVal;
        } else {
            etherInvestments[msg.sender] += msg.value;
        }
        addBlockNumbers();
        percents(_tokenVal);
    }

    function withdrawEth(uint256 _amount) external {
		require(_amount <= address(this).balance, "Error");
		payable(msg.sender).transfer(_amount);
        tokenInvestments[msg.sender]  -= _amount;
	}

    function withdrawToken(uint256 _amount) external {
		require(_amount <= address(this).balance, "Error");
		investTokenG.safeTransfer(msg.sender, _amount);
        tokenInvestments[msg.sender]  -= _amount;
	}
    function claimToken() external {
        investTokenG.safeTransfer(msg.sender, tokenRewards[msg.sender]);
        tokenRewards[msg.sender] = 0;
    }
    function claimEther() external {
        payable(msg.sender).transfer(etherRewards[msg.sender]);
        etherRewards[msg.sender] = 0;
    }


    function checkRewardBlokNumber() private view returns(bool) {
        return blockNumbers[msg.sender].length == 5;
    }
    function percents (uint256 _amount) private {
        if(checkRewardBlokNumber()) {
            delete blockNumbers[msg.sender];
            if(_amount == 0) {
                etherRewards[msg.sender] += msg.value * 105 / 100 - msg.value;
            } else {
                tokenRewards[msg.sender] += _amount * 105 / 100 - _amount;
            }
        }
    }
    function addBlockNumbers() private {
        if(blockNumbers[msg.sender].length == 0) {
            blockNumbers[msg.sender].push(block.number);
        } else if(block.number != blockNumbers[msg.sender][ blockNumbers[msg.sender].length-1]) {
            blockNumbers[msg.sender].push(block.number);
        }
    }
}
