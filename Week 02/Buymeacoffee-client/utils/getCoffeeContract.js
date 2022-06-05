import { ethers } from "ethers";

import abi from "../utils/buyMeACoffee.json";

const contractAddress = "0x2C853C86E9482CB581e208aA48cBf271AD293a45";
const contractABI = abi.abi;

const BuyCoffee = (ethereum) => {
  if (ethereum) {
    const provider = new ethers.providers.Web3Provider(ethereum, "any");
    const signer = provider.getSigner();
    return new ethers.Contract(contractAddress, contractABI, signer);
  } else {
    return undefined; // if we don't have ethereum provider, we can't deploy the contract
  }
};

export default BuyCoffee;
