///###TS_STEP_1
// Import the necessary modules from our SDK
import { Crypto, Layer1, Network, NetworkConfig } from '@internet-of-people/sdk';
///###TS_STEP_1

(async () => {
///###TS_STEP_2
// Create a vault
const encryptionKey = 'unlockPassword';
const mnemonic = new Crypto.Bip39('en').generate().phrase;
const vault = Crypto.Vault.create(
    mnemonic,
    '',
    encryptionKey
)
///###TS_STEP_2

///###TS_STEP_3
// Initialize the Hydra plugin with the right parameters
const hydraParams = new Crypto.HydraParameters(
    Crypto.Coin.Hydra.Testnet,
    0
);
Crypto.HydraPlugin.init(vault, encryptionKey, hydraParams);

///###TS_STEP_3

///###TS_STEP_4
// Select the Hydra Account and different addresses
const hydraAccount = Crypto.HydraPlugin.get(vault, hydraParams);

const sourceAddress = hydraAccount.pub.key(0).address;
const targetAddress = hydraAccount.pub.key(1).address; 
///###TS_STEP_4

///###TS_STEP_5
// Initialize the Layer-1 API
const testnet = Network.Testnet;
const layer1Api = await Layer1.createApi(NetworkConfig.fromNetwork(testnet));

// Gain access to test HYD faucet
const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";

// The layer 1 API is used to send funds to the source address
const amount = 1e8 // 1 HYD in flakes
await layer1Api.sendTransferTxWithPassphrase(walletPassphrase, sourceAddress, BigInt(amount));
///###TS_STEP_5

///###TS_STEP_6
// The previous transaction has to be confirmed.
setTimeout(async() => {
    const txId = await layer1Api.sendTransferTx(
        sourceAddress,
        targetAddress,
        BigInt(amount/2),
        hydraAccount.priv(encryptionKey)
    )
    console.log(txId);
}, 15000); // The callback is executed after 15s to ensure that the transaction was confirmed
///###TS_STEP_6

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});

