# SSI SDK Tutorial: Create a Secure & Persistent Vault

In this tutorial, you will create a secure vault that is encrypted with a password and persisted on the disk. You will also try some of the features that do not require the password that unlocks the vault.

#### Prerequisites

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

- [NodeJS 12](https://nodejs.org/en/)
- `make` and either `python` or `python3`
- Download [the project template](https://github.com/Internet-of-People/ts-template/archive/master.zip) and setup the environment as described in the readme.

#### ** Flutter (Android) **

- [Flutter](https://flutter.dev/docs/get-started/install) installed.
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

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

The Typescript package is available on [npmjs.com](https://www.npmjs.com/package/@internet-of-people/sdk). 

In Typescript, you need to use multiple modules from the SDK (The Layer1 and Network module are already included in the project template). Additional features can be accessed through other modules about which you can read [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
{{{TS_STEP_1}}}
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
{{{FLUTTER_STEP_1}}}
```

<!-- tabs:end -->

#### Step 2. Create a Secure Vault

The SDK provides you multiple tools to protect your wallet:

- an optional **BIP 39** password, which is sometimes called the 25th word of the mnemonic phrase. It is very similar to adding a salt to passwords.
- an unlock password to encrypt your seed. This is useful if you wish to persist the vault's state. Hence, to derive the state, you need to decrypt the encrypted seed using this *Unlock Password*. 
- public state management for providing tools for convenient integration without the need to unlock the vault for some operations.

Below you can observe the code to create a secure vault.
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

**Technical Note**:

- The BIP39 password serves as an additional security measure and offers plausible deniability.
- The seed is encrypted using the XChaCha20-Poly1305 stream cipher and the key is derivated from the password with Argon2i.

#### Step 3. Persist State

Now that you created an encrypted vault, you possibly want to save its state for future purposes. You can do that easily by saving the JSON-file that represents your vault.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_3}}}
```

tutorial_vault.state:

```json
{
  "encryptedSeed": "uah9tbqSWh8w-mDVyW1zOpxejIptN-gFpmk6qpT9rgE_D3S8rj8pA0poSMcDqEsAzBaQ6TdFgGYOyJMGS7N7k99Ujo7Msm7Bk0kwYXO3tixvp4fqoAZNEpoXxVMzgX71xFQIiOPFF2cI",
  "plugins": []
}

```

*The state currently is empty as there have been no interactions with our modules (generation of new keys or DIDs). Try generating new keys and DIDs and see how your state looks like then.*

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_3}}}
```

tutorial_vault.state:

```json
{
  "encryptedSeed": "uah9tbqSWh8w-mDVyW1zOpxejIptN-gFpmk6qpT9rgE_D3S8rj8pA0poSMcDqEsAzBaQ6TdFgGYOyJMGS7N7k99Ujo7Msm7Bk0kwYXO3tixvp4fqoAZNEpoXxVMzgX71xFQIiOPFF2cI",
  "plugins": []
}

```
<!-- tabs:end -->

#### Final Step: Loading a secure Vault

You have learned how to create a secure, persisted vault. But what if you would like to **load** the state of an already existing vault? The code snippet below does this by reading your saved file and loads it with our SDK.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_4}}}
```

#### ** Flutter (Android) **

```dart
{{{FLUTTER_STEP_4}}}
```

<!-- tabs:end -->

#### Conclusion

Your 🦄 is happy again. You have an encrypted, BIP39 password-protected vault persisted on your safe storage. Congratulations! Don't forget, that if you need more detailed or technical information, visit the SDK's source code on GitHub([Typescript](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk)/[Flutter](https://github.com/Internet-of-People/morpheus-dart)) or contact us <a href="mailto:dev@iop-ventures.com">here</a>.

<a href="/sdk?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>
