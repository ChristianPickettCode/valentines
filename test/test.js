const { ethers } = require("hardhat");

describe("Valentines", function () {
  it("Should mint 1 NFT", async function () {
    const Contract = await ethers.getContractFactory("Valentines");

    const contract = await Contract.deploy();
    await contract.deployed();

    let lines = [
      "flowers flow",
      "flowers fly",
      "flowers bloom",
      "flowers die",
      "flowers blow",
      "flowers dance",
      "flowers love",
      "flowers prance"
    ]
    let mintTxn = await contract.mint(lines);
    await mintTxn.wait();

    // Check the tokenURI
    let tokenURI = await contract.tokenURI(0);
    // console.log(tokenURI);
  });
});