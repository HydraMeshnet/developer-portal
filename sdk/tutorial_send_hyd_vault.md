# SDK Tutorial: Sending HYD with the Vault

In this tutorial, you will combine what you saw in the previous two tutorials. You will use the vault to generate two addresses. 
You will get funds from a pre-generated wallet and then send HYD from one of your addresses to another. 
If you followed the previous two tutorials, you are equipped with the knowledge to do this on your own! Take on the challenge and come here if you are stuck somewhere!

#### Prerequisites

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

- [NodeJS 12](https://nodejs.org/en/)
- Download [the project template](https://github.com/Internet-of-People/ts-template/archive/master.zip) and setup the environment as described in the readme.


<!-- tabs:end -->

#### Step 1. Import SDK

First, you need to access the SDK in the code.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

The Typescript package is available on [npmjs.com](https://www.npmjs.com/package/@internet-of-people/sdk). After putting it into your package.json, you can start using it.

In Typescript, you need to use multiple modules from the SDK. Please read more about our Typescript modules [here](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk#Modules).

```typescript
// Import the necessary modules from our SDK
import { Crypto, Layer1, Network, NetworkConfig } from '@internet-of-people/sdk';
```

<!-- tabs:end -->

#### Step 2. Create a Vault

This code describes the creation of the vault, which is explained in the <a href="/sdk/tutorial_create_vault">Create a Secure Vault</a> tutorial.
<strong>Each time the code snippet below is run a new vault is generated!</strong> If you want to persist the vault, you need to store it appropriatly.
Check the previous tutorial if something is unclear!

 <!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// Create a vault
const encryptionKey = 'unlockPassword';
const mnemonic = new Crypto.Bip39('en').generate().phrase;
const vault = Crypto.Vault.create(
    mnemonic,
    '',
    encryptionKey
)
```

<!-- tabs:end -->

#### Step 3: Initialize the Hydra Plugin

The cryptographic keyvault is similar to an HD wallet. To interact with the hydra blockchain, the keyvault needs to know some parameters,
so that it can generate the appropriate cryptographic keys for it. These parameters include the network and the account number.
Additionally, a user needs to be authenticated before granted access to change the vault. This is why you need the unlock password as well.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// Initialize the Hydra plugin with the right parameters
const hydraParams = new Crypto.HydraParameters(
    Crypto.Coin.Hydra.Testnet,
    0
);
Crypto.HydraPlugin.rewind(vault, encryptionKey, hydraParams);

```

<!-- tabs:end -->
> Note: to learn more about the Hydra and other plugins, please visit our technical documentation in the [SDK's repository](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk).

#### Step 4: Get Target and Source Address

For this tutorial, you will send 1 HYD from the first address generated in your vault to the second address generated in your vault. Both addresses
are in your control. If you would like to send funds to another entity, just replace the target address with your intended recipient's address.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// Select the Hydra Account and different addresses
const hydraAccount = Crypto.HydraPlugin.get(vault, hydraParams);

const sourceAddress = hydraAccount.pub.key(0).address;
const targetAddress = hydraAccount.pub.key(1).address; 
```

<!-- tabs:end -->

#### Step 5: Send Test HYD to Yourself

This code describes how you can send funds from the HYD test faucet to yourself. It is explained in more detail in the <a href="/sdk/tutorial_send_hyd">Send HYD Programmaticaly</a> tutorial.
Check this tutorial if something is unclear!
<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// Initialize the Layer-1 API
const testnet = Network.Testnet;
const layer1Api = await Layer1.createApi(NetworkConfig.fromNetwork(testnet));

// Gain access to test HYD faucet
const walletPassphrase = "scout try doll stuff cake welcome random taste load town clerk ostrich";

// The layer 1 API is used to send funds to the source address
const amount = 1e8 // 1 HYD in flakes
await layer1Api.sendTransferTxWithPassphrase(walletPassphrase, sourceAddress, BigInt(amount));
```

<!-- tabs:end -->

#### Final Step: Send Test HYD using the Vault

Remember that funds only arrive after 12 seconds on average after being sent. Therefore it makes sense to initiate the transaction between two
addresses when you are sure that the transaction was confirmed on the blockchain. 
<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
// The previous transaction has to be confirmed.
setTimeout(async() => {
    const txId = await layer1Api.sendTransferTx(
        sourceAddress,
        targetAddress,
        BigInt(amount/2),
        hydraAccount.priv(encryptionKey)
    )
    console.log(txId);
}, 15000); // The callback is executed after 15s to ensure that the transaction was confirmed
```

Outputs:

```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

<!-- tabs:end -->
Congratulations, you used your personal vault to send HYD! Don't forget, that if you need more detailed or technical information, visit the SDK's source code on GitHub ([Typescript](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk)/[Flutter](https://github.com/Internet-of-People/morpheus-dart)) or contact us <a href="mailto:dev@iop-ventures.com">here</a>.
