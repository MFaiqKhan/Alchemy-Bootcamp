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


  // contract deployed to 0x855ABD58339f595FBBB3490f59a8E03d8f1D5Ba7