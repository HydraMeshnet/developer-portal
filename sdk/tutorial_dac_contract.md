# DAC SDK Tutorial: Contract Signature Proof On-Chain

In this tutorial you will create a DID, then you will sign a contract with it. After the contract is signed, you will store a proof about it on-chain.

#### Prerequisites

- [NodeJS 12](https://nodejs.org/en/)
- Selecting a Hydra network. We recommend using our `testnet` or `devnet`. In this tutorial, you're going to use `testnet`.
- Depending on your choice you will need some HYDs to cover transaction fees.

#### Step 1. Import SDK

First as always, you need to access the SDK.

<!-- tabs:start -->

#### ** Javascript **

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
import { Crypto, Layer1, Layer2, Network } from '@internet-of-people/sdk';
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 2. Create Settings

<div class="row no-gutters">
    <div class="col-6 pr-3">
        For simplicity we're going to use some constants here. In a real world application you'll need secure config management of course. 
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>The gas passphrase and public key is the Hydra wallet's credential that pays for the actual on-chain transactions with HYD.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
export const network = Network.Testnet;
export const vaultPath = "vault.test";
export const hydraGasPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";
export const hydraGasPublicKey = "03d4bda72219264ff106e21044b047b6c6b2c0dde8f49b42c848e086b97920adbf";
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 3. Create a Vault

<div class="row no-gutters">
    <div class="col-6 pr-3">
        In order to send DAC transactions usually you need a DID. To have a DID you need a vault that stores your keys and is also used for signing data. This vault is saved on the disk, hence you can load it any time.
        If the vault is not yet created, you can just create a new one with a freshly generated seed phrase.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>The Vault is a hierarchical deterministic key generator, a general purpose version of a <a href="https://en.bitcoin.it/wiki/Deterministic_wallet" target="_blank">Bitcoin HD wallet</a>.</li>
                <li>You'll generate a human-readable seed phrase (a.k.a mnemonic word list, cold wallet) for recovery.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
let vault;
try {
    vault = Crypto.PersistentVault.loadFile(vaultPath);
}
catch (e) {
    const phrase = new Crypto.Bip39('en').generatePhrase(); // YOU HAVE TO SAVE IT TO A SAFE PLACE!
    vault = Crypto.PersistentVault.fromSeedPhrase(phrase, vaultPath);
}

console.log("Loaded vault from ", vaultPath);
```

Outputs:
```bash
Loaded vault from vault.test
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 4. Create Your First DID

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Even though a Vault can create an infinite amount of DIDs, DAC operations usually only require specifying one. Hence, you have to either create one or use a previously created.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>Most operations of our Decentralized Access Control (DAC) system are related to a user and in decentralized systems users are identified by decentralized IDs (DID).</li>
                <li>New DIDs are saved in the Vault's state as the new active DID.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
let did = vault.activeDid();
if (did === undefined) {
    did = vault.createDid();
}
console.log("Using DID: ", did.toString());
```

Outputs
```bash
Using DID: did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 5. Sign the Contract

<div class="row no-gutters">
    <div class="col-6 pr-3">
        As we mentioned, your goal is to store a proof on-chain about the fact that you signed a contract. At this point you have everything to sign it. The end of this step, you have the data with our signature atteched to it.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Tips &amp; Tricks</h5>
            <ul>
                <li>When a DID is created it has a public key by default attached which can act on behalf of the DID by signing related operations. Such an unmodified (keys untouched) DID is called a <a href="/#/glossary?id=implicit-throw-away-did-document">throw-away DID</a>.</li>
                <li>Signed data is similar to warranty tickets in a sense that it's not mandatory to keep it safe, until you have to prove that you have signed the contract.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
const keyId = did.defaultKeyId(); // acquire the default key
const contractStr = "A long legal document, e.g. a contract with all details";
const contractBytes = new Uint8Array(Buffer.from(contractStr));
const signedContract = vault.signDidOperations(keyId, contractBytes); // YOU NEED TO SAVE IT TO A SAFE PLACE!
console.log("Signed contract:", JSON.stringify({
    content: Buffer.from(signedContract.content).toString('utf8'), // you must use this Buffer wrapper at the moment, we will improve in later releases
    publicKey: signedContract.publicKey.toString(),
    signature: signedContract.signature.toString()
}, null, 2));
```

Outputs
```bash
Signed contract: {
    "content": "A long legal document, e.g. a contract with all details",
    "publicKey": "pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6",
    "signature": "sez6sgyb4hPbD3UmSsp3MwAv6rAF2UTYA8V6WNR8ncdUUmLV2rv6ewZQvNrNvthos1TW7aXDRvss2RDPt7Mtr82nDK6"
}
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 6. Create a Proof by Collapsing Data

<div class="row no-gutters">
    <div class="col-6 pr-3">
        As our goal is not to share the contract itself just the fact, you have to do something with the result from the previous step. That data contains the original content and a proof that you've signed it. To be able to share it without revealing its content use our Crypto library to collapse its content into a single hash. We call it a JSON masking, read more about it <a href="/#/glossary?id=json-masking">here</a>.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>The signed contract is hashed into a content ID that proves the content without exposing it.</li>
                <li>Hashing an object into a content ID is also usually mentioned as digesting.</li>
                <li>We also allow partial masking when only parts of the object are digested see more about it <a href="https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#JSON-Masking">here</a>.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
const beforeProof = Crypto.digest(signedContract);
console.log("Before proof:", beforeProof);
```

Outputs
```bash
Before proof: cjuMiVbDzAf5U1c0O32fxmB4h9mA-BuRWA-SVm1sdRCfEw
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 7. Creating DAC Transaction

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Arriving this step, you have a single hash (before proof) which is a cryptographic proof that a contract is signed by us. Later you can prove this fact with exposing the original content with your signature.
        <br>
        The operation will register this hash on the blockchain in a transaction, hence the timestamp of the containing block will provide a proof with a consensus that the content had to be created until this time.
        <br>
        A single DAC transaction consists of one or multiple <a href="/#/dac?id=operations-and-signed-operations">DAC operations</a>. Registering a hash - or as we call before proof - is also such an operation. Read more about DAC operations <a href="/#/dac?id=operations-and-signed-operations">here</a>.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>As you see in the example, you create operation attemps. We call those attempts, because the blockchain or as we call <a href="/#/dac?id=layer-1">layer-1</a> will accept it if the transaction itself is valid, but <a href="/#/dac?id=layer-2">layer-2</a> might still reject it.</li>
                <li>When you send in a transaction with a Hydra account, the transaction has to contain a nonce, which is increased by one after each and every transaction.</li>
                <li>If you provide the ID of an existing block into the signed contents then you can also prove that the content was created after the timestamp of that block.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
const opAttempts = new Layer1.OperationAttemptsBuilder() // let's create our operation attempts data structure
    .registerBeforeProof(beforeProof)
    .getAttempts();

const layer1Api = await Layer1.createApi(network); // let's initialize our layer-1 API
let nonce = await layer1Api.client.getWalletNonce(hydraGasPublicKey);
nonce = nonce.plus(1);
const txId = await layer1Api.sendMorpheusTx(opAttempts, hydraGasPassphrase, nonce);
console.log("Transaction ID: ", txId);
```

Outputs
```bash
Transaction ID: af868c9f4b4853e5055630178d07055cc49f2e5cd033687b2a91598a5d720e19
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 8. Query DAC Transaction from Blockchain

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Aaaand you did it. Your DAC transaction is accepted by a node! You should be as happy as this unicorn right here: 🦄
        <br>
        Though the transaction was successfully sent, it takes time until its included in a block and thus accepted by the blockchain consensus. After sent, you can fetch transaction status on both layer1 or layer2.
        <br>
        If a transaction was accepted on
        <ul>
            <li>layer-1 then it was just a valid Hydra token transaction without any DAC consensus e.g. its format is OK, fees are covered and is forged into a block</li>
            <li>layer-2 then it was also accepted as a valid DAC transaction</li>
        </ul>
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>Don't forget, that the Hydra network's blocktime is 12s. Currently the SDK's API does not help you to wait till the block is forged, but until then, we wrote a function for you that helps this waiting in the code.</li>
                <li>Sending in DAC transactions, always confirm its validity at layer2 consensus.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
const waitUntil12Sec = (): Promise<void> => {
    return new Promise((resolve) => {
        return setTimeout(resolve, 12*1000);
    });
};

await waitUntil12Sec(); // it'll be included in the SDK Soon in 2020
let txStatus = await layer1.client.getTxnStatus(morpheusTxId); // no layer-1 transaction must be really confirmed
console.log("Tx status:", txStatus.get()); // we use optional-js's Optional result

// now we can query from the layer-2 API as well!
const layer2Api = await Layer2.createApi(network);
let dacTxStatus = await layer2Api.getTxnStatus(morpheusTxId);
console.log("DAC Tx status:", dacTxStatus.get()); // we use optional-js's Optional result

```

Outputs
```bash
Tx status: {
    "id": "af868c9f4b4853e5055630178d07055cc49f2e5cd033687b2a91598a5d720e19",
    "blockId": "0adae3bd423939959aa800339555a6a2816f7ca1efef343bd1ab05fda185ae1c",
    "confirmations": 1,
    ...
}
DAC Tx status: true
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Final Step: Proving

Assume that you have to prove the fact of signing later. 

1. To do so, you have to load and present the contents of the `signedContract` from your safe storage.

2. Having the contents of the signed contract, anyone can calculate its content ID.

<!-- tabs:start -->

#### ** Javascript **

```typescript
// we assume here that signedContract is in scope and available
const contentID = Crypto.digest(signedContract);
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

3. History of the content ID can then be queried from layer-2 API.

<!-- tabs:start -->

#### ** Javascript **

```typescript
let history = await layer2Api.getBeforeProofHistory(contentID);
console.log("Proof history:", history)
```

Outputs:
```bash
Proof history: {
    "contentId": "cjuMiVbDzAf5U1c0O32fxmB4h9mA-BuRWA-SVm1sdRCfEw",
    "existsFromHeight": 507997,
    "queriedAtHeight": 508993
}
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

4. The history show the blockheight and thus the timestamp (eg.: you can check it on the explorer) of the content ID, so the signature must have been created earlier than included into a block.

<a href="/#/sdk/dac?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>