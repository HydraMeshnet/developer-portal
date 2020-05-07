# DAC SDK Tutorial: Contract Signature Proof On-Chain

#### Step 1. Import our SDK.

First as always, we need to access the SDK in our sample code.

<!-- tabs:start -->

#### ** Javascript **

In Typescript we need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
import { Crypto, Layer1, Layer2, Network } from '@internet-of-people/sdk';
```

#### ** Java **

Soon

#### ** Dart **

Soon

<!-- tabs:end -->

#### Step 2. Define Constants

We need to define some constants here. The only interesting is the gas passphrase and public key. This credential will be the Hydra wallet that pays for the actual on-chain transactions with HYD.

<!-- tabs:start -->

#### ** Javascript **

```typescript
export const network = Network.Testnet;
export const vaultPath = "vault.test";
export const hydraGasPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";
export const hydraGasPublicKey = "03d4bda72219264ff106e21044b047b6c6b2c0dde8f49b42c848e086b97920adbf";
```

#### ** Java **

Soon

#### ** Dart **

Soon

<!-- tabs:end -->

#### Step 3. Create a Vault

In order to send DAC transactions, we need a vault that we can use for signing data. This vault is saved on the disk, hence we can load it any time.
If the vault is not yet created, we can just create a new one with a freshly generated seed phrase.

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

Soon

#### ** Dart **

Soon

<!-- tabs:end -->

#### Step 4. Create Your First DID

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Even though a Vault can create an infinite amount of DIDs, DAC operations usually only require specifying one. Hence, we have to either create one or use a previously created.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Tips &amp; Tricks</h5>
            <ul>
                <li>Creating a new DID saves it in the Vault's state and will be accessible as the active DID.</li>
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
Using DID: TODO
```

#### ** Java **

Soon

#### ** Dart **

Soon

<!-- tabs:end -->

#### Step 5. Sign the Contract

<div class="row no-gutters">
    <div class="col-6 pr-3">
        As we mentioned, our goal is to store a proof on-chain about the fact that we signed a contract. At this point we have everything to sign it. The end of this step, we have the data with our signature atteched to it.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Tips &amp; Tricks</h5>
            <ul>
                <li>In this step, we use the default key which all DIDs have by default, as until a DID's rights are not modified, it's a <a href="/glossary?id=implicit-throw-away-did-document">throw-away DID</a>.</li>
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
const signedContract = vault.signDidOperations(keyId, contractBytes);
console.log("Signed contract:", JSON.stringify({
    content: Buffer.from(signedContract.content).toString('utf8'),
    publicKey: signedContract.publicKey.toString(),
    signature: signedContract.signature.toString()
}, null, 2));

```

Outputs
```bash
Signed contract: {
    "content": TODO,
    "publicKey": TODO,
    "signature": TODO
}
```

#### ** Java **

Soon

#### ** Dart **

Soon

<!-- tabs:end -->

#### Step 6. Create a Proof by Collapsing Data

<div class="row no-gutters">
    <div class="col-6 pr-3">
        As our goal is not to share the contract itself just the fact, we have to do something with the result from the previous step. That data contains the original content and a proof that we've signed it. To be able to share it without revealing its content, we use our `Crypto` library to collapse its content into a single hash. We call it a JSON masking, read more about it <a href="/glossary?id=maskable-claim-properties">here</a>.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Tips &amp; Tricks</h5>
            <ul>
                <li>By using this module, you can also collapse just part of the data you have. See more examples on JSON masking <a href="https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#JSON-Masking">here</a>.</li>
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
Before proof: TODO
```

#### ** Java **

Soon

#### ** Dart **

Soon

<!-- tabs:end -->

#### Step 7. Creating DAC Transaction

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Arriving this step, we have a single hash (before proof) which is a cryptographic proof that a contract is signed by us. We can later can prove with our keys that a contract was signed by us and the time is proven by the blockchain itself.
        A single DAC transaction consists of one or multiple <a href="/dac?id=operations-and-signed-operations">DAC operations</a>. Registering a hash or as we call before proof is also a such operation. Read more about DAC operations <a href="/dac?id=operations-and-signed-operations">here</a>.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Tips &amp; Tricks</h5>
            <ul>
                <li>As you see in the example, we create operation attemps. We call those attempts, because the blockchain or as we call <a href="/dac?id=layer-1">layer-1</a> will accept it if the transaction itself is valid, but <a href="/dac?id=layer-2">layer-2</a> might still reject it.</li>
                <li>When we send in a transaction with a Hydra account, the transaction has to contain a nonce, which is increased by one after each and every transaction.</li>
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
Transaction ID: TODO
```

#### ** Java **

Soon

#### ** Dart **

Soon

<!-- tabs:end -->

#### Step 8. Query DAC Transaction from Blockchain

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Aaaand we did it. Our DAC transaction is accepted by a node! You should be as happy as this unicorn right here: 🦄
        <br>
        To ensure that not just the layer-1 accepted our DAC transaction, but the layer-2 as well, let's query it. But only after 12s!
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Tips &amp; Tricks</h5>
            <ul>
                <li>Don't forget, that the Hydra network's blocktime is 12s, so we have to wait at least that much. Currently the SDK's API does not support it, but until then, we wrote for you a function that helps you schedule this waiting in the code.</li>
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

await waitUntil12Sec(); // it'll be included in the SDK soon
let txStatus = await layer1.client.getTxnStatus(morpheusTxId); // no layer-1 transaction must be really confirmed
console.log("Tx status:", txStatus.get()); // TODO: can I use it in the client without including optional-ts?

// now we can query from the layer-2 API as well!
const layer2Api = await Layer2.createApi(network);
let dacTxStatus = await layer2Api.getTxnStatus(morpheusTxId);
console.log("DAC Tx status:", dacTxStatus.get()); // TODO: can I use it in the client without including optional-ts?

```

Outputs
```bash
Tx status: TODO
DAC Tx status: TODO
```

#### ** Java **

Soon

#### ** Dart **

Soon

<!-- tabs:end -->