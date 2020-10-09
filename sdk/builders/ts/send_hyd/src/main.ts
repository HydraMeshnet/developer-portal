///###TS_STEP_1
// Import the necessary modules from our SDK
import { Layer1, Network } from '@internet-of-people/sdk';
///###TS_STEP_1

///###TS_STEP_2
// Select the testnet
export const network = Network.Testnet;

// Gives access to a pre-generated wallet on the testnet
export const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";

// The address to which the funds are sent to
export const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J"; 
///###TS_STEP_2

(async () => {

///###TS_STEP_3
// Return an api that can interact with the hydra blockchain
const layer1Api = await Layer1.createApi(network);

// Sends a hydra transaction using a passphrase
const amount = 1e8 / 10; // 0.1 HYD
const txId = await layer1Api.sendTransferTxWithPassphrase(walletPassphrase, targetAddress, BigInt(amount)); 
///###TS_STEP_3
if(!txId) {
    throw new Error('TX could not be sent');
}
///###TS_STEP_3
// Prints the transaction ID
console.log('Transaction ID: ', txId);
///###TS_STEP_3

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});
