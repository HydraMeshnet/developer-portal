# SDK Tutorial: Sending HYD Programatically

In this tutorial you will implement the simplest possible thing with the SDK: you'll send HYDs with code from one wallet to a another one.

#### Prerequisites

- [NodeJS 12](https://nodejs.org/en/)
- Selecting a Hydra network. We recommend using our `testnet` or `devnet`. In this tutorial, you're going to use `testnet`.
- Depending on your choice you will need a wallet that has at least 0.3 HYD.

#### Step 1. Import SDK

First you need to access the SDK in the code.

<!-- tabs:start -->

#### ** Typescript **

The Typescript package is available on [npmjs.com](https://www.npmjs.com/package/@internet-of-people/sdk). After putting it into your package.json, you can start using it.

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
import { Layer1, Network } from '@internet-of-people/sdk';
```

#### ** Dart **

The Dart package is available through [pub.dev](https://pub.dev/packages/iop-sdk). After putting it into your pubspec.yaml, you can start using it.

Soon in 2020

#### ** Java **

Soon in 2020

<!-- tabs:end -->

#### Step 2. Create Settings

<div class="row no-gutters">
    <div class="col-6 pr-3">
        For simplicity you're going to use some constants here. In a real world application you'll use a vault which is persisted and encrypted carefully.
    </div>
    <div class="col-6">
        <div class="alert alert-info">
            <h5><strong>Interested how to create such a vault?</strong></h5>
            Check out our Create a Secure Vault tutorial <a href="/#/sdk/tutorial_create_vault">here</a>.
        </div>
    </div>
</div>

 <!-- tabs:start -->

#### ** Typescript **

```typescript
export const network = Network.Testnet;
export const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";
export const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J"; // genesis
```

#### ** Dart **

Soon in 2020

#### ** Java **

Soon in 2020

<!-- tabs:end -->

#### Final Step: Send HYD

<div class="row no-gutters">
    <div class="col-6 pr-3">
        You can send a transaction with minimal effort: just create a client instance and call the send operation.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>Hydra uses 8 decimals, hence you use <code>1e8</code> notation, which means 100000000 flakes which is 1 HYD.</li>
                <li>Here you use passphrase to send the transaction, but you can also send transactions using a <a href="https://en.bitcoin.it/wiki/Wallet_import_format#:~:text=Wallet%20Import%20Format%20(WIF%2C%20also,gobittest.appspot.com%2FPrivateKey" target="_blank">WIF</a> via <code>sendTransferTxWithWIF</code><br>Later, we will provide an another way, where you'll be able to send transactions using your own vault.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Typescript **

```typescript
const layer1Api = await Layer1.createApi(network);
const amount = 1e8 / 10; // 0.1 HYD
const txId = await layer1Api.sendTransferTxWithPassphrase(walletPassphrase, targetAddress, BigInt(amount)); 
console.log('Transaction ID: ', txId);
```

Outputs:
```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

#### ** Dart **

Soon in 2020

Outputs:
```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

#### ** Java **

Soon in 2020

<!-- tabs:end -->

<a href="/#/sdk/dac?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>