# SDK Tutorial: Sending HYD Programmatically

In this tutorial, you will implement a Hydra transaction with the SDK.
A pre-generated vault filled with test HYD's can be accessed through a passphrase: 
you will send HYD's using code from this wallet to your own personal vault.

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
import { Crypto, Layer1, Network, NetworkConfig } from '@internet-of-people/sdk';
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
import 'package:iop_sdk/crypto.dart';
import 'package:iop_sdk/layer1.dart';
import 'package:iop_sdk/network.dart';
```

<!-- tabs:end -->

#### Step 2. Create a Vault

<div class="row no-gutters">
    <div class="col-6 pr-3">
        In a previous tutorial, you saw how a cryptographic keyvault can be created. 
        Now you are going to encounter similar code that enables you to instantiate a pre-generated vault with test HYD's.
        In a real-world application, you would access your wallet through your vault which is persisted and encrypted carefully.
        Once you have access to your keys, you can use similar code snippets to send tokens to any address.
    </div>
    <div class="col-6">
        <div class="alert alert-info">
            <h5><strong>Interested in learning about the vault?</strong></h5>
            Check out our Create a Secure Vault tutorial <a href="/sdk/tutorial_create_vault">here</a>.
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// Instantiate the demo vault that will act as a source of funds
const sourcePassword = 'correct horse battery staple';
const sourceVault = Crypto.Vault.create(Crypto.Seed.demoPhrase(), '', sourcePassword);
```

#### ** Flutter (Android) **

```dart
// Instantiate a vault object deployed for test purposes
final sourcePassword = 'correct horse battery staple';
final sourceVault = Vault.create(Bip39.DEMO_PHRASE, '', sourcePassword);
```

<!-- tabs:end -->

#### Step 3. Initialize the Hydra Plugin on the Source Vault

<div class="row no-gutters">
    <div class="col-6 pr-3">
        To interact with the Hydra blockchain, the keyvault needs to have a <code>hydra</code> plugin with the right parameters initialized so that it can generate
        the appropriate key pairs. The first parameter describes the network and the account number (0) of the account for which the plugin generates keys.
        The plugin consists of a public part that can be accessed without a password and a private part which requires the password explicitely.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>The vault resembles a hierarchical deterministic wallet with additional functionalities. Read more about it <a href="/glossary?id=vault">here</a></li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
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
```

#### ** Flutter (Android) **

```dart
// Initialize the Hydra plugin on the vault object
final accountNumber = 0;
final network = Network.TestNet;
HydraPlugin.init(sourceVault, sourcePassword, network, accountNumber);

// Get the private interface of the Hydra plugin
final hydra = HydraPlugin.get(sourceVault, network, accountNumber);
final hydraPrivate = hydra.private(sourcePassword);

// The address from which funds are sent from
final sourceAddress = hydra.public.key(0).address;
```

<!-- tabs:end -->

#### Step 4. Create your Personal Vault for Receiving HYD's

<div class="row no-gutters">
    <div class="col-6 pr-3">
        The following code creates a brand new vault. To get the target address for receiving funds,you need to initialize the hydra plugin similar as in the previous step.    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
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
const targetAddress = targetHydra.pub.key(0).address;
```

#### ** Flutter (Android) **

```dart
// Initialize your personal vault that will act as the target
final mnemonic = Bip39('en').generatePhrase();
final targetPassword = 'horse battery staple correct';
final targetVault = Vault.create(mnemonic, '', targetPassword);
HydraPlugin.init(targetVault, targetPassword, network, accountNumber);

// The address to which the funds are sent to
final targetHydra = HydraPlugin.get(targetVault, network, accountNumber);
final targetAddress = targetHydra.public.key(0).address;
```

<!-- tabs:end -->

#### Final Step: Send HYD

<div class="row no-gutters">
    <div class="col-6 pr-3">
        You can send a transaction by creating a client instance and calling the send operation. This is done inside an asynchronous function. The first async call enables you to access the API used to communicate with the layer-1 blockchain. This is necessary to send transactions to the nodes (using the second async call). If the transaction is accepted the promise will resolve to a transaction ID, which you can use to query your transaction on the blockchain.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>Hydra uses 8 decimals, hence you use <code>1e8</code> notation, which means 100000000 flakes which is 1 HYD.</li>
                <li>Test HYD's do not have an economic value>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
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
```

Outputs:

```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

#### ** Flutter (Android) **

```dart
// Initialize the Hydra plugin on the vault object
final networkConfig = NetworkConfig.fromNetwork(network);
final layer1Api = Layer1Api.createApi(networkConfig);

// Send a hydra transaction using the hydra private object.
final amount = 1e8; // 1 HYD in flakes
final txId = await layer1Api.sendTransferTx(
  sourceAddress,
  targetAddress,
  amount.toInt(),
  hydraPrivate
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