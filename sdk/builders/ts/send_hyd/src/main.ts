///###TS_STEP_1
// Import the necessary modules from our SDK
import { Crypto, Layer1, Network, NetworkConfig } from '@internet-of-people/sdk';
///###TS_STEP_1

///###TS_STEP_2
// Instantiate a vault object deployed for test purposes
const unlockPassword = 'correct horse battery staple';
const vault = Crypto.Vault.create(Crypto.Seed.demoPhrase(), '', unlockPassword);
///###TS_STEP_2

///###TS_STEP_3
// Initialize the Hydra plugin on the vault object
const parameters = new Crypto.HydraParameters(
    Crypto.Coin.Hydra.Testnet,
    0
);
Crypto.HydraPlugin.init(vault, unlockPassword, parameters);

// Get the private interface of the Hydra plugin
const hydra = Crypto.HydraPlugin.get(vault, parameters);
const hydraPrivate = hydra.priv(unlockPassword);
///###TS_STEP_3

///###TS_STEP_4
// The address from which funds are sent from
const sourceAddress = hydra.pub.key(0).address;

// The address to which the funds are sent to
const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J"; 
///###TS_STEP_4

(async () => {

///###TS_STEP_5
// Return an api that can interact with the hydra blockchain
const network = Network.Testnet;
const layer1Api = await Layer1.createApi(NetworkConfig.fromNetwork(network));

// Send a hydra transaction using the hydra private object.
const amount = 1e8 / 10; // 0.1 HYD
const txId = await layer1Api.sendTransferTx(
    sourceAddress,
    targetAddress,
    BigInt(amount),
    hydraPrivate
); 
///###TS_STEP_5
if(!txId) {
    throw new Error('TX could not be sent');
}
///###TS_STEP_6
// Prints the transaction ID
console.log('Transaction ID: ', txId);
///###TS_STEP_6

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});
