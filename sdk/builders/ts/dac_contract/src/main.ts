///###TS_STEP_1
import { Crypto, Layer1, Layer2, Network } from '@internet-of-people/sdk';
///###TS_STEP_1

///###TS_STEP_2
export const network = Network.Testnet;
export const hydraGasPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";
export const hydraGasPublicKey = "03d4bda72219264ff106e21044b047b6c6b2c0dde8f49b42c848e086b97920adbf";
export const unlockPassword = '+*7=_X8<3yH:v2@s';
///###TS_STEP_2

///###TS_STEP_3
// YOU HAVE TO SAVE IT TO A SAFE PLACE!
const phrase = new Crypto.Bip39('en').generate().phrase;

const vault = Crypto.Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#', // this is for plausible deniability
  unlockPassword,
);
///###TS_STEP_3

///###TS_STEP_4
Crypto.MorpheusPlugin.rewind(vault, unlockPassword);
const morpheus = Crypto.MorpheusPlugin.get(vault);

const did = morpheus.pub.personas.did(0); // you are going to use the first DID
console.log("Using DID: ", did.toString());
///###TS_STEP_4

if(!did) {
    throw new Error('DID is null');
}

///###TS_STEP_5
const keyId = did.defaultKeyId(); // acquire the default key
const contractStr = "A long legal document, e.g. a contract with all details";
const contractBytes = new Uint8Array(Buffer.from(contractStr));
const morpheusPrivate = morpheus.priv(unlockPassword); // acquire the plugin's private interface that's provides you the sign interface
const signedContract = morpheusPrivate.signDidOperations(keyId, contractBytes); // YOU NEED TO SAVE IT TO A SAFE PLACE!

console.log("Signed contract:", JSON.stringify({
    content: Buffer.from(signedContract.content).toString('utf8'), // you must use this Buffer wrapper at the moment, we will improve in later releases
    publicKey: signedContract.publicKey.toString(),
    signature: signedContract.signature.toString(),
}, null, 2));
///###TS_STEP_5

///###TS_STEP_6
const beforeProof = Crypto.digest(signedContract);
console.log("Before proof:", beforeProof);
///###TS_STEP_6

if(!beforeProof) {
    throw new Error('beforeProof is null');
}

(async () => {
///###TS_STEP_7
const opAttempts = new Layer1.OperationAttemptsBuilder() // let's create our operation attempts data structure
    .registerBeforeProof(beforeProof)
    .getAttempts();

// let's initialize our layer-1 API
const layer1Api = await Layer1.createApi(network);

// let's query and then increment the current nonce of the owner of the tx fee
let nonce = await layer1Api.getWalletNonce(hydraGasPublicKey);
nonce = BigInt(nonce) + BigInt(1);

// and now you are ready to send it
const txId = await layer1Api.sendMorpheusTxWithPassphrase(opAttempts, hydraGasPassphrase, nonce);
console.log("Transaction ID: ", txId);
///###TS_STEP_7

///###TS_STEP_8
const waitUntil12Sec = (): Promise<void> => {
    return new Promise((resolve) => {
        return setTimeout(resolve, 12*1000);
    });
};

await waitUntil12Sec(); // it'll be included in the SDK Soon in 2020
let txStatus = await layer1Api.getTxnStatus(txId); // no layer-1 transaction must be really confirmed
console.log("Tx status:", txStatus.get()); // the SDK uses optional-js's Optional result

// now you can query from the layer-2 API as well!
const layer2Api = await Layer2.createApi(network);
let dacTxStatus = await layer2Api.getTxnStatus(txId);
console.log("DAC Tx status:", dacTxStatus.get()); // the SDK uses optional-js's Optional result
///###TS_STEP_8

///###TS_STEP_9
// we assume here that signedContract is in scope and available
const expectedContentId = Crypto.digest(signedContract);
///###TS_STEP_9

///###TS_STEP_10
let history = await layer2Api.getBeforeProofHistory(expectedContentId);
console.log("Proof history:", history)
///###TS_STEP_10

if(history.contentId !== expectedContentId) {
    throw new Error('Content Id does not match');
}

})().catch((e)=>{
    process.stderr.write(e.message);
    process.exit(1);
});
