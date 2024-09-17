import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect } from "chai";
  import hre from "hardhat";
  
  describe("Ludo game", function () {
    // We define a fixture to reuse the same setup in every test.
    // We use loadFixture to run this setup once, snapshot that state,
    // and reset Hardhat Network to that snapshot in every test.
    async function deployLudoGame() {
    
      // Contracts are deployed using the first signer/account by default
      const [owner, otherAccount, signer2] = await hre.ethers.getSigners();

    
     const ludoGame = await hre.ethers.getContractFactory("LudoGame");
     const LudoGame = await ludoGame.deploy();

  
      return { LudoGame, otherAccount, signer2 };
    }
  
    describe("Deployment", function () {
      it("Should deploy successfully", async function () {
        const { LudoGame, otherAccount, signer2 } = await loadFixture(deployLudoGame);
  
        expect(await LudoGame.currentPlayerIndex()).to.equal(0);
      });
  
    });
  
    
  });
  