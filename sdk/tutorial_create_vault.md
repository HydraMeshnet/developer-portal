# DAC SDK Tutorial: Create a Secure & Persistent Vault

In this tutorial you will create a secure vault which is encrypted with a password and persisted on the disk. You will also try some of the features that do not require the user to enter the unlock password.

#### Prerequisites

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

- [NodeJS 12](https://nodejs.org/en/)
- Download [the project template]() and setup the environment as described in its readme.

#### ** Flutter (Android) **

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

First as always, you need to access the SDK.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).
Here, you only use the Crypto module.

```typescript
import { Crypto } from '@internet-of-people/sdk';
```

#### ** Flutter (Android) **

To be able to use our SDK in your Flutter Android application, you need to run our installer script first, that does the followings:

- It'll download the dynamic libraries you need and puts those files to the right place. Those files are required because the SDK's crypto codebase is implemented in Rust and uses Dart FFI.
- It'll add our Dart SDK into your `pubspec.yaml` file.

You just have to run this under your project's root on your Linux or MacOS (Windows is not yet supported):
```bash
curl https://raw.githubusercontent.com/Internet-of-People/morpheus-dart/master/tool/init-flutter-android.sh | sh
```

When the script finished, the only remaining task you have to do, is to import the SDK's crypto package and a helper package from dart in the `lib/main.dart`, where we do our work.

```dart
import 'dart:io';
import 'package:iop_sdk/crypto.dart';
```

<!-- tabs:end -->

#### Step 2. Create a Secure Vault

The SDK provides you multiple tools to protect your wallet:

- an optional **BIP 39** password. It's for [plausible deniability](https://en.wikipedia.org/wiki/Plausible_deniability) and is sometimes called the 25th word of the mnemonic phrase. It's very similar to adding a <a href="https://en.wikipedia.org/wiki/Salt_(cryptography)" target="_blank">salt</a> to passwords.
- an unlock password for encrypting your seed. It's useful if you wish to persist the vault's state as the seed in the state will be encrypted. Hence, to access the seed in various cases it will require you to provide this password as a so called *Unlock Password*. It uses [XChaCha20Poly1305](https://tools.ietf.org/html/draft-arciszewski-xchacha-03) and it derivates the key from the password with [Argon2i](https://en.wikipedia.org/wiki/Argon2).
- public state management for providing tools for convenient integrations without the need to unlock the vault for some operations.

Below you can observe how you create a secured vault.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// YOU HAVE TO SAVE IT TO A SAFE PLACE!
const phrase = new Crypto.Bip39('en').generate().phrase;

const vault = Crypto.Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#',
  'unlock password',
);
```

#### ** Flutter (Android) **

```dart
// YOU HAVE TO SAVE IT TO A SAFE PLACE!
final phrase = Bip39('en').generatePhrase();
final vault = Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#',
  'unlock password',
);
```

<!-- tabs:end -->

#### Step 3. Persist State

Now you have a wallet, you possibly want to save its state to disk for future purpose. You can do that easily.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
import { promises as fsAsync } from 'fs';

const serializedState = JSON.stringify(vault.save());
await fsAsync.writeFile(
  'tutorial_vault.state',
  serializedState,
  { encoding: 'utf-8' },
);
```

#### ** Flutter (Android) **

```dart
final serializedState = vault.save();
await File('tutorial_vault.state').writeAsString(
  serializedState,
  flush: true,
);
```

<!-- tabs:end -->

#### Final Step: Loading a secure Vault

You've learnt how to create a secure, persisted vault. But what if you'd like to **load** an already existing vault-state?
It's easy and almost the same.

<p>
    In this example you load the vault's content from the disk into memory.
</p>

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
const backup = await fsAsync.readFile(
    'tutorial_vault.state',
    { encoding: 'utf-8' },
);

const loadedVault = Crypto.Vault.load(JSON.parse(backup));
```

#### ** Flutter (Android) **

```dart
final backup = await File('tutorial_vault.state').readAsString();
final loadedVault = Vault.load(backup);
```

<!-- tabs:end -->

#### Conclusion

Your 🦄 is happy again. You have an encrypted, BIP39 password protected vault persisted on your safe storage. Congratulations! Don't forget, that if you need more detailed or technical information, visit the SDK's source code on [GitHub](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk).

<a href="/#/sdk/dac?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>
