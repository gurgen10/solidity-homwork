const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
	ethers: {
    utils:{ parseEther },
		getContractFactory,
    getSigners,
		BigNumber,
		getNamedSigners
	}
} = require("hardhat");

describe("InvestG", function () {
  let investG, caller1, caller2;
	beforeEach("Before: ", async () => {
		[caller1, caller2] = await ethers.getSigners();
		const InvestTokenG = await hre.ethers.getContractFactory("InvestTokenG");
		const investTokenG =  await InvestTokenG.deploy();

    await investTokenG.deployed();

		const InvestG = await hre.ethers.getContractFactory("InvestG");
    investG = await InvestG.deploy(investTokenG.address);
    
    await investG.deployed();
    
    console.log("investTokenG deployed to:", investTokenG.address);
    console.log("InvestG deployed to:", investG.address);
	});
  it("Should invest token", async function () {
    await investG.connect(caller2).invest(parseEther("10000000"));
    
    
    expect(await investG.tokenInvestments(caller2.address)).to.eq(parseEther("10000000"))
    expect(await investG.tokenInvestments(caller1.address)).to.eq(parseEther("0"))
  });
  it("Should invest ether", async function () {
    await investG.connect(caller2).invest(parseEther("0"));
    
    expect(await investG.tokenInvestments(caller2.address)).to.eq(parseEther("1001"))
    expect(await investG.tokenInvestments(caller1.address)).to.eq(parseEther("1000"))
  });
});
