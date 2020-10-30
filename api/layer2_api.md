# Layer-2 API

Our API consists of two main parts: [layer-1](glossary.md?id=Layer-1) and [layer-2](glossary.md?id=Layer-2). On layer-1 you do write operations that change the blockchain's state, while on layer-2 you do read operations without changing the state. 

To interact with the layer-2 API we suggest to use our [SDK](/sdk/), but you can easily access it through simple REST.

Please visit our [get started page](/get_started) to get a full overview of IOP's stack.

## Endpoints

### SSI

#### Query DID Document

Returns the DID document (the implicit one if there were no operations yet on this DID).

```http
GET /morpheus/v1/did/{did}/document/{blockHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query (e.g. `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr`). |
| blockHeight | number | Optional. A logical timefilter that returns how the DID document looked like at that blockHeight. If it is not provided, the current height is used. |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/document
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

#### Query DID Document Last Transaction ID

Returns the latest transaction's ID which modified the DID document. It can be used for nonce generation.
If the DID document is not yet updated, it returns 404.

```http
GET /morpheus/v1/did/{did}/transactions/last
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query (e.g. `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr`). |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/transactions/last
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

#### Query DID Document Transaction IDs

Returns the transaction's ID which modified the DID document.
If the DID document is not yet updated, it returns an empty array.

```http
GET /morpheus/v1/did/{did}/transactions/{fromHeight}/{untilHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query (e.g. `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr`). |
| fromHeight | number | **Required**. The block height as the start of the query range (inclusive). |
| untilHeight | number | Optional.The block height as the end of the query range (inclusive). If it is not provided, the current height is used. |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/transactions/1
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

#### Query DID Document Transaction Attempts IDs

Returns the transaction's ID which modified the DID document. **Note**: also contains all transactions that were rejected.
If the DID document is not yet updated, it returns an empty array.

```http
GET /morpheus/v1/did/{did}/transaction-attempts/{fromHeight}/{untilHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query (e.g. `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr`). |
| fromHeight | number | **Required**. The block height as the start of the query range (inclusive). |
| untilHeight | number | Optional. The block height as the end of the query range (inclusive). If it is not provided, the current height is used. |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/transaction-attempts/1
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

#### Query DID Operations

Returns all operations that affected the given DID. Does NOT contain rejected operations.

```http
GET /morpheus/v1/did/{did}/operations/{from}/{until?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query (e.g. `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr`). |
| from | number | **Required**. The block height as the start of the query range (inclusive). |
| until | number | Optional. The block height as the end of the query range (inclusive). If it is not provided, the current height is used. |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/operations/0
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

#### Query DID Operation Attempts

Returns all operations that affected the given DID. Contains both accepted and rejected operations.

```http
GET /morpheus/v1/did/{did}/operation-attempts/{from}/{until?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. (e.g.  `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr`). |
| from | number | **Required**. The block height as the start of the query range (inclusive). |
| until | number | Optional. The block height as the end of the query range (inclusive). If it is not provided, the current height is used. |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/did/did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr/operation-attempts/0
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

#### Check Transaction Validity

Also known as "dry run". Using this endpoint you can validate your transaction to avoid being rejected and spending Hydras for invalid transactions. Returns an array of errors.

If the transaction is valid, it returns an empty array.

```http
POST /morpheus/v1/check-transaction-validity
```

##### Parameters

The body must contain an array of operations that you're going to include in the SSI transaction. See in the example.

##### Example

```bash
curl -d '[{"operation": "registerBeforeProof", "contentId": "test"}]' -H "Content-Type: application/json" -X POST https://test.hydra.iop.global:4705/morpheus/v1/check-transaction-validity
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

#### Check If Before Proof Exists

Checks if a content was existed before a given height.

```http
GET /morpheus/v1/before-proof/{contentId}/exists/{blockHeight?}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| contentId | string | **Required**. The digest of the content that might be proven to exist before a logical time (e.g.  `cjuc1fS3_nrxuK0bRr3P3jZeFeT51naOCMXDPekX8rPqho`) |
| blockHeight | number | Optional. The block height where you'd like to check the existence of the before proof. If it is not provided, the current height is used. |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/before-proof/cjuc1fS3_nrxuK0bRr3P3jZeFeT51naOCMXDPekX8rPqho/exists
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

#### Query Before Proof History

Retrieves at which height a contentId was registered.

```http
GET /morpheus/v1/before-proof/{contentId}/history
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| contentId | string | **Required**. The digest of the content that is proven to exist before a logical time. |

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/before-proof/cjuc1fS3_nrxuK0bRr3P3jZeFeT51naOCMXDPekX8rPqho/history
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "contentId": "cjuc1fS3_nrxuK0bRr3P3jZeFeT51naOCMXDPekX8rPqho",
  "existsFromHeight": 42,
  "queriedAtHeight": 69
}
```

or if it was not registered yet:

```json
{
  "contentId": "cjuc1fS3_nrxuK0bRr3P3jZeFeT51naOCMXDPekX8rPqho",
  "existsFromHeight": null,
  "queriedAtHeight": 69
}
```

</details>

#### Check Transaction Status

Check an SSI transaction's status if it was accepted or rejected.

```http
GET /morpheus/v1/txn-status/{txid}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| txId | string | **Required**. The Hydra transaction (containing the SSI transaction) ID that you'd like to query (e.g. `8c87b6802536196c3c4f55a17f3d941e235fcfcc669a5be80d4f75d057dc8561`).

##### Example

```bash
curl https://test.hydra.iop.global:4705/morpheus/v1/txn-status/8c87b6802536196c3c4f55a17f3d941e235fcfcc669a5be80d4f75d057dc8561
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

### DNS

#### Resolve Domain

Returns the data that was registered with the given domain.

```http
GET /coeus/v1/resolve/{domain}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| domain | string | **Required**. A domain you'd like to resolve, e.g. `.schema.company`.

##### Example

```bash
curl https://test.hydra.iop.global:4705/coes/v1/resolve/.schema.company
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data": {
    "it-department": {
      "junior": {
        "min": 1500,
        "max": 2000
      },
      "senior": {
        "min": 3000,
        "max": 4000
      },
      "architect": {
        "min": 3500,
        "max": 5000
      }
    }
  }
}
```

</details>

#### Query Metadata of a Domain

Returns the metadata of the given domain.

```http
GET /coeus/v1/metadata/{domain}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| domain | string | **Required**. A domain you'd like to query, e.g. `.schema.company`.

