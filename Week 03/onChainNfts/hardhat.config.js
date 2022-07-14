require("dotenv").config();
require("@nomiclabs/hardhat-waffle"); 
require("@nomiclabs/hardhat-etherscan"); // Use the Etherscan plugin to verify the smart contract code on polygonscan

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.12",
  networks: {
    mumbai: {
      url: process.env.TESTNET_URL,
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: { // etherscan is also compatible with the polygonscan 
    apiKey: process.env.POLYGONSCAN_API_KEY, // Your Etherscan API key, When we'll deploy our smart contract, we'll also want to verify it using mumbai.polygonscan
  }
};
