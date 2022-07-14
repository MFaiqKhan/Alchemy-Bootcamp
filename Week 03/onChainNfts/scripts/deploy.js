const main = async () => {
    try {
      const nftContractFactory = await hre.ethers.getContractFactory(
        "OnChainNfts"
      );
      const nftContract = await nftContractFactory.deploy();
      await nftContract.deployed();
  
      console.log("Contract deployed to:", nftContract.address);
      process.exit(0);
    } catch (error) {
      console.log(error);
      process.exit(1);
    }
  };
    
  main();


  // contract deployed to 0x6d70F8249E5B7F37264053a0788f2CA3ADb47252