import React, { useState } from 'react';
import Web3 from 'web3';

function App() {
  const [account, setAccount] = useState(null);

  async function connectWallet() {
    if (window.ethereum) {
      try {
        // Request access to the user's Web3 wallet
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        console.log('Web3 wallet connected!');
        // You can now interact with the Web3 provider
        const web3 = new Web3(window.ethereum);
        const accounts = await web3.eth.getAccounts();
        setAccount(accounts[0]);
      } catch (error) {
        console.error(error);
      }
    } else {
      alert('Please install a Web3 wallet like MetaMask to use this feature.');
    }
  }

  async function disconnectWallet() {
    if (window.ethereum) {
      try {
        // Disconnect the user's Web3 wallet
        await window.ethereum.request({ method: 'wallet_requestPermissions', params: [{ eth_accounts: {} }] });
        console.log('Web3 wallet disconnected!');
        // Clear the account state variable
        setAccount(null);
      } catch (error) {
        console.error(error);
      }
    } else {
      alert('Please install a Web3 wallet like MetaMask to use this feature.');
    }
  }

  return (
    <div>
      <h1>My App</h1>
      {account ? (
        <>
          <p>Connected to account: {account}</p>
          <button onClick={disconnectWallet}>Disconnect Wallet</button>
        </>
      ) : (
        <button onClick={connectWallet}>Connect Wallet</button>
      )}
    </div>
  );
}

export default App;
