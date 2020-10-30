# Layer-1 API

Our API consists of two main parts: [layer-1](glossary.md?id=Layer-1) and [layer-2](glossary.md?id=Layer-2). On layer-1 you do write operations that change the blockchain's state, while on layer-2 you do read operations without changing the state. 

To interact with the layer-1 API we suggest to use our [SDK](/sdk/), because signatures and other cryptographic operations are required to construct such transactions, which is not an easy programmer task.

> IMPORTANT NOTE: if at least one layer-2 operation fails in a transaction, the whole transaction fails at layer-2. Even though it fails at layer-2, you still have to pay for its cost at layer-1.

Please visit our [get started page](/get_started) to get a full overview of IOP's stack.

## Write SSI State

You can send in a [SSI](/glossary?id=ssi) transaction, which is the same as a plain Hydra transaction, but with additional data and different transaction type/typeGroup.

```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data 'TRANSACTION_CONTENT' \
  http://YOUR_SERVER_IP:4703/api/v2/transactions
```

> Note: Nodes running by IOP only provides HTTPS API using port 4705.

<details>
<summary>
Example transaction content (Click here to expand)
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
        "contentId": "cjuSomething"
      },
      {
        "operation": "signed",
        "signables": [
          {
            "operation": "addKey",
            "did": "did:morpheus:ezSomething",
            "auth": "iezSomethingElse"
          },
          {
            "operation": "addRight",
            "did": "did:morpheus:ezSomething",
            "auth": "iezSomethingElse",
            "right": "update"
          }
        ],
        "signerPublicKey": "pezSomething",
        "signature": "sezSomething"
      }
    ]
  },
  "signature": "e4435a288960ef7b6f3d48491ab40baa3d3d8398e83a6827f68ad19fbabf89d1db03165572bf9e4573ae33c1fbeb8b0751dd987e8b519afb70e55c0579671f89",
  "id": "6908c93e24fc6cd7befc98023b042ae6bbb4db61a4444ec4dd548c079e5f310f"
}
```

</details>

### SSI Operations

To be able to update the SSI state, you need to add `operationAttempts` to your layer-1 transaction.
Belowe the available operations can be put into a layer-1 custom transaction that writes the SSI state.

#### Register Proof of Existence

Registers a [Content ID](/glossary?id=content-id) which then proves the original content's existence at the height it gets forged into a block.

```json
{
    "operation": "registerBeforeProof",
    "contentId": "cjumTq1s6Tn6xkXolxHj4LmAo7DAb"
},
```

#### Add Key

Adds a key to the provided DID.

Notes:

- `auth` is a [multiCipher](/glossary?id=multicipher) public key or key identifier.
- `expiresAtHeight` allows optional auto-revokation at a given height

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "addKey",
      "did": "did:morpheus:ezSomething",
      "auth": "iezSomethingElse",
      "expiresAtHeight": 4251,
    }
  ],
  "signerPublicKey": "pezSomething",
  "signature": "sezSomething"
}
```

#### Revoke Key

Revokes a key from the provided DID.

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "revokeKey",
      "did": "did:morpheus:ezSomething",
      "auth": "iezSomethingElse"
    }
  ],
  "signerPublicKey": "pezSomething",
  "signature": "sezSomething"
}
```

#### Add Right

Adds a right to the provided key for the provided DID.

For now only update or impersonate is supported, but custom rights will be added soon.

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "addRight",
      "did": "did:morpheus:ezSomething",
      "auth": "iezSomethingElse",
      "right": "update"
    }
  ],
  "signerPublicKey": "pezSomething",
  "signature": "sezSomething"
}
```

#### Revoke Right

