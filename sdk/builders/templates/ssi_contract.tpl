# SSI SDK Tutorial: Contract Signature Proof On-Chain

In this tutorial, you will create a Decentralized ID (DID), then you will sign a contract using the private key tied to it. After the contract is signed, you will store proof about this on-chain.

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

First, you need access to the SDK in the code. 

For this tutorial, you will use the Crypto, Layer-1, Layer-2, and Network modules from our stack.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

The Typescript package is available on [npmjs.com](https://www.npmjs.com/package/@internet-of-people/sdk). 

In Typescript you need to use multiple modules from the SDK (The Layer1 and Network modules are already included in the project template). Additional features can be accessed through other modules about which you can read [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
{{{TS_STEP_1}}}
```

#### ** Flutter (Android) **

To use our SDK in your Flutter Android application, you need to run our installer script first, that does the followings:

- It downloads the dynamic libraries you need and puts those files in the right place. Those files are required because the SDK's crypto codebase is implemented in Rust and uses Dart FFI.
- It adds our Dart SDK into your `pubspec.yaml` file.

You just have to run this under your project's root on your Linux or macOS (Windows is not yet supported):

```bash
curl https://raw.githubusercontent.com/Internet-of-People/morpheus-dart/master/tool/init-flutter-android.sh | sh
```

When the script is finished, the only remaining task is to import the SDK in the `lib/main.dart`.

```dart
{{{FLUTTER_STEP_1}}}
```

<!-- tabs:end -->

#### Step 2. Create Settings

<div class="row no-gutters">
    <div class="text-justify  col-6 pr-3">
        For simplicity, we will provide you with a testnet account that pays the gas for the transactions. In a real-world application, you need a secure configuration with mainnet HYD's.<br>
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>
                    Interested how to create such a secure, persistent vault?
                    Check out our Create a Secure Vault tutorial <a href="/sdk/tutorial_create_vault">here</a>.
                </li>
                <li>The gas passphrase and public key is the Hydra wallet's credential that pays for the actual on-chain transactions with testnet HYD.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_2}}}
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_2}}}
```

<!-- tabs:end -->

#### Step 3. Create a Personal Vault

<div class="row no-gutters">
    <div class="text-justify col-6 pr-3">
        To send Layer-2 (SSI) transactions, you need a personal DID with a key tied to it. 
        Your personal vault stores your DIDs and their keys. It can also be used for signing data. 
        The first step in this process is to generate a new vault for your private use.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>The Vault is a hierarchical deterministic key generator, a general purpose version of a <a href="https://en.bitcoin.it/wiki/Deterministic_wallet" target="_blank">Bitcoin HD wallet</a>.</li>
                <li>You'll generate a human-readable seed phrase (a.k.a mnemonic word list, cold wallet) for recovery.</li>
                <li>If you are eager to know what these passwords are for, please check out our Create a Secure Vault tutorial <a href="/sdk/tutorial_create_vault">here</a>.
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_3}}}
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_3}}}
```

<!-- tabs:end -->

#### Step 4. Create Your First DID

<div class="row no-gutters">
    <div class="text-justify  col-6 pr-3">
      Even though you can create an infinite amount of DIDs, SSI operations usually only require specifying one. Hence, you have to either create a DID or use one previously created.
      <p>
        To create a DID, you need to initialize the <code>Morpheus</code> plugin from the SDK.
        The plugin enables the previously created vault to handle your DIDs.
        The plugin consists of a public part accessible without a password.
        The private interface requires the unlock password explicitly.
      </p>
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>Most operations of our SSI system are related to a user, which is identified by DIDs.</li>
                <li>New DIDs are appended to the list of active DID in the vault's state.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_4}}}
```

Outputs:

```text
Using DID: did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr
```

