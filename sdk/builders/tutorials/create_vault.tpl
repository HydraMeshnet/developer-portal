# DAC SDK Tutorial: Create a Secure & Persistent Vault

In this tutorial you will create a secure vault which is encrypted with a password and persisted on the disk. You will also try some of the features that do not require the user to enter the unlock password.

#### Prerequisites

- [NodeJS 12](https://nodejs.org/en/)

#### Step 1. Import SDK

First as always, you need to access the SDK.

<!-- tabs:start -->

#### ** Javascript **

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).
Here, you only use the Crypto module.

```typescript
{{{TS_STEP_1}}}
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 2. Create a Secure Vault

The SDK provides you multiple tools to protect your wallet:

- an optional **BIP 39** password. It's for [plausible deniability](https://en.wikipedia.org/wiki/Plausible_deniability) and is sometimes called the 25th word of the mnemonic phrase. It's very similar to adding a <a href="https://en.wikipedia.org/wiki/Salt_(cryptography)" target="_blank">salt</a> to passwords.
- an unlock password for encrypting your seed. It's useful if you wish to persist the vault's state as the seed in the state will be encrypted. Hence, to access the seed in various cases it will require you to provide this password as a so called *Unlock Password*. It uses [XChaCha20Poly1305](https://tools.ietf.org/html/draft-arciszewski-xchacha-03) and it derivates the key from the password with [Argon2i](https://en.wikipedia.org/wiki/Argon2).
- public state management for providing tools for convenient integrations without the need to unlock the vault for some operations.

Below you can observe how you create a secured vault.

<!-- tabs:start -->

#### ** Javascript **

```typescript
{{{TS_STEP_2}}}
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 3. Persist State

Now you have a wallet, you possibly want to save its state to disk for future purpose. You can do that easily.

<!-- tabs:start -->

#### ** Javascript **

```typescript
{{{TS_STEP_3}}}
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Final Step: Loading a secure Vault

You've learnt how to create a secure, persisted vault. But what if you'd like to **load** an already existing vault-state?
It's easy and almost the same.

<p>
    In this example you load the vault's content from the disk into memory.
</p>

<!-- tabs:start -->

#### ** Javascript **

```typescript
{{{TS_STEP_4}}}
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Conclusion

Your 🦄 is happy again. You have an encrypted, BIP39 password protected vault persisted on your safe storage. Congratulations! Don't forget, that if you need more detailed or technical information, visit the SDK's source code on [GitHub](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk).

<a href="/#/sdk/dac?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>
