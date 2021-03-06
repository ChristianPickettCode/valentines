const main = async () => {
  const Contract = await ethers.getContractFactory("Valentines");

  const contract = await Contract.deploy();
  await contract.deployed();
  console.log("Contract deployed to:", contract.address);

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
  console.log(tokenURI);
  };
  
  const runMain = async () => {
    try {
      await main();
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
  
  runMain();