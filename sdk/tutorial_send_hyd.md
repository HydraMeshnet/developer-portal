# SDK Tutorial: Sending HYD Programatically

In this tutorial you will implement the simplest possible thing with the SDK: you'll send HYDs with code from one wallet to a another one.

#### Prerequisites

- [NodeJS 12](https://nodejs.org/en/)
- Selecting a Hydra network. We recommend using our `testnet` or `devnet`. In this tutorial, you're going to use `testnet`.
- Depending on your choice you will need a wallet that has at least 1.2 HYD.

#### Step 1. Import SDK

First you need to access the SDK in the code.

<!-- tabs:start -->

#### ** Javascript **

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
import { Ark, Crypto, Layer1, Network } from '@internet-of-people/sdk';
```

#### ** Dart **

Soon in 2020

#### ** Java **

Soon in 2020

<!-- tabs:end -->

#### Step 2. Create Settings

For simplicity we're going to use some constants here. In a real world application you'll need secure config management of course.

<!-- tabs:start -->

#### ** Javascript **

```typescript
export const network = Network.Testnet;
export const vaultPath = "vault.test";
export const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";
export const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J"; // genesis
```

#### ** Dart **

Soon in 2020

#### ** Java **

Soon in 2020

<!-- tabs:end -->

#### Step 3. Create a Vault

Cryptographic keys are managed by the Vault component. It is persistent and its current implementation simply stores contents in a file. 
<br>
The Vault is a hierarchical deterministic key generator, a general purpose version of a <a href="https://en.bitcoin.it/wiki/Deterministic_wallet" target="_blank">Bitcoin HD wallet</a>. You'll generate a human-readable seed phrase (a.k.a mnemonic word list, cold wallet) for recovery.

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

#### ** Dart **

Soon in 2020

#### ** Java **

Soon in 2020

<!-- tabs:end -->

#### Final Step: Send HYD

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Now you have everything to send a transaction which is also as easy as you can imagine. You create an API and you're good to go!
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>Hydra uses 8 decimals, hence we use <code>1e8</code> notation, which means 100000000 flakes which is 1 HYD.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
const layer1Api = await Layer1.createApi(network);
const txId = await layer1Api.sendTransferTx(walletPassphrase, targetAddress, Ark.Utils.BigNumber.make(1e8));
console.log('Transaction ID: ', txId);
```

Outputs:
```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

#### ** Dart **

Soon in 2020

#### ** Java **

Soon in 2020

<!-- tabs:end -->

<a href="/#/sdk/dac?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>