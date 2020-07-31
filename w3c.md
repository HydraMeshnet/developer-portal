# IOP-Morpheus DID Method

## Introduction

In this document we introduce the DID method called Morpheus used by Internet of People. For a better understanding of the method, the following technical concepts and implementations are essential. 

### Hierarchical Deterministic Key Generation

A single user usually regularly needs multiple cryptographic keys, e.g. a separate key might be needed to connect each server. Systems like cryptocurrencies usually define identifiers (e.g. accounts) around such cryptographic keys. However, storing many keys and always selecting the right one is not an easy task.
 
 Hierarchical deterministic (HD) key generators were invented to avoid problems of key management, storage versioning and recovery, see the [BIP32 specification](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) for an example. Using a HD wallet, seemingly independent keys are derived from a single secret seed and can always be safely recovered as long as the secret seed is available, e.g. on a piece of physical paper. The seed is usually encoded as a list of words for easier handling.

Morpheus DIDs are derived from asymmetric cryptographic keys, regularly created on user devices by a HD key generator called the [IOP keyvault](https://github.com/Internet-of-People/keyvault-rust).

### Hydra blockchain

Distributed ledger technologies (DLT, blockchain) are mostly used by cryptocurrencies, but their event ordering and decentralized consensus algorithms are useful for general purpose. Morpheus needs DLT for safe ordering DID updates and querying the historical state of a DID Document at any given point of time for signature validation.

Morpheus currently uses the [Hydra blockchain](https://github.com/Internet-of-People/hydra-core/), a dPos ledger built as an Ark bridgechain and customized with DID-related transactions. Morpheus has a ledger-agnostic design, thus could operate with other ledgers as well. 

### KeyId
    
A key identifier derived from a public key, e.g. a Bitcoin address. The derivation process must be deterministic and irreversible. To achieve this, derivations usually involve hashing functions. Note, that different use-cases might mandate different hashing algorithms and display formats, thus different keyIds to identify the same public key.

### Multiformats

Morpheus uses self-describing [multiformats](https://multiformats.io/) to be future-proof with minimal code changes (e.g. migration to a new hash algorithm after a vulnerability revealed) or using different formats for different purposes. DID generation uses [multibase](https://github.com/multiformats/multibase).

The IOP keyvault also defines [multicipher](https://github.com/Internet-of-People/keyvault-rust/tree/develop/keyvault/src/multicipher) to abstract away details of asymmetric cryptographic keys, signatures and serialization formats. For example, multicipher value `"iezbeWGSY2dqcUBqT8K7R14xr"`describes a keyId (`i`) of an ed25519 (`e`) public key and is encoded with base58btc (`z`) having an actual encoded key hash value `beWGSY2dqcUBqT8K7R14xr`. 

## DID format

Morpheus DIDs have a `did:morpheus:` method identifier and conform to the [Generic DID Scheme](https://w3c.github.io/did-core/).

```
morpheus-did = "did:morpheus:" morpheus-idstring
morpheus-idstring = (multicipher-encoded asymmetric cryptographic keyId value)
```

Note that the multicipher value is always a keyId, thus the initial `i` discriminator prefix is not part of the `morpheus-idstring`.

For example, keyId `iezbeWGSY2dqcUBqT8K7R14xr` is transformed into Morpheus DID
`did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr`.



## CRUD operations

Morpheus DIDs are currently mapped to DID Documents on the Hydra ledger. Find the description of the related [Layer 1 API here](https://developer.iop.global/#/api/api).

### Create DID

Generate a multicipher-encoded keyId and transform it into a Morpheus DID. Any cryptographic library can be used to generate a private/public keypair, hash its public key and simply encode the result into multicipher format.

However, you should use a HD key generator for safety and convenience reasons. It is recommended to use the IOP keyvault with the following steps:
1. Generate an enthropy and save it as a BIP39-encoded word list, a.k.a. seed phrase
1. Initialize a keyvault with the enthropy used for its seed
1. Picking an arbitrary N index, deterministically derive the Nth Morpheus keyId from the seed
1. Transform the keyId into a DID (see above) 

### implicit DID Document

Some minimalistic use cases might only need signatures and simple authorization tokens, but don't need support for multiple keys or devices, complex organizational hierarchies and other advanced rights management features.

To lower the entry level, we do not always require registering a DID by publishing a DID Document on the ledger. If there's no explicitly registered DID Document found then an implicit Document is used instead as a default. Any update on this implicit document requires registering the applied changes on the ledger to be valid.

For example, the default DID Document of `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` enables only a single keyId `iezbeWGSY2dqcUBqT8K7R14xr` to authenticate with.

```json
{
  "@context": "https://www.w3.org/ns/did/v1",
  "id": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
  "authentication": [{
    "@id": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr#key-0",
    "type": "Ed25519VerificationKey2018",
    "controller": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
    "publicKeyBase58": "...public key used to derive keyId ezbeWGSY2dqcUBqT8K7R14xr..."
  },
  ...
}
```

In other words, the default way to prove control over a newly created DID is by authenticating with the public key used to derive the keyId included in the DID.

### Publish or Update DID Document

Whenever the controller of a DID decides to explicitly publish a default DID Document or apply any change to it, the DID document must be stored on the ledger.

Though one could always send the whole new DID Document to be stored on ledger and find the diffs during validation, the opposite way is more practical. We start from the implicit document, send ordered atomic operations (e.g. `addKey`, `revokeRight`, `tombstone`, etc) as diffs, validate and apply the operations or revert all modification attempts if any of them failed.

### Read (Resolve DID Document)

We provide ledger queries to access a snapshot of the whole DID Document at any given time or specialized requests for authorization checks. For a detailed description, see [Layer 2 API here](https://developer.iop.global/#/api/api).

When no DID Document state is found on the ledger for a specific DID, queries work with the implicit DID Document instead.

### Delete (Tombstone DID)

Delete is implemented as a special update operation which sets a `tombstoned` flag on the DID Document ensuring that any further operation on the document is invalid.
 
Note that we must not ever delete any previous information from the ledger. To be able to validate signatures and DID-related operations created in the past, previous keys and DID document states must be available for later use as well. E.g. signature of a dean on an electronic university degree must be verifiable even after decades.



## Privacy Considerations

### Personal Data

Private keys are stored in a keyvault on local user devices, hence owned and controlled by clients. No personal data is stored online, only DID Document details published on ledger that are necessary for authentication or authorization by other parties.

Users can control any number of DIDs with associated data and may choose to store related data locally or create encrypted online backups. Verifiable claim details can be masked in presentations, revealing only relevant parts to inspectors.

These features altogether provide full self-sovereign identities. 

### Gas Account

Ledger operations modifying DIDs have to pay transaction fees that can be deanonymized, which is a usual problem in systems like Ethereum. Morpheus does not require any connection between the updated DID and the address covering transaction costs, helping users staying anonymous.

### DID recovery

Versioning user data and synchronization between devices and restoring the environment of a lost or broken device on another machine is cumbersome in most system. Thanks to HD generators, all DIDs of a user can be rewound from a single secret seed stored on dedicated hardware or even a piece of paper in a safe.

### Plausible Deniability

Seed generation in the IOP KeyVault is capable of handling a BIP39 passphrase, i.e. an additional custom 25th word. Initializing the keyvault, providing a different word deterministically generates a completely different set of DIDs. Privacy-sensitive users (e.g. journalists) expecting being forced to unlock their devices for inspection may prepare a different set of DIDs in advance with this feature.



## Security Considerations

### Cryptographic Agility

IOP keyvault uses multicipher to handle cryptographic keys. Therefore in case of a vulnerability revealed on algorithms currently used, it is easy to secure future data changing preferred algorithms while keeping backwards compatibility. 

### JSON parser

JSON parsers used for DID Documents might have several vulnerability issues for malicious clients, regarding e.g. key repetition, unicode normalization, etc. Clients must use a secure parser conforming to best Json security practices, see e.g. the [JWS specification](https://tools.ietf.org/html/rfc7515#section-10.12) for more details.
