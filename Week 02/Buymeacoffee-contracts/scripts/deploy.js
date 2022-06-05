
const main = async () => {
    const BuyMeACoffee = await hre.ethers.getContractFactory("buyMeACoffee"); // get the contract factory, a instance of the contract.
    const buyMeACoffee = await BuyMeACoffee.deploy(); // deploy the contract instance
    await buyMeACoffee.deployed(); // wait for the contract to be deployed.
    console.log("address of the contract:", buyMeACoffee.address); // print the address of the contract.
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    }
);

//npx hardhat run scripts/deploy.js --network goerli
