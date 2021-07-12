///###TS_STEP_1
// Import the necessary modules from our SDK
import { Crypto, Layer1, Network, NetworkConfig } from '@internet-of-people/sdk';
///###TS_STEP_1

///###TS_STEP_2
// Instantiate the demo vault that acts as a source of funds
const sourcePassword = 'correct horse battery staple';
const sourceVault = Crypto.Vault.create(Crypto.Seed.demoPhrase(), '', sourcePassword);
///###TS_STEP_2

///###TS_STEP_3
// Initialize the Hydra plugin on the source vault.
const parameters = new Crypto.HydraParameters(
    Crypto.Coin.Hydra.Testnet,
    0
);
Crypto.HydraPlugin.init(sourceVault, sourcePassword, parameters);

// Get the private interface of the Hydra plugin
const sourcePlugin = Crypto.HydraPlugin.get(sourceVault, parameters);
const hydraPrivate = sourcePlugin.priv(sourcePassword);

// The address from which funds are sent from
const sourceAddress = sourcePlugin.pub.key(0).address;
///###TS_STEP_3

///###TS_STEP_4
// Initialize your personal vault that will act as the target
const mnemonic = new Crypto.Bip39('en').generate().phrase;
const targetPassword = 'horse battery staple correct'
const targetVault = Crypto.Vault.create(
  mnemonic,
  '',               // 25th word
  targetPassword,
);
Crypto.HydraPlugin.init(targetVault, targetPassword, parameters)

// The address to which the funds are sent to
const targetHydra = Crypto.HydraPlugin.get(targetVault, parameters);

// Initialize the second key on the private hydra interface
targetHydra.priv(targetPassword).key(1);
const targetAddress = targetHydra.pub.key(1).address;
///###TS_STEP_4

(async () => {

///###TS_STEP_5
// Return an api that can interact with the hydra blockchain
const networkConfig = NetworkConfig.fromNetwork(Network.Testnet);
const layer1Api = await Layer1.createApi(networkConfig);

// Send a hydra transaction using the hydra private object.
const amount = 1e8; // 1 HYD in flakes
const txId = await layer1Api.sendTransferTx(
  sourceAddress,
  targetAddress,
  BigInt(amount),
  hydraPrivate
); 

// Prints the transaction ID
console.log('Transaction ID: ', txId);
///###TS_STEP_5
if(!txId) {
    throw new Error('TX could not be sent');
}

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});