> Note: to learn more about the Morpheus and other plugins, please visit our technical documentation in the [SDK's repository](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk).

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_4}}}
```

Outputs:

```text
Using DID: did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr
```

> Note: to learn more about the Morpheus plugin's public and private interfaces, please visit our technical documentation in the [SDK's repository](https://github.com/Internet-of-People/morpheus-dart).

<!-- tabs:end -->

#### Step 5. Sign the Contract

<div class="row no-gutters">
    <div class="text-justify col-6 pr-3">
      Your goal is to store proof on-chain about the fact that you signed a contract (Proof of Existence).
      You need a private key tied to your DID to sign the contract. The private interface of the vault gives access to this key.
      We provide you with a method that signs the message with your private key. After invoking this method,
      you have generated the data with your signature attached to it.    
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>When a DID is created, it has a default public key and DID document attached to it. These can act on behalf of the DID by signing related operations. This unmodified (keys untouched) DID Document is called an <a href="/glossary?id=implicit-did-document">implicit DID Document</a>.</li>
                <li>Signed data is similar to warranty tickets in a sense that it's not mandatory to keep it safe, until you have to prove that you have signed the contract.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_5}}}
```

Outputs:

```text
Signed contract: {
    "content": "A long legal document, e.g. a contract with all details",
    "publicKey": "pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6",
    "signature": "sez6sgyb4hPbD3UmSsp3MwAv6rAF2UTYA8V6WNR8ncdUUmLV2rv6ewZQvNrNvthos1TW7aXDRvss2RDPt7Mtr82nDK6"
}
```

> Note: to learn more about the Morpheus plugin's public and private interfaces, please visit our technical documentation in the [SDK's repository](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk).

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_5}}}
```

Outputs:

```text
Signed contract: {
    "content": "A long legal document, e.g. a contract with all details",
    "publicKey": "pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6",
    "signature": "sez6sgyb4hPbD3UmSsp3MwAv6rAF2UTYA8V6WNR8ncdUUmLV2rv6ewZQvNrNvthos1TW7aXDRvss2RDPt7Mtr82nDK6"
}
```

> Note: to learn more about the Morpheus plugin's public and private interfaces, please visit our technical documentation in the [SDK's repository](https://github.com/Internet-of-People/morpheus-dart).

<!-- tabs:end -->

#### Step 6. Create a Proof of Existence by Hashing the Data

<div class="row no-gutters">
    <div class="text-justify col-6 pr-3">
      Sharing the signed contract itself is often not a good way of proving its existence. 
      A better approach consists of storing the hash of the signed contract, which reveals nothing about its content. 
      If somebody wants to verify the signature of the contract, they can compare the hash stored on the blockchain with the hash of the contract.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>The signed contract is hashed into a content ID that proves the content without exposing it.</li>
                <li>Hashing an object into a content ID is also called digesting.</li>
                <li>We allow partial masking when only parts of the object are digested see more about it <a href="https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#json-digesting">here</a>.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_6}}}
```

Outputs:

```text
Proof of Existence: cjuMiVbDzAf5U1c0O32fxmB4h9mA-BuRWA-SVm1sdRCfEw
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_6}}}
```

Outputs:

```text
Proof of Existence: cjuMiVbDzAf5U1c0O32fxmB4h9mA-BuRWA-SVm1sdRCfEw
```

<!-- tabs:end -->

#### Step 7. Creating a SSI Transaction

<div class="row no-gutters">
    <div class="text-justify col-6 pr-3">
      To store the hash on the blockchain, you need to put it in a transaction.
      The transaction containing the hash is called an SSI transaction (Layer-2 transaction).
      Once accepted, the timestamp of the block containing the transaction proves that someone created the content before the timestamp. 
        <br><br>
      A single SSI transaction consists of one or multiple <a href="/glossary?id=ssi-operation">SSI operations</a>. Registering a hash - or Proof of Existence - is an example of such an operation.
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>As you see in the example, you create operation attemps. We call those attempts, because even if the blockchain (<a href="/glossary?id=layer-1">layer-1</a>) accepts the transaction, the <a href="/glossary?id=layer-2">layer-2</a> consensus mechanism might still reject it.</li>
                <li>When you send in a transaction with a Hydra account, the transaction has to contain a nonce, which is increased by one after each and every transaction.</li>
                <li>If you provide the ID of an existing block into the signed contents then you can also prove that the content was created after the timestamp of that block.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_7}}}
