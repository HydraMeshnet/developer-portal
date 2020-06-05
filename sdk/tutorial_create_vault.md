# DAC SDK Tutorial: Create a Secure & Persistent Vault

In this tutorial you will create a secure vault which is encrypted and persisted on the disk. To do that, you'll use the Vault's optional context parameter.

#### Prerequisites

- [NodeJS 12](https://nodejs.org/en/)

#### Step 1. Import SDK

First as always, you need to access the SDK.

<!-- tabs:start -->

#### ** Javascript **

In Typescript you need to use multiple modules from the sdk. Please read more about Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).
Here, you only use the Crypto and its corresponding modules.

```typescript
import { Crypto, Types } from '@internet-of-people/sdk';
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 2. Specify Storage Strategy

<div class="row no-gutters">
    <div class="col-6 pr-3">
        To have a persisted vault, you have to have a plan where and how would you store it. Fortunately, IoP's Vault is as modular as possible. <br>
        To achieve this, IoP's Vault lets you provide an optional context variable during its creation where you are able to define your storage strategy.
        <p>
            In this example you simple serialize the state into a JSON string, and then you save it to the disk via <code>fs</code>.
        </p>
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>IMPORTANT to note, that this method will be called anytime the vault's state is changed.</li>
                <li>The parameter <code>forDecrypt</code> is false when creating the vault for the first time and true in all other cases.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
import { promises as fsAsync } from 'fs';

const storageStrategy = async (state: Types.Crypto.IVaultState): Promise<void> => {
    const serializedState = JSON.stringify(state);
    await fsAsync.writeFile('secure_storage/vault.state', serializedState);
};
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 3. Specify Unlock Strategy

<div class="row no-gutters">
    <div class="col-6 pr-3">
        Similar to the storage strategy, you can also provide an unlock flow to this context parameter where you can implement your flow to provide the encryption password.
        Usually it pops up a modal or something that asks for a password.
        <p>
            In this example you simply expect that this is a console application so you just use NodeJS's readline.
        </p>
    </div>
    <div class="col-6">
        <div class="alert alert-info pb-0 mb-0">
            <h5>Hints</h5>
            <ul>
                <li>IMPORTANT to note, that this method will be called anytime the vault needs to be unlocked.</li>
                <li>The parameter <code>forDecrypt</code> is false when creating the vault for the first time and true in all other cases.</li>
            </ul>
        </div>
    </div>
</div>

<!-- tabs:start -->

#### ** Javascript **

```typescript
import readline from 'readline';

const unlockStrategy = async (forDecrypt: boolean): Promise<string> => {
    const method = forDecrypt ? 'decryption': 'encryption;
    console.log(`Please provide your vault's ${method} password:`);

    const input = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });
    
    for await (const line of input) {
        return line;
    }
}
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Step 4. Create the Vault

As you have the encryption/decryption and storage strategy written, you can create the wallet itself with the third context parameter.
<p>
    Before you do that, you can do one more important step to protect your vault by providing a BIP39 password, which is for <a href="https://en.wikipedia.org/wiki/Plausible_deniability" target="_blank">plausible deniability</a>. It's very similar to adding a <a href="https://en.wikipedia.org/wiki/Salt_(cryptography)" target="_blank">salt</a> to passwords.
</p>

<!-- tabs:start -->

#### ** Javascript **

```typescript

// YOU HAVE TO SAVE IT TO A SAFE PLACE!
const phrase = new Crypto.Bip39('en').generate().phrase;

const vault = await Crypto.Vault.create(
  phrase,
  '8qjaX^UNAafDL@!#',
  {
    askUnlockPassword: unlockStrategy,
    save: storageStrategy,
  },
);
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Final Step: Loading a Vault

You've learnt how to create a secure, persisted vault. But what if you'd like to **load** an already existing vault-state?
It's easy and almost the same.
<p>
    In this example you load the vault's content from the disk into memory.
</p>

<!-- tabs:start -->

#### ** Javascript **

```typescript

const serializedState = await fsAsync.readFile(
    'secure_storage/vault.state',
    { encoding: 'utf-8' },
);

const vault = await Crypto.Vault.load(
  JSON.parse(serialized),
  {
    askUnlockPassword: unlockStrategy,
    save: storageStrategy,
  },
);
```

#### ** Java **

Soon in 2020

#### ** Dart **

Soon in 2020

<!-- tabs:end -->

#### Conclusion

Your 🦄 is happy again. You have an encrypted, BIP39 password protected vault automatically persisted on your safe storage. Congratulations! Don't forget, that if you need more detailed or technical information, visit the SDK's source code on [GitHub](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk).

<a href="/#/sdk/dac?id=tutorial-center" class="btn btn-sm btn-primary mt-5">BACK TO TUTORIAL CENTER</a>