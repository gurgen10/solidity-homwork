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
		[caller1, caller2] = await getSigners();
		const InvestTokenG = await hre.ethers.getContractFactory("InvestTokenG");
		const investTokenG =  await InvestTokenG.deploy();

    await investTokenG.deployed();

		const InvestG = await getContractFactory("InvestG");
    investG = await InvestG.deploy(investTokenG.address);
    
    await investG.deployed();
    
    console.log("investTokenG deployed to:", investTokenG.address);
    console.log("InvestG deployed to:", investG.address);
	});

  describe("Investment", () => {
    it("Should invest token", async function () {
      await investG.connect(caller2).invest(parseEther("10000000"));
      
      
      expect(await investG.tokenInvestments(caller2.address)).to.eq(parseEther("10000000"))
      expect(await investG.tokenInvestments(caller1.address)).to.eq(parseEther("0"))
    });
    
    it("Should invest ether", async function () {
      await investG.connect(caller2).invest("0", { value: parseEther("10") });
      
      expect(await investG.etherInvestments(caller2.address)).to.eq(parseEther("10"))
      expect(await investG.etherInvestments(caller1.address)).to.eq(parseEther("0"))
    });
  })
  describe("Claiming", () => {
    it("Should claim token", async () => {
      for (let index = 0; index < 5; index++) {
        await investG.invest(parseEther("1"));

      }
      let reward = 1 * 5 / 100;

      
      
      expect(await investG.tokenRewards(caller1.address)).to.eq(parseEther(reward.toString()))
      await investG.claimToken()
      // expect(await investG.connect(caller2).tokenRewards(caller2.address)).to.eq(parseEther("0"))

      
    })
  })
});

