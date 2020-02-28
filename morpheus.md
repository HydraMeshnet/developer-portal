# Morpheus

This page gives you a detailed overview of Morpheus's architecture, API and SDK.

## Table of Contents

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
   - [Query DID Operations](#Query-DID-Operations)
   - [Query DID Operation Attempts](#Query-DID-Operation-Attempts)
   - [Check Transaction Validity](#Check-Transaction-Validity)
   - [Check If Before Proof Exists](#Check-If-Before-Proof-Exists)
   - [Check Transaction Status](#Check-Transaction-Status)
- [SDK](#SDK)
  - [Usage](#Usage)
  - [Example Codes](#Example-Codes)

Morpheus is a Hydra plugin. All nodes by default are able to participate in the Hydra network and by default support this custom [AIP29](https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md) (see below) transaction, but still they're not forced to handle DID Document state.

## State Management

### Layer-1

It's called layer-1 as it's stored in the same database, the same way as other Hydra transactions.

We use [AIP29](https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md), custom transactions for managing operations on DID documents. There is intentionally no relation between authentication/authorization of Morpheus operations using Ed25519 keys and the authentication/authorization of the Hydra transaction using secp256k1 addresses. 

<details>
<summary>
An example of a Morpheus transaction (Click here to expand)
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

**After this nobody can sign updates or impersonate DID.**

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

WIP

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

The body must contain an array of operations that you're going to include in the Morpheus transaction. See in the example.

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

Check a Morpheus transaction's status if it was accepted or rejected.

```bash
GET /txn-status/{txid}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| txId | string | **Required**. The Hydra transaction (containing the Morpheus transaction) ID that you'd like to query. E.g.: `8c87b6802536196c3c4f55a17f3d941e235fcfcc669a5be80d4f75d057dc8561`

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

IoP provides a [Typescript](https://www.typescriptlang.org/) SDK for Morpheus available at <https://www.npmjs.com>.

### Usage

Please read the [README](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/did-manager) for details.

### Example Codes

Example codes are also available at <https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/examples>