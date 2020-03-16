# DAC - Decentralized Access Control Framework

DAC, or project Morpheus is a Hydra plugin, running as a layer-2 application.
This page gives you a detailed overview of DAC's architecture, API and SDK.

## Table of Contents

- [Prerequisites](#Prerequisites)
  - [Local Development](#Local-Development)
  - [Connecting to Real Networks](#Connecting-to-Real-Networks)
- [State Management](#State-Management)
  - [Layer-1](#Layer-1)
    - [Operations & Signed Operations](#Operations-and-Signed-Operations)
    - [Operation Types](#Operation-Types)
      - [Register Before Proof](#Register-Before-Proof)
      - [Add Key](#Add-Key)
      - [Revoke Key](#Revoke-Key)
      - [Add Right](#Add-Right)
      - [Revoke Key](#Revoke-Right)
      - [Tombstone DID](#Tombstone-DID)
  - [Layer-2](#Layer-2)
- [API](#API)
   - [Query DID Document](#Query-DID-Document)
   - [Query DID Document Last Transaction ID](#Query-DID-Document-Last-Transaction-ID)
   - [Query DID Document Transaction IDs](#Query-DID-Document-Transaction-IDs)
   - [Query DID Document Transaction Attempts IDs](#Query-DID-Document-Transaction-Attempts-IDs)
   - [Query DID Operations](#Query-DID-Operations)
   - [Query DID Operation Attempts](#Query-DID-Operation-Attempts)
   - [Check Transaction Validity](#Check-Transaction-Validity)
   - [Check If Before Proof Exists](#Check-If-Before-Proof-Exists)
   - [Check Transaction Status](#Check-Transaction-Status)
- [SDK](#SDK)
  - [Usage](#Usage)
  - [Example Codes](#Example-Codes)

DAC is a Hydra plugin. All nodes by default are able to participate in the Hydra network and by default support this custom [AIP29](https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md) (see below) transaction, but still they're not forced to handle DID Document state.

## Prerequisites

In order to try out DAC, you have to connect to a Hydra blockchain. You can do that locally or using our infrastructure.

### Local Development

To be able to develop locally, you'll need a testnet running on your PC. To do that, you need [Docker](https://www.docker.com/) and [Docker Compose](#https://docs.docker.com/compose/).

Steps to start a local testnet:
1. Clone out [Hydra Core](https://github.com/Internet-of-People/hydra-core)
1. Go to the testnet directory: 
   ```bash
   cd docker/production/testnet
   ```
1. Unpack the basic configuration:
  ```bash
  tar -xvf mountpoints.tar.gz
  ```
1. Start Hydra Core:
  ```bash
  NETWORK=testnet MODE=genesis FORGING_MODE=auto_forge docker-compose up -d core
  ```
  This will fire up your node and a database for it.
1. Confirm that container are up:
  ```bash
  ...
  $ Creating postgres-hydra ... done
  $ Creating hydra-core     ... done
  ...
  ```
1. Confirm node is running and DAC API is ready:
  ```bash
  $ tail -f mountpoints/logs/testnet/hydra-core-current.log
  $ ...
  $ [2020-03-04 09:35:51.607] INFO : MORPHEUS HTTP API READY.
  $ ...
  $ [2020-03-04 09:49:14.208] DEBUG: MORPHEUS Task blockApplied: Morpheus block-handler 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41 started.
  $ [2020-03-04 09:49:14.208] DEBUG: MORPHEUS onBlockApplied contains 0 transactions..
  $ [2020-03-04 09:49:14.208] DEBUG: MORPHEUS applyEmptyBlockToState height: 3 id: 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41
  $ ...
  ```

Then, you can run your code against your local node.

### Connecting to Real Networks

You can either choose our [testnet](hydra_network.md?id=networks) or [devnet](hydra_network.md?id=networks) to work with. Note, that our testnet is not always up and might be reset regurarly.

Currently, we provide our SDK in Typescript only, and you can read about it [here](#SDK), how can you use it.

## State Management

### Layer-1

It's called layer-1 as it's stored in the same database, the same way as other Hydra transactions.

We use [AIP29](https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md), custom transactions for managing operations on DID documents. There is intentionally no relation between authentication/authorization of DAC operations using Ed25519 keys and the authentication/authorization of the Hydra transaction using secp256k1 addresses. 

<details>
<summary>
An example of a DAC transaction (Click here to expand)
</summary>

```json
{
  "version": 2,
  "network": 128,
  "typeGroup": 4242,
  "type": 1,
  "nonce": "3",
  "senderPublicKey": "0333931e52c1fa65c7ce13d50f7ca0a58442b48a54844effea83851108779cd6d3",
  "fee": "9192000",
  "amount": "0",
  "asset": {
    "operationAttempts": [
      {
        "operation": "registerBeforeProof",
        "contentId": "cqzSomething"
      },
      {
        "operation": "signed",
        "signables": [
          {
            "operation": "addKey",
            "did": "did:morpheus:ezSomething",
            "auth": "IezSomethingElse"
          },
          {
            "operation": "addRight",
            "did": "did:morpheus:ezSomething",
            "auth": "IezSomethingElse",
            "right": "update"
          }
        ],
        "signerPublicKey": "PezSomething",
        "signature": "SezSomething"
      }
    ]
  },
  "signature": "e4435a288960ef7b6f3d48491ab40baa3d3d8398e83a6827f68ad19fbabf89d1db03165572bf9e4573ae33c1fbeb8b0751dd987e8b519afb70e55c0579671f89",
  "id": "6908c93e24fc6cd7befc98023b042ae6bbb4db61a4444ec4dd548c079e5f310f"
}
```
</details>

#### Operations and Signed Operations

Operation attempts are sent in a transaction. One transaction may contain many attempts. The transaction will be forged into a valid block if it was properly paid (layer 1 block consensus). If any of the operation attempts in a single transaction is invalid at the current state of the DID, all other operation attempts in that transaction will also be ignored. If all attempts were valid, these are recorded on the DIDs and can be retrieved as operations.
**All blockchain nodes will conclude the same way whether an operation attempt is valid or not (layer 2 DID state consensus).**

Some operations do not need authentication, so they can be included in the transaction as a top-level item.

Some operations do need authentication, so they need to be wrapped in a signed operation. Each signed operation contains operations done in the name of a single key.


<details>
<summary>
Example of a signed operation (Click here to expand)
</summary>

```json
{
    "operation": "signed",
    "signables": [
        {
            "operation": "addKey",
            "did": "did:morpheus:ezSomething",
            "auth": "IezSomethingElse"
        },
        {
            "operation": "addRight",
            "did": "did:morpheus:ezSomething",
            "auth": "IezSomethingElse",
            "right": "update"
        }
    ],
    "signerPublicKey": "PezSomething",
    "signature": "SezSomething"
}
```
</details>

#### Operation Types

##### Register Before Proof

```json
{
    "operation": "registerBeforeProof",
    "contentId": "cjumTq1s6Tn6xkXolxHj4LmAo7DAb"
},
```

##### Add Key

Notes:
- auth is a multiCipher public key or key identifier.
- `expiresAtHeight` is optional auto-revokation at given height

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "addKey",
      "did": "did:morpheus:ezSomething",
      "auth": "IezSomethingElse",
      "expiresAtHeight": 4251,
    }
  ],
  "signerPublicKey": "PezSomething",
  "signature": "SezSomething"
}
```

##### Revoke Key

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "revokeKey",
      "did": "did:morpheus:ezSomething",
      "auth": "IezSomethingElse"
    }
  ],
  "signerPublicKey": "PezSomething",
  "signature": "SezSomething"
}
```

##### Add Right

For now only update or impersonate is supported, but custom rights will soon be supported as well.

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "addRight",
      "did": "did:morpheus:ezSomething",
      "auth": "IezSomethingElse",
      "right": "update"
    }
  ],
  "signerPublicKey": "PezSomething",
  "signature": "SezSomething"
}
```

##### Revoke Key

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "revokeRight",
      "did": "did:morpheus:ezSomething",
      "auth": "IezSomethingElse",
      "right": "update"
    }
  ],
  "signerPublicKey": "PezSomething",
  "signature": "SezSomething"
}
```

##### Tombstone DID

**After this nobody can send updates or impersonate DID.**

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "tombstoneDid",
      "did": "did:morpheus:ezSomething"
    }
  ],
  "signerPublicKey": "PezSomething",
  "signature": "SezSomething"
}
```

### Layer-2

Layer-2 as described earlier is a plugin, managing its own state in memory, based on layer-1 consensus. Layer 2 has its own API available, described below.
Using the layer-2 API you can access its current state or the history of the state at any given time.

## API

### Query DID Document

Returns the DID document (the implicit one if there were no operations yet on this DID)

```bash
GET /did/{did}/document/{blockHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |
| blockHeight | number | Optional. A logical timefilter, practically how the DID document looked like at that blockHeight. If not providing it, the current height will be used. |

##### Example

```bash
curl http://test.hydra.iop.global:4703/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/document
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "did": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
  "keys": [
    {
      "index": 0,
      "auth": "iezbeWGSY2dqcUBqT8K7R14xr",
      "validFromHeight": null,
      "validUntilHeight": null,
      "valid": true
    },
    {
      "index": 1,
      "auth": "iez25N5WZ1Q6TQpgpyYgiu9gTX",
      "validFromHeight": 1367,
      "validUntilHeight": null,
      "valid": true
    }
  ],
  "rights": {
    "impersonate": [
      {
        "keyLink": "#0",
        "history": [
          {
            "height": null,
            "valid": true
          }
        ],
        "valid": true
      },
      {
        "keyLink": "#1",
        "history": [
          {
            "height": null,
            "valid": false
          }
        ],
        "valid": false
      }
    ],
    "update": [
      {
        "keyLink": "#0",
        "history": [
          {
            "height": null,
            "valid": true
          },
          {
            "height": 1387,
            "valid": false
          }
        ],
        "valid": false
      },
      {
        "keyLink": "#1",
        "history": [
          {
            "height": null,
            "valid": false
          },
          {
            "height": 1382,
            "valid": true
          }
        ],
        "valid": true
      }
    ]
  },
  "tombstoned": false,
  "tombstonedAtHeight": null,
  "queriedAtHeight": 49253
}
```
</details>

### Query DID Document Last Transaction ID

Returns the latest transaction's ID which modified the DID document. It can be used for nonce generation.
If the DID document is not yet updated, it will return 404.

```bash
GET /did/{did}/transactions/last
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |

##### Example

```bash
curl http://test.hydra.iop.global:4703/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/transactions/last
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "transactionId": "9dd932b2c1f72bbcfd2159ed2672a9f42b744b2274d4fd49fc1d1c00be9d38a2",
  "height": 291
}
```
</details>

### Query DID Document Transaction IDs

Returns the transaction's ID which modified the DID document.
If the DID document is not yet updated, it will return an empty array.

```bash
GET /did/{did}/transactions/{fromHeight}/{untilHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |
| fromHeight | number | **Required**. The inclusive block height as the start of the query range. |
| untilHeight | string | Optional.The inclusive block height as the end of the query range. If not providing it, the current height will be used. |

##### Example

```bash
curl http://test.hydra.iop.global:4703/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/transactions/1
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
[
  {
    "transactionId": "c39121e5015f71d8c2528680a9af6487404216ee971177af246d82a11376e456",
    "height": 254
  },
  {
    "transactionId": "d518ffd356a759889e5f2f223904ecb3dd120a3f51b1f3889f5be82c6eaeaa77",
    "height": 286
  },
  {
    "transactionId": "9dd932b2c1f72bbcfd2159ed2672a9f42b744b2274d4fd49fc1d1c00be9d38a2",
    "height": 291
  }
]
```
</details>

### Query DID Document Transaction Attempts IDs

Returns the transaction's ID which modified the DID document. **Note**: also contains all transactions there were rejected.
If the DID document is not yet updated, it will return an empty array.

```bash
GET /did/{did}/transaction-attempts/{fromHeight}/{untilHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |
| fromHeight | number | **Required**. The inclusive block height as the start of the query range. |
| untilHeight | string | Optional.The inclusive block height as the end of the query range. If not providing it, the current height will be used. |

##### Example

```bash
curl http://test.hydra.iop.global:4703/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/transaction-attempts/1
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
[
  {
    "transactionId": "5a50b3635d06afa6dd87b1ca5013ec4fddedee848c777cccf50f8b6fac78a7d9",
    "height": 246
  },
  {
    "transactionId": "c39121e5015f71d8c2528680a9af6487404216ee971177af246d82a11376e456",
    "height": 254
  },
  {
    "transactionId": "d518ffd356a759889e5f2f223904ecb3dd120a3f51b1f3889f5be82c6eaeaa77",
    "height": 286
  },
  {
    "transactionId": "9dd932b2c1f72bbcfd2159ed2672a9f42b744b2274d4fd49fc1d1c00be9d38a2",
    "height": 291
  }
]
```
</details>

### Query DID Operations

Returns all operations that affected the given DID. Does NOT contain rejected operations.

```bash
GET /did/{did}/operations/{from}/{to?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |
| from | number | **Required**. The inclusive block height as the start of the query range. |
| to | number | Optional. The inclusive block height as the end of the query range. If not providing it, the current height will be used. |

##### Example

```bash
curl http://test.hydra.iop.global:4703/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/operations/0
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
[
  {
    "transactionId": "29772f5f2f9ddf5bb0a6f20936af19ba20ae2319e036d699537082e315b80719",
    "blockHeight": 1367,
    "data": {
      "operation": "addKey",
      "did": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
      "auth": "iez25N5WZ1Q6TQpgpyYgiu9gTX"
    },
    "valid": true
  },
  {
    "transactionId": "aa65317f074c04260475eef554f318ac9a0bf920abe74348e6af5efc906c1a2f",
    "blockHeight": 1382,
    "data": {
      "operation": "addRight",
      "did": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
      "auth": "iez25N5WZ1Q6TQpgpyYgiu9gTX",
      "right": "update"
    },
    "valid": true
  },
  {
    "transactionId": "8c87b6802536196c3c4f55a17f3d941e235fcfcc669a5be80d4f75d057dc8561",
    "blockHeight": 1387,
    "data": {
      "operation": "revokeRight",
      "did": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
      "auth": "iezbeWGSY2dqcUBqT8K7R14xr",
      "right": "update"
    },
    "valid": true
  }
]
```
</details>

### Query DID Operation Attempts

Returns all operations that affected the given DID. Contains both accepted and rejected operations.

```bash
GET /did/{did}/operation-attempts/{from}/{to?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |
| from | number | **Required**. The inclusive block height as the start of the query range. |
| to | number | Optional. The inclusive block height as the end of the query range. If not providing it, the current height will be used. |

##### Example

```bash
curl http://test.hydra.iop.global:4703/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/operation-attempts/0
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
[
   {
      "transactionId":"29772f5f2f9ddf5bb0a6f20936af19ba20ae2319e036d699537082e315b80719",
      "blockHeight":1367,
      "data":{
         "operation":"addKey",
         "did":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
         "auth":"iez25N5WZ1Q6TQpgpyYgiu9gTX"
      },
      "valid":true
   },
   {
      "transactionId":"e28b86b485a721f550c435762007ce68352a1d1c4f43e22b5397b03dfdc796e7",
      "blockHeight":1373,
      "data":{
         "operation":"addKey",
         "did":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
         "auth":"iez25N5WZ1Q6TQpgpyYgiu9gTX"
      },
      "valid":false
   },
   {
      "transactionId":"aa65317f074c04260475eef554f318ac9a0bf920abe74348e6af5efc906c1a2f",
      "blockHeight":1382,
      "data":{
         "operation":"addRight",
         "did":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
         "auth":"iez25N5WZ1Q6TQpgpyYgiu9gTX",
         "right":"update"
      },
      "valid":true
   },
   {
      "transactionId":"8c87b6802536196c3c4f55a17f3d941e235fcfcc669a5be80d4f75d057dc8561",
      "blockHeight":1387,
      "data":{
         "operation":"revokeRight",
         "did":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
         "auth":"iezbeWGSY2dqcUBqT8K7R14xr",
         "right":"update"
      },
      "valid":true
   }
]
```
</details>

### Check Transaction Validity

Using this endpoint you can validate your transaction to avoid being rejected and spending Hydras for basically nothing. Returns an array of errors. 

If the transaction is valid, it will return an empty array.

```bash
POST /check-transaction-validity
```

##### Parameters

The body must contain an array of operations that you're going to include in the DAC transaction. See in the example.

##### Example

```bash
curl -d '[{"operation": "registerBeforeProof", "contentId": "test"}]' -H "Content-Type: application/json" -X POST http://test.hydra.iop.global:4703/check-transaction-validity
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
[]
```
</details>

Error object's structure:

| Key | Type | Description |
|---|---|---|
| invalidOperationAttempt | object | The operation that was rejected. |
| message | string | The rejection reason. |


### Check If Before Proof Exists

Checks if a contentId exists at the given height.

```bash
GET /before-proof/{contentId}/exists/{blockHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| contentId | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |
| blockHeight | number | Optional. The block height where you'd like to check the existence of the before proof. In a case of not providing it, the current height will be used. |

##### Example

```bash
curl http://test.hydra.iop.global:4703/before-proof/dqcUBqT8K7R/exists
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
false
```
</details>

### Check Transaction Status

Check a DAC transaction's status if it was accepted or rejected.

```bash
GET /txn-status/{txid}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| txId | string | **Required**. The Hydra transaction (containing the DAC transaction) ID that you'd like to query. E.g.: `8c87b6802536196c3c4f55a17f3d941e235fcfcc669a5be80d4f75d057dc8561`

##### Example

```bash
curl http://test.hydra.iop.global:4703/txn-status/8c87b6802536196c3c4f55a17f3d941e235fcfcc669a5be80d4f75d057dc8561
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
true
```
</details>

## SDK

IoP provides a [Typescript](https://www.typescriptlang.org/) SDK for DAC available at <https://www.npmjs.com>.

### Usage

Please read the [README](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/sdk) for details.

### Example Codes

Example codes are also available at <https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/examples>