##### Example

```bash
curl https://test.hydra.iop.global:4705/coes/v1/metadata/.schema.company
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "owner": "pszp9HBQY4qrx2yPGqM6biZeLmudJanMK6LXzXzLZGciLYA",
  "subtreePolicies": {}, // for other features in the future 
  "registrationPolicy": "owner", // who can register under this domain, where owner means only the owner, any means anyone.
  "expiresAtHeight": 1000 // the domain will expire at this block height.
}
```

</details>

#### Query All Children of a Domain

Returns all subdomains (only one level down) under the given domain.

```http
GET /coeus/v1/children/{domain}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| domain | string | **Required**. A domain you'd like to query, e.g. `.schema.company`.

##### Example

```bash
curl https://test.hydra.iop.global:4705/coes/v1/children/.schema.company
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "children": [
    "it",
    "finance",
    "marketing"
  ]
}
```

</details>

#### Query Last Nonce Used by a Public Key

Returns all the last nonce used by a public key. Constructing Coeus transactions requires two nonces. One for the wallet who pays for the Hydra transaction and an other for the Coeus operation. The latter one is the owner of the domain which we query here.

```http
GET /coeus/v1/last-nonce/{publicKey}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| publicKey | string | **Required**. The public key you'd like get query.

##### Example

```bash
curl https://test.hydra.iop.global:4705/coes/v1/last-nonce/pszp9HBQY4qrx2yPGqM6biZeLmudJanMK6LXzXzLZGciLYA
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "nonce": "4"
}
```

</details>

#### Query Transaction Status

Returns if the Coeus transaction was successful on layer-2. Keep in mind, that a success layer-1 transaction does not mean that it success on layer-2 as well.

```http
GET /coeus/v1/txn-status/{transactionId}
```

##### Parameters

| Name | Type | Description |
|---|---|---|
| transactionId | string | **Required**. The layer-1 transaction id.

##### Example

```bash
curl https://test.hydra.iop.global:4705/coes/v1/txn-status/6fdc8415e1f9149806dd426b961cd5a3b171081414f96f61ff94d1e2977208d3
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
