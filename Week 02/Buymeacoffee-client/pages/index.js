import Head from "next/head";
import styles from "../styles/Home.module.css";
import abi from "../utils/buyMeACoffee.json";
import getBuyCoffeeContract from "../utils/getCoffeeContract.js";
import { ethers } from "ethers";
import { useState, useEffect } from "react";

const Home = () => {
  const contractAddress = "0x2C853C86E9482CB581e208aA48cBf271AD293a45";
  const contractABI = abi.abi;

  const [currentAccount, setCurrentAccount] = useState("");
  const [name, setName] = useState("");
  const [message, setMessage] = useState("");
  const [memos, setMemos] = useState([]);

  const onNameChange = (event) => {
    setName(event.target.value);
  }

  const onMessageChange = (event) => {
    setMessage(event.target.value);
  }

  const { ethereum } = window;

  const setEthereumFromWindow = async () => {
    if (window.ethereum) {
      // If the chain changes then reload the page, https://docs.metamask.io/guide/ethereum-provider.html#events
      window.ethereum.on("chainChanged", async (_chainId) =>  // The MetaMask provider emits this event when the currently connected chain changes.
        window.location.reload() // reload the page
      );
      const chainId = await window.ethereum.request({ method: "eth_chainId" }); //makin a new call to eth_chainId. which gets the current chain id, returns the connected chain ID 
      const goerliId = "0x5"; // goerli chain id is 5, hexadecimal is 0x5, // See <https://docs.metamask.io/guide/ethereum-provider.html#chain-ids>
      if (chainId === goerliId) { // if the chain id is goerli id then :
        // if the chainId is goerli id then we are on goerli network
        setEthereum(window.ethereum); // set ethereum to window.ethereum , that enables emetaMask to be used in the app
      } else {
        alert("Please use Goerli network"); // else alert the user to use Goerli network
      }
    }
  };
  useEffect(() => setEthereumFromWindow(), []); // runs once after every initial rendering, it will set the ethereum variable

  const buyCoffeeContract = getBuyCoffeeContract(ethereum);

// Wallet connection logic
const isWalletConnected = async () => {
  try {
    const { ethereum } = window;

    const accounts = await ethereum.request({method: 'eth_accounts'})
    console.log("accounts: ", accounts);

    if (accounts.length > 0) {
      const account = accounts[0];
      console.log("wallet is connected! " + account);
    } else {
      console.log("make sure MetaMask is connected");
    }
  } catch (error) {
    console.log("error: ", error);
  }
}

const connectWallet = async () => {
  try {
    const {ethereum} = window;

    if (!ethereum) {
      console.log("please install MetaMask");
    }

    const accounts = await ethereum.request({
      method: 'eth_requestAccounts'
    });

    setCurrentAccount(accounts[0]);
  } catch (error) {
    console.log(error);
  }
}


  const buyCoffee = async () => {
    try {
      console.log("----Buying Coffee----Please Wait....");
      const coffeeTxn = await buyCoffeeContract.buyCoffee(
        name ? name : "Anonymous",
        message ? message : "No Message",
        { value: ethers.utils.parseEther("0.01") }
      );
      console.log("----Transaction Started----Please Wait....");
      await coffeeTxn.wait();
      console.log("----Transaction Completed----, Mined", coffeeTxn.hash);
      console.log("----Coffee Bought!!----");

      // clear the form
      setName("");
      setMessage("");
    } catch (error) {
      console.log(error);
    }
  };

  const getMemos = async () => {
    try {
      console.log("fetching memos from the blockchain..");
      const memos = await buyCoffeeContract.getMemos();
      setMemos(memos);
    } catch (error) {
      console.log(error);
    }
  }

  useEffect(() => {
    isWalletConnected();
    getMemos();

    // Create an event handler function for when someone sends
    // us a new memo.
    const onNewMemo = (from, timestamp, name, message) => {
      console.log("Memo received: ", from, timestamp, name, message);
      setMemos((prevState) => [
        ...prevState,
        {
          address: from,
          timestamp: new Date(timestamp * 1000),
          message,
          name
        }
      ]);
    };

    buyCoffeeContract.on("NewMemo", onNewMemo); // onNewMemo is the event handler function, it will be called when someone sends us a new memo

    return () => {
      buyCoffeeContract.off("NewMemo", onNewMemo);
    }
  }, []);

  return (
   
    <div className={styles.container}>
    <Head>
      <title>Buy Faiq a Coffee!</title>
      <meta name="description" content="Tipping site" />
      <link rel="icon" href="/favicon.ico" />
    </Head>

    <main className={styles.main}>
      <h1 className={styles.title}>
        Buy Faiq a Coffee!
      </h1>
      
      {currentAccount ? (
        <div>
          <form>
            <div class="formgroup">
              <label>
                Name
              </label>
              <br/>
              
              <input
                id="name"
                type="text"
                placeholder="anon"
                onChange={onNameChange}
                />
            </div>
            <br/>
            <div class="formgroup">
              <label>
                Send Faiq a message
              </label>
              <br/>

              <textarea
                rows={3}
                placeholder="Enjoy your coffee!"
                id="message"
                onChange={onMessageChange}
                required
              >
              </textarea>
            </div>
            <div>
              <button
                type="button"
                onClick={buyCoffee}
              >
                Send 1 Coffee for 0.01ETH
              </button>
            </div>
          </form>
        </div>
      ) : (
        <button onClick={connectWallet}> Connect your wallet </button>
      )}
    </main>

    {currentAccount && (<h1>Memos received</h1>)}

    {currentAccount && (memos.map((memo, idx) => {
      return (
        <div key={idx} style={{border:"2px solid", "border-radius":"5px", padding: "5px", margin: "5px"}}>
          <p style={{"font-weight":"bold"}}>"{memo.message}"</p>
          <p>From: {memo.name} at {memo.timestamp.toString()}</p>
        </div>
      )
    }))}

    <footer className={styles.footer}>
      <a
        href="https://alchemy.com/?a=roadtoweb3weektwo"
        target="_blank"
        rel="noopener noreferrer"
      >
        Created by @MFaiqKhan3 for Alchemy's Road to Web3 lesson two!
      </a>
    </footer>
  </div>
)

};

export default Home;
