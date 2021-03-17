# SDK Tutorial: Sending HYD Programmatically

In this tutorial, you will implement a Hydra transaction with the SDK. A pre-generated wallet can be accessed through a passphrase: you'll send HYDs with code from this wallet to another one.

#### Prerequisites

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

- [NodeJS 12](https://nodejs.org/en/)
- `make` and either `python` or `python3`
- Download [the project template](https://github.com/Internet-of-People/ts-template/archive/master.zip) and setup the environment as described in the readme.

#### ** Flutter (Android) **

- [Flutter](https://flutter.dev/docs/get-started/install)
- A sample Flutter project. Please follow their [Test Drive](https://flutter.dev/docs/get-started/test-drive) page to create it. In the end, you'll have a simple counter application.

This sample project has a `lib/main.dart` file.
This is the file where you will work. Except for the imports, we will write our code into the `_incrementcounter` method, which is changed to async, as follows:

```dart
Future<void> _incrementCounter() async {
   // our code comes here...
};
```

<!-- tabs:end -->

#### Step 1. Import SDK

First, you need to access the SDK in the code.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

The Typescript package is available on [npmjs.com](https://www.npmjs.com/package/@internet-of-people/sdk). After putting it into your package.json, you can start using it.

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
// Import the necessary modules from our SDK
import { Layer1, Network, NetworkConfig } from '@internet-of-people/sdk';
```

#### ** Flutter (Android) **

To be able to use our SDK in your Flutter Android application, you need to run our installer script first, that does the followings:

- It downloads the dynamic libraries you need and puts those files in the right place. Those files are required because the SDK's crypto codebase is implemented in Rust and uses Dart FFI.
- It adds our Dart SDK into your `pubspec.yaml` file.

You just have to run this under your project's root on your Linux or macOS (Windows is not yet supported):

```bash
curl https://raw.githubusercontent.com/Internet-of-People/morpheus-dart/master/tool/init-flutter-android.sh | sh
```

When the script is finished, the only remaining task is to import the SDK in the `lib/main.dart`.

```dart
// Import the necessary modules from our SDK
import 'package:iop_sdk/layer1.dart';
import 'package:iop_sdk/network.dart';
```

<!-- tabs:end -->

#### Step 2. Create Settings

<div class="row no-gutters">
    <div class="col-6 pr-3">
        For simplicity you're going to use a pre-generated wallet and target address. In a real world application you would access your wallet through a vault which is persisted and encrypted carefully. Once you have access to your keys, you can use similar code snippets to send tokens to any address.
    </div>
    <div class="col-6">
        <div class="alert alert-info">
            <h5><strong>Interested how to create such a vault?</strong></h5>
            Check out our Create a Secure Vault tutorial <a href="/sdk/tutorial_create_vault">here</a>.
        </div>
    </div>
</div>

 <!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// Select the testnet
export const network = Network.Testnet;

// Gives access to a pre-generated wallet on the testnet
export const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";

// The address to which the funds are sent to
export const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J"; 
```

#### ** Flutter (Android) **

```dart
// Select the testnet
final network = Network.TestNet;

// Gives access to a pre-generated wallet on the testnet
final walletPassphrase = 'scout try doll stuff cake welcome random taste load town clerk ostrich';

// The genesis address
final targetAddress = 'tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J'; // genesis
```

<!-- tabs:end -->

#### Final Step: Send HYD

<div class="row no-gutters">
    <div class="col-6 pr-3">
        You can send a transaction by creating a client instance and call the send operation. This is done inside an asynchronous function. The first async call enables you to access the API used to communicate with the layer-1 blockchain. This is necessary to send transactions to the nodes (using the second async call). If the transaction is accepted the promise will resolve to a transaction ID, which you can use to query your transaction on the blockchain.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>Hydra uses 8 decimals, hence you use <code>1e8</code> notation, which means 100000000 flakes which is 1 HYD.</li>
                <li>Here you use a passphrase to send the transaction, but you can also send transactions using a <a href="https://en.bitcoin.it/wiki/Wallet_import_format#:~:text=Wallet%20Import%20Format%20(WIF%2C%20also,gobittest.appspot.com%2FPrivateKey" target="_blank">WIF</a> via <code>sendTransferTxWithWIF</code><br>Later, we will provide an another way, where you'll be able to send transactions using your own vault.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// Return an api that can interact with the hydra blockchain
const layer1Api = await Layer1.createApi(NetworkConfig.fromNetwork(network));

// Sends a hydra transaction using a passphrase
const amount = 1e8 / 10; // 0.1 HYD
const txId = await layer1Api.sendTransferTxWithPassphrase(walletPassphrase, targetAddress, BigInt(amount)); 
// Prints the transaction ID
console.log('Transaction ID: ', txId);
```

Outputs:

```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

#### ** Flutter (Android) **

```dart
final layer1Api = Layer1Api(network);

// Sends a hydra transaction using a passphrase
final amount = 1e8 ~/ 10;
final txId = await layer1Api.sendTransferTxWithPassphrase(
  walletPassphrase,
  targetAddress,
  amount,
);

// Prints the transaction ID
print('Transaction ID: $txId');
```

Outputs:

```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

<!-- tabs:end -->
Congratulations, you sent your first hydra transactions using our SDK! Don't forget, that if you need more detailed or technical information, visit the SDK's source code on GitHub ([Typescript](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk)/[Flutter](https://github.com/Internet-of-People/morpheus-dart)) or contact us <a href="mailto:dev@iop-ventures.com">here</a>.

<a href="/sdk?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>