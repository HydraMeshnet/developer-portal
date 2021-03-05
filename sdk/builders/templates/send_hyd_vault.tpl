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
{{{TS_STEP_1}}}
```

<!-- tabs:end -->

#### Step 2. Create a Vault

This code describes the creation of the vault, which is explained in the <a href="/sdk/tutorial_create_vault">Create a Secure Vault</a> tutorial.
<strong>Each time the code snippet below is run a new vault is generated!</strong> If you want to persist the vault, you need to store it appropriatly.
Check the previous tutorial if something is unclear!

 <!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_2}}}
```

<!-- tabs:end -->

#### Step 3: Initialize the Hydra Plugin

The cryptographic keyvault is similar to an HD wallet. To interact with the hydra blockchain, the keyvault needs to know some parameters,
so that it can generate the appropriate cryptographic keys for it. These parameters include the network and the account number.
Additionally, a user needs to be authenticated before granted access to change the vault. This is why you need the unlock password as well.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_3}}}
```

<!-- tabs:end -->
> Note: to learn more about the Hydra and other plugins, please visit our technical documentation in the [SDK's repository](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk).

#### Step 4: Get Target and Source Address

For this tutorial, you will send 1 HYD from the first address generated in your vault to the second address generated in your vault. Both addresses
are in your control. If you would like to send funds to another entity, just replace the target address with your intended recipient's address.

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_4}}}
```

<!-- tabs:end -->

#### Step 5: Send Test HYD to Yourself

This code describes how you can send funds from the HYD test faucet to yourself. It is explained in more detail in the <a href="/sdk/tutorial_send_hyd">Send HYD Programmaticaly</a> tutorial.
Check this tutorial if something is unclear!
<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_5}}}
```

<!-- tabs:end -->

#### Final Step: Send Test HYD using the Vault

Remember that funds only arrive after 12 seconds on average after being sent. Therefore it makes sense to initiate the transaction between two
addresses when you are sure that the transaction was confirmed on the blockchain. 
<!-- tabs:start -->

#### ** NodeJS (Typescript) **

```typescript
{{{TS_STEP_6}}}
```

Outputs:

```bash
Transaction ID: de7542ab693080dc1d51de23b20fd3611dac6a60c7a081634010f1f4aa413547
```

<!-- tabs:end -->
Congratulations, you used your personal vault to send HYD! Don't forget, that if you need more detailed or technical information, visit the SDK's source code on GitHub ([Typescript](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk)/[Flutter](https://github.com/Internet-of-People/morpheus-dart)) or contact us <a href="mailto:dev@iop-ventures.com">here</a>.
