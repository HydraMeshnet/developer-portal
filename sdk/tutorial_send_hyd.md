# SDK Tutorial: Sending HYD Programatically

In this tutorial you will implement the simplest possible thing with the SDK: you'll send HYDs with code from one wallet to a another one.

#### Prerequisites

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

- [NodeJS 12](https://nodejs.org/en/)
- Selecting a Hydra network. We recommend using our `testnet` or `devnet`. In this tutorial, you're going to use `testnet`.
- Depending on your choice you will need some HYDs to cover transaction fees.

#### ** Flutter (Android) **

- Selecting a Hydra network. We recommend using our `testnet` or `devnet`. In this tutorial, you're going to use `testnet`.
- Depending on your choice you will need some HYDs to cover transaction fees.
- [Flutter](https://flutter.dev/docs/get-started/install) installed.
- A sample Flutter project. Please follow their [Test Drive](https://flutter.dev/docs/get-started/test-drive) page to create it. In the end, you'll have a simple counter application.

This sample project will have a `lib/main.dart`.
That will be the file where we will work. Except the imports we will write our code into the `_incrementcounter` method, but we have to change it to async, like this:

```dart
Future<void> _incrementCounter() async {
   // our code will be here...
};
```

<!-- tabs:end -->

#### Step 1. Import SDK

First you need to access the SDK in the code.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

The Typescript package is available on [npmjs.com](https://www.npmjs.com/package/@internet-of-people/sdk). After putting it into your package.json, you can start using it.

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
import { Layer1, Network } from '@internet-of-people/sdk';
```

#### ** Flutter (Android) **

To be able to use our SDK in your Flutter Android application, you need to run our installer script first, that does the followings:

- It'll download the dynamic libraries you need and puts those files to the right place. Those files are required because the SDK's crypto codebase is implemented in Rust and uses Dart FFI.
- It'll add our Dart SDK into your `pubspec.yaml` file.

You just have to run this under your project's root on your Linux or MacOS (Windows is not yet supported):
```bash
curl https://raw.githubusercontent.com/Internet-of-People/morpheus-dart/master/tool/init-flutter-android.sh | sh
```

When the script finished, the only remaining task you have to do, is to import the SDK in the `lib/main.dart`, where we do our work.

```dart
import 'package:iop_sdk/layer1.dart';
import 'package:iop_sdk/network.dart';
```

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

#### ** NodeJS (Typescript) **

```typescript
export const network = Network.Testnet;
export const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";
export const targetAddress = "tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J"; // genesis
```

#### ** Flutter (Android) **

```dart
final network = Network.TestNet;
final targetAddress = 'tjseecxRmob5qBS2T3qc8frXDKz3YUGB8J'; // genesis
final walletPassphrase = 'scout try doll stuff cake welcome random taste load town clerk ostrich';
```

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

#### ** NodeJS (Typescript) **

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

#### ** Flutter (Android) **

```dart
final layer1Api = Layer1Api(network);
final amount = 1e8 ~/ 10;
final txId = await layer1Api.sendTransferTxWithPassphrase(
  walletPassphrase,
  targetAddress,
  amount,
);
print('Transaction ID: $txId');
```

Outputs:
```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

<!-- tabs:end -->

<a href="/#/sdk/dac?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>