Revokes a right from the provided key for the provided DID.

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "revokeRight",
      "did": "did:morpheus:ezSomething",
      "auth": "iezSomethingElse",
      "right": "update"
    }
  ],
  "signerPublicKey": "pezSomething",
  "signature": "sezSomething"
}
```

#### Tombstone DID

Tombstones a DID. After this nobody can send updates or impersonate this DID.

```json
{
  "operation": "signed",
  "signables": [
    {
      "operation": "tombstoneDid",
      "did": "did:morpheus:ezSomething"
    }
  ],
  "signerPublicKey": "pezSomething",
  "signature": "sezSomething"
}
```

## Write DNS State

You can send in a [DNS](/glossary?id=dns) transaction, which is the same as a plain Hydra transaction, but with additional data and different transaction type/typeGroup.

```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data 'TRANSACTION_CONTENT' \
  http://YOUR_SERVER_IP:4703/api/v2/transactions
```

> Note: Nodes running by IOP only provides HTTPS API using port 4705.

<details>
<summary>
Example transaction content (Click here to expand)
</summary>

```json
{
  "version": 2,
  "network": 128,
  "typeGroup": 4242,
  "type": 2,
  "asset": {
    "bundles": [
      {
        "operations": [
          {
            "type": "register",
            "name": ".schema.company",
            "owner": "pszp9HBQY4qrx2yPGqM6biZeLmudJanMK6LXzXzLZGciLYA",
            "subtreePolicies": {},
            "registrationPolicy": "owner",
            "data": {},
            "expiresAtHeight": 1000
          }
        ],
        "nonce": 1,
        "publicKey": "pszp9HBQY4qrx2yPGqM6biZeLmudJanMK6LXzXzLZGciLYA",
        "signature": "ssz88WEbkTr2WVYNHZk2BC2wFmbn4dA6L3LUGYRJQf6rNSGNb8gsum75H7CgwW4YdXB8idwE1pGAEettzyqEroPera2"
      }
    ]
  },
  "nonce": "1",
  "senderPublicKey": "02bc7439e38eb478b26246a687260bcde87d58e42a940ece23f442ac254f8a7733",
  "fee": "100000000",
  "amount": "0",
  "id": "6fdc8415e1f9149806dd426b961cd5a3b171081414f96f61ff94d1e2977208d3",
  "signature": "304402203e30ea3b6ea56047d355e570c72ca0f383743d83c70fdd2d568e2b5faac4f4ff02202309602ae72300ac203af73851c496b4dc662fdd07a112068d50c922a1b44e93"
}
```

</details>

### DNS Operations

To be able to update the DNS state, you need to add operation `bundles` to your layer-1 transaction.
Belowe the available operations can be put into a bundle in a layer-1 custom transaction that writes the DNS state.

#### Register Domain

Registers a domain with the given data for the given [principal](/glossary?id=dns-principal) as the owner. Note, that the data must comply with the root domain's predefined schema.

```json
{
  "type": "register",
  "name": ".schema.company.salaryoffers",
  "owner": "pszp9HBQY4qrx2yPGqM6biZeLmudJanMK6LXzXzLZGciLYA",
  "subtreePolicies": {},
  "registrationPolicy": "owner",
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
  },
  "expiresAtHeight": 10000
}
```

#### Update Domain

Updates the data of the given domain. Note, that the new data must also comply with the root domain's predefined schema.

```json
{
  "type": "update",
  "name": ".schema.company.salaryoffer",
  "data": {
    "it-department": {
      "junior": {
        "min": 2000,
        "max": 2500
      },
      "senior": {
        "min": 3500,
        "max": 4500
      },
      "architect": {
        "min": 4000,
        "max": 6000
      }
    }
  }
}
```

#### Renew Domain

Renews the given domain to a new block height.

```json
{
  "type": "renew",
  "name": ".schema.company.salaryoffer",
  "expiresAtHeight": 20000
}
```

#### Transfer Domain

Transfers the ownership of the domain to a new [principal](/glossary?id=dns-principal).

```json
{
  "type": "transfer",
  "name": ".schema.company.salaryoffer",
  "toOwner": "pszkrWygFdYDVWr6L2G1Mt84RQVaJoy8ixcGhjCxqKqAoYn"
}
```

#### Delete Domain

Deletes the domain. After this operations is completed, the domain is available for registration.

```json
{
  "type": "delete",
  "name": ".schema.company.salaryoffer"
}
```