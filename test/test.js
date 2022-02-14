const { ethers } = require("hardhat");

describe("Valentines", function () {
  it("Should mint 1 NFT", async function () {
    const Contract = await ethers.getContractFactory("Valentines");

    const contract = await Contract.deploy();
    await contract.deployed();

    let lines = [
      "Roses are red",
      "Violets are blue",
      "Have a great day",
      "Because I love you",
      "",
      "",
      "",
      ""
    ]
    let mintTxn = await contract.mint(lines);
    await mintTxn.wait();

    // Check the tokenURI
    let tokenURI = await contract.tokenURI(0);
    // console.log(tokenURI);
  });
});