// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

// helper functions

// Returns the ether balance of a given address.
async function getBalance(address) {
  const balanceBigInt = await hre.ethers.provider.getBalance(address);
  return hre.ethers.utils.formatEther(balanceBigInt);
}

// prints the ether balances for the list of addresses
async function printBalances(addresses) {
  let idx = 0; // index of the address in the list
  for (const address of addresses) { // for each address in array.
    console.log(`Address ${idx} balance: ${await getBalance(address)} ETH`);
    idx++; // increment the index
  }
}

// prints the memos stored on-chain from coffee purchases.
async function printMemos(memos) {
  for (const memo of memos) { // for each memo.
    const timestamp = memo.timestamp;
    const tipper = memo.name;
    const tipperAddress = memo.from;
    const message = memo.message;
    console.log(`At ${timestamp}, ${tipper} (${tipperAddress}) said: "${message}"`);
  }
}


async function main() {
  const [owner, tipper, tipper2, tipper3] = await hre.ethers.getSigners(); // get accounts to sign transactions with.

  const BuyMeACoffee = await hre.ethers.getContractFactory("buyMeACoffee"); // get the contract factory, a instance of the contract.

  const buyMeACoffee = await BuyMeACoffee.deploy(); // deploy the contract instance
  await buyMeACoffee.deployed(); // wait for the contract to be deployed.
  console.log("address of the contract:", buyMeACoffee.address); // print the address of the contract.


  // print the balances of the owner and tipper accounts.
  const addresses = [owner.address, tipper.address, tipper2.address, tipper3.address, buyMeACoffee.address];
  console.log("----Before coffee bought balance----");
  await printBalances(addresses);

  const tip = {value: hre.ethers.utils.parseEther("1")}; // tip amount , which will be sent to the contract and use by a tipper.

  await buyMeACoffee.connect(tipper).buyCoffee("tipper1", "one", tip); // connect the tipper to the contract and call the BuyMeACoffee function from the contract on it, and wait for the transaction to be mined.
  await buyMeACoffee.connect(tipper2).buyCoffee("tipper2", "two", {value: 2}); // this 2 represents the tip amount value, in gwei not in ether
  await buyMeACoffee.connect(tipper3).buyCoffee("tipper3", "three", {value: hre.ethers.utils.parseEther("2")}); 

  console.log("----After Bought coffee balance----");
  await printBalances(addresses);


  // Withdraw funds to owner address
  await buyMeACoffee.connect(owner).withdrawTips();

  //Balance after Windraw funds
  console.log("----After Windraw funds balance----");
  await printBalances(addresses);

  // Get the list of memos from the contract
  const memos = await buyMeACoffee.getMemos();
  console.log("----Memos----");
  await printMemos(memos);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
