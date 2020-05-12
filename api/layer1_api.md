# Layer-1 API

DAC's API consists of two main parts. Layer-1 and layer-2. On layer-1 you do write operations that change the blockchain's state, while on layer-2 you do read operations without touching the state.

Read more about what is layer-1 in its [definition](glossary.md?id=Layer-1).

## DAC Transaction Example

You can easily send in a DAC transaction as it's really the same as a Hydra transaction.

```bash
curl --header "Content-Type: application/json" \
  --request POST \
  --data 'TRANSACTION_CONTENT' \
  http://YOUR_SERVER_IP:4703/api/v2/transactions
```

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

## Operations

The following operations can be put into the layer-1 custom transaction.

### Register Before Proof

```json
{
    "operation": "registerBeforeProof",
    "contentId": "cjumTq1s6Tn6xkXolxHj4LmAo7DAb"
},
```

### Add Key

Notes:

- `auth` is a multiCipher public key or key identifier.
- `expiresAtHeight` is optional auto-revokation at given height

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

### Revoke Key

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

### Add Right

For now only update or impersonate is supported, but custom rights will soon be supported as well.

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

### Revoke Right

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

### Tombstone DID

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
  "signerPublicKey": "pezSomething",
  "signature": "sezSomething"
}
```