```

Outputs:

```text
Transaction ID: af868c9f4b4853e5055630178d07055cc49f2e5cd033687b2a91598a5d720e19
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_7}}}
```

Outputs:

```text
Transaction ID: af868c9f4b4853e5055630178d07055cc49f2e5cd033687b2a91598a5d720e19
```

<!-- tabs:end -->

#### Step 8. Query SSI Transaction from Blockchain

<div class="row no-gutters">
    <div class="text-justify col-6 pr-3">
        Aaaand you did it! Your SSI transaction is accepted by a node! You should be as happy as this unicorn right here: 🦄
        <br><br>
        Even though the transaction was successfully sent, it takes some time until it is included in a block and accepted by the consensus mechanism. After sending the transaction, you can fetch its status both on layer-1 and layer-2.
        <br><br>
        If a transaction was accepted on
        <ul>
            <li>layer-1, it was a valid Hydra transaction without any layer-2 consensus (e.g. its format is valid, fees are covered and a delegate forged it into a block)</li>
            <li>layer-2, it was also accepted as a valid SSI transaction</li>
        </ul>
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Good to know:</h5>
            <ul>
                <li>Don't forget, that the Hydra network's blocktime is 12s. Therefor, we put a timeout to ensure that the block containing our transaction has been forged.</li>
                <li>If you send in SSI transactions, remember to always confirm its validity on the layer-2.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_8}}}
```

Outputs:

```text
Tx status: {
    "id": "af868c9f4b4853e5055630178d07055cc49f2e5cd033687b2a91598a5d720e19",
    "blockId": "0adae3bd423939959aa800339555a6a2816f7ca1efef343bd1ab05fda185ae1c",
    "confirmations": 1,
    ...
}
SSI Tx status: true
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_8}}}
```

Outputs:

```text
Tx status: {
    "id": "af868c9f4b4853e5055630178d07055cc49f2e5cd033687b2a91598a5d720e19",
    "blockId": "0adae3bd423939959aa800339555a6a2816f7ca1efef343bd1ab05fda185ae1c",
    "confirmations": 1,
    ...
}
SSI Tx status: true
```

<!-- tabs:end -->

#### Final Step: Proving

The following steps allow you to prove the fact that you signed a contract when necessary. 

1. Load and present the contents of the signed contract from your safe storage.

2. Anyone can calculate its content ID, by hashing the content of the signed contract.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_9}}}
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_9}}}
```

<!-- tabs:end -->

3. The history of the content ID can be queried on layer-2 by using its API.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_10}}}
```

Outputs:

```text
Proof history: {
    "contentId": "cjuMiVbDzAf5U1c0O32fxmB4h9mA-BuRWA-SVm1sdRCfEw",
    "existsFromHeight": 507997,
    "queriedAtHeight": 508993
}
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_10}}}
```

Outputs:

```text
Proof history: {
    "contentId": "cjuMiVbDzAf5U1c0O32fxmB4h9mA-BuRWA-SVm1sdRCfEw",
    "existsFromHeight": 507997,
    "queriedAtHeight": 508993
}
```

<!-- tabs:end -->

4. This returns the blockheight, which you can use to check the timestamp (eg.: on the explorer) of the content ID. This means that the signature must have been created before being included in that block.

Congratulations, you've accomplished a lot by using our IOP stack. Don't forget, that if you need more detailed or technical information, visit the SDK's source code on GitHub ([Typescript](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk)/[Flutter](https://github.com/Internet-of-People/morpheus-dart)) or contact us <a href="mailto:dev@iop-ventures.com">here</a>.

<a href="/sdk?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>
