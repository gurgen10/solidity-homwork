const { expect } = require("chai");
const {
	ethers: {
    utils:{ parseEther },
		getContractFactory,
    getSigners,
		BigNumber,
	}
} = require("hardhat");

describe("InvestG", function () {
  let investG, caller1, caller2, caller3;
	before("Before: ", async () => {
		[caller1, caller2, caller3] = await getSigners();
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
      for (let index = 0; index <= 5; index++) {
        await investG.invest(parseEther("1"));
      }
      let reward = 1 * 5 / 100;

      expect(await investG.tokenRewards(caller1.address)).to.eq(parseEther(reward.toString()))
      await investG.claimToken()
      expect(await investG.connect(caller2).tokenRewards(caller2.address)).to.eq(parseEther("0"))
    })
    it("Should claim ether", async () => {
      for (let index = 0; index <= 5; index++) {
        await investG.invest("0",{ value: parseEther("1") });
      }
      let reward = 1 * 5 / 100;

      expect(await investG.etherRewards(caller1.address)).to.eq(parseEther(reward.toString()))
      await investG.claimToken()
      expect(await investG.connect(caller2).etherRewards(caller2.address)).to.eq(parseEther("0"))
    })
  })
  describe("Withdraw", () => {
    it("Should withdraw token", async () => {
      await investG.connect(caller3).invest(parseEther("1"));
      expect(await investG.connect(caller3).tokenInvestments(caller3.address)).to.eq(parseEther("1"))
      await investG.connect(caller3).withdrawToken(parseEther("0.5"));
      expect(await investG.connect(caller3).tokenInvestments(caller3.address)).to.eq(parseEther("0.5"))
    })
    it("Should withdraw ether", async () => {
      await investG.connect(caller3).invest("0", {value: parseEther("1.1")});
      expect(await investG.connect(caller3).etherInvestments(caller3.address)).to.eq(parseEther("1.1"))
      await investG.connect(caller3).withdrawEth(parseEther("0.5"));
      expect(await investG.connect(caller3).etherInvestments(caller3.address)).to.eq(parseEther("0.6"))
    })
  })
});

