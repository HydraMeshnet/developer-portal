# Glossary

We assume that the reader has a basic understanding of

- [asymmetric cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography) including public and private keys
- digital signatures and [hash functions](https://en.wikipedia.org/wiki/Hash_function).

## Entity

A unique, real life actor such as a person, IoT device, company, group of people, etc. that a system wants to distinguish.

## Persona

An aspect of personal life a user wants to keep separated. Real life people might have multiple identities/roles
depending on their life situations, such as "dating persona" and/or "dayjob persona". Morpheus makes this separation explicit by allowing the user to create multiple personas, represented by separate DIDs (see [DID below](#did)).

## KeyId

A key identifier deterministically derived from a public key, e.g. a Bitcoin address. The derivation process must be irreversible, so that the public key cannot be guessed from the key identifier. To achieve this, derivations usually involve hashing functions. Note, that different use-cases might mandate different hashing algorithms and display formats to identify the same public key. For this reason, you can always check whether a KeyId belongs to a public key, but 2 different looking KeyIds could belong to the same public key.

## DID

All entities can generate a **d**ecentralized **id**entifier, a DID. Starting from a private/public keypair owned by an entity, a related DID is derived as KeyId of the public key.
By default, this originating public key is used to authenticate the controller of the DID, see [
DID document below](#implicit-throw-away-did-document).

The purpose of a DID is to reason about identity (in the mathematical sense of "being the same") over time, even when the keys used by an entity are replaced. It is decentralized so

- each entity alone can create any number of owned DIDs.
- there is no communication needed among entities to make sure each DID is unique.
- owners can prove that the DID belongs to them.
- different DIDs of the same entity by default seem unrelated to third parties.
- you can replace the authenticating keys (see below) while retaining the DID itself.
- you can split different rights (impersonation, update) on different keys.
- you can grant multiple keys the same rights.

## Proof of DID Control (Authentication and Authorization)

To prove control over a DID, an entity has to prove control over a certain keypair (private and public key) by signing a one-time object (e.g. a Signable Request or a Signable Statement).

To verify the signature, the relevant public key needs to be revealed or recovered from the signature. Validation then happens by verifying the signature (authentication) and then resolving the DID in question to its DID document and making sure the key used is authorized to act on behalf on the DID in this process (has the correct rights, authorization). If the DID Document mentions a KeyId instead of a public key, the public key used to validate the signature is hashed and compared.
For example, impersonation and changing the access control rules are clearly separated as different rights. Defining all possible rights is out of scope for this document.

Authorization rules for modifying access control rules are to be considered with special care. E.g. it is clear that an operation modifying the access control rules of a DID must be signed by a key that has appropriate access rights for modification. However, we have a special rule to allow only modifying *other keys* and to explicitly forbid any modification for the *signer key* itself. Thus the system can be protected from users accidentally revoking access rights from themselves or gaining additional rights without the mediation of another key.  

## Multicipher

Security awareness requires preparation for cryptographic algorithms becoming weaker and even obsolete over time. Replacing protocols hardwired into the code usually requires enormous efforts, see e.g. obsoleted SHA1 in the GIT version control system is not replaced with a stronger algorithm for years now. As a solution for these, good design must abstract away concrete cryptographic algorithms through well-designed interfaces and allow easy replacement.

There are already good existing libraries for multiple concepts like hashing, base-encoding, serialization, etc. Unfortunately we've found no appropriate one for cryptography. Following the design principles above, we refer to such a generic cryptographic library as *multicipher*, which offers self-describing data.

In our examples below, we use the following type prefixes:

- `p`: public key
- `i`: key identifier (hash of public key)
- `s`: signature
- `c`: content identifier (hash of maskable data structures)

The second character discriminates the actual cipher suite used:

- `e`: Ed25519 ECDSA
- `r`: Ristretto
- `s`: Secp256k1 ECDSA
- `S`: Secp256k1 Schnorr

Furthermore, our examples also use [multibase encoding prefixes](https://github.com/multiformats/multibase).

Example: `iezSomething` means a key identifier of a Ed25519 public-key base encoded with Base58-BTC.

## DID Document

The DID document is publicly available data and does NOT contain any personal information, but is used to manage permissions for keypairs. The document can use the `"services"` field to refer to external service endpoints that have additional information about the entity represented by the DID. To prove the relation between the DID and these services, endpoints should refer back to the corresponding DID using e.g. DNSSEC entries.

```json
# Current layer-2 endpoint returns DID documents in this format:
{
  "did": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
  "queriedAtHeight": 51063,
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
      "validFromHeight": 120,
      "validUntilHeight": null,
      "valid": true
    }
  ],
  "rights": {
    "impersonate": [
      {
        "keyLink": "#0",
        "history": [
          { "height": null, "valid": true }
        ],
        "valid": true
      },
      {
        "keyLink": "#1",
        "history": [
          { "height": null, "valid": false },
          { "height": 126, "valid": true }
        ],
        "valid": true
      }
    ],
    "update": [
      {
        "keyLink": "#0",
        "history": [
          { "height": null, "valid": true }
        ],
        "valid": true
      },
      {
        "keyLink": "#1",
        "history": [
          { "height": null, "valid": false }
        ],
        "valid": false
      }
    ]
  },
  "tombstoned": false,
  "tombstonedAtHeight": null
}
```

```json
# An imaginary format that might be closer to the W3C standard:
{
  "@context": "https://iop.global/did/v1",
  "did": "did:morpheus:ezFoo",
  "lastModifiedAtHeight": 126,
  "queriedAtHeight": 51063,
  "keys": [{
    "@id": "did:morpheus:ezFoo#key-0",
    "type": "Multicipher",
    "key": {
      "display": "iezFoo",
      "kind": "KeyId",
      "cipherSuite": "Ed25519",
      "base": "base58-btc",
      "hex": "01afaf01202af...",
    },
    "validFromHeight": null,
    "validUntilHeight": null,
  }, {
    "@id": "did:morpheus:ezFoo#key-1",
    "type": "Multicipher",
    "key": {
      "display": "pezBar",
      "kind": "PublicKey",
      "cipherSuite": "Ed25519",
      "base": "base58-btc",
      "hex": "03deadbeef...",
    },
    "validFromHeight": 504784,
    "validUntilHeight": 516501,
  }],
  "rights": {
    "impersonate": [{
      "keyLink": "#key-0",
      "history": [
        { "height": null, "valid": true }
      ],
      "valid": true
    }, {
      "keyLink": "#key-1",
      "history": [
        { "height": null, "valid": false },
        { "height": 126, "valid": true }
      ],
      "valid": true
    }],
    "update": [{
      "keyLink": "#key-0",
      "history": [
        { "height": null, "valid": true }
      ],
      "valid": true
    }, {
      "keyLink": "did:morpheus:ezBar#key-5",
      "history": [
        { "height": null, "valid": false }
      ],
      "valid": false
    }]
  },
  "services": [{
    "index": 0,
    "type": "mercuryAddress",
    "url": "mercury:ezFooBar"  
  }, {
    "index": 1,
    "type": "website",
    "url": "http://www.example.org"
  } ... ]
}
```

TBD: The `"services"` object could also be used to link to a revocation list, an API endpoint that returns a list of all statements signed by this entity that have been revoked.

Where

- `@context` defines the DID document format (JSON-LD context).
- `keys` is strictly ordered and append only. Some attributes of the key at a specific index might be changed though (e.g. `revokedHeight`).
- (TODO) In the `"keyLink": "did:morpheus:ezBar#key-5"` the URI can be split by the `#` character into a controller DID and a key index. The controller is optional and can be left out to refer to keys in the same DID document. You need the controller part to explicitly grant rights to an entity represented by a different DID.

## Implicit (Throw Away) DID Document

Some minimalistic use cases might only need signatures and simple authorization tokens, but don't need support for multiple devices, organizational structures with delegates and other advanced rights management features.

To make these cases simpler and cheaper, we do not always require registering a DID by adding a DID document to the blockchain. When there's no explicitly registered DID document found, the implicit Document below is returned and used instead as default.

```json
{
  "did": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
  "queriedAtHeight": 51063,
  "keys": [
    {
      "index": 0,
      "auth": "iezbeWGSY2dqcUBqT8K7R14xr",
      "validFromHeight": null,
      "validUntilHeight": null,
      "valid": true
    }
  ],
  "rights": {
    "impersonate": [
      {
        "keyLink": "#0",
        "history": [
          { "height": null, "valid": true }
        ],
        "valid": true
      }
    ],
    "update": [
      {
        "keyLink": "#0",
        "history": [
          { "height": null, "valid": true }
        ],
        "valid": true
      }
    ]
  },
  "tombstoned": false,
  "tombstonedAtHeight": null
}
```

In other words, the default way to prove control over a newly created DID is by authenticating with the KeyId, [see above](#proof-of-did-control-authentication-and-authorization). Any updates on this implicit document require registering the changes on the ledger.

## Witness

An attestant entity that has given its digital signature to some [claims](#claim). Using a [DID](#did), witnesses are able to change the cryptographic keys they use for signing statements over time.

Any entity can be a witness. However, the requirements to trust a witness are to be clarified for each use case. There are lots of use cases that require commonly trusted witnesses, so called [authorities](#authority).

Note that definitions of *witness* and *authority* correspond to [W3C's issuer](https://w3c.github.io/vc-data-model/#issuer), either untrusted or trusted.

## Authority

A company, state government or any other certificate provider entity that is trusted by many to be a reliable [witness](#witness). Also, an authority might delegate signing claims to any number of witnesses who act on behalf of the authority in certain respects.
For example, a bank or university can delegate appropriate rights to its clerks or employees. Delegations may be granted or revoked over time.

You can read more about it in the [Prometheus SDK](prometheus.md).

## Scenario

An inspection scenario describes a set of concatenated claims needed in a single presentation that are required to calculate a derived property of a DID and make an informed decision based on its value. Each claim must conform to a specified process, therefore a list of processes clearly defines the list of required claims.

An inspection might contain multiple scenarios, but the inspector must be able to calculate the same derived property for each scenario of the inspection.

For example if we take the [swimming pool use case](usecases/swimming_pool.md) a scenario would look like this:

```json
{
  "name": "Swimming discount",
  "version": 1,
  "description": "Reduced prices based on your resident address",
  "prerequisites": [
    {
      "process": {
        "name": "Digitalize ID card",
        "version": 1,
        "description": "Using a selfie with your ID card we make that piece of plastic obsolete.",
        "claimSchema": {
          "type": "object",
          "required": [ "address", "placeOfBirth", "dateOfBirth" ],
          "description": "We need you to provide some personal data presented on your ID card.",
          "properties": {
            "address": {
              "type": "string",
              "maskable": true,
              "description": "Eg. Berlin, Germany"
            },
            "placeOfBirth": {
              "type": "object",
              "required": [ "country", "city" ],
              "maskable": true,
              "properties": {
                "country": {
                  "type": "string",
                  "maskable": true,
                  "description": "Eg. Germany"
                },
                "city": {
                  "type": "string",
                  "maskable": true,
                  "description": "Eg. Berlin",
                  "minLength": 2,
                  "maxLength": 50
                }
              }
            },
            "dateOfBirth": {
              "type": "string",
              "subtype": "date",
              "pattern": "^(0[1-9]|1[0-9]|2[0-9]|3[0-1])\\\/(0[1-9]|1[0-2])\\\/(\\d{4})$",
              "maskable": true
            }
          }
        },
        "evidenceSchema": {
          "type": "object",
          "required": ["photo"],
          "description": "We need a selfie of you while holding your ID card that contains your address, place of birth, date of birth and your photo.",
          "properties": {
            "photo": {
              "type": "string",
              "subtype": "photo",
              "description": "A Base64 encoded photo blob"
            }
          }
        },
        "constraintsSchema": null
      },
      "claimFields": [".address"]
    }
  ],
  "requiredLicenses": [
    {
      "issuedTo": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
      "purpose": "Inspection by gate-keeper",
      "expiry": "P5M"
    }
  ],
  "resultSchema": {
    "type": "object",
    "required": ["discountPercentage"],
    "properties": {
      "discountPercentage": {
        "type": "number",
        "enum": [0, 5, 10],
        "description": "Same district gets 10%, same city 5%, otherwise full price"
      }
    }
  }
}
```

## Inspector

Another company, individual or any service provider entity that wants to verify the validity of a claim, presented by the subject in the form of a statement from a witness that is deemed trustworthy by the inspector. For example, an inspector can be a conductor, an event gatekeeper, a bartender, etc. Usually inspectors provide a list of [scenarios](#Scenario) with all the details they need.

You can read more about it in the [Prometheus SDK](prometheus.md).

Note that we have separated [W3C's verifier](https://w3c.github.io/vc-data-model/#dfn-verifier) into a potentially different inspector (~gatekeeper) and verifier (~API operator).

## Verifier

A service provider entity (might be conflated with the inspector) that is verifying the validity of a signature by looking up DID documents and comparing access rights.

*The verifier does not see any private information contained in the claim, only cryptographical hashes, signatures and other information relevant to validate the cryptography.*

You can read more about it in the [Prometheus SDK](prometheus.md).

## Content ID

Irreversible transformation of data into a shorter number.

- Different data will be provably hashed to different numbers in practical applications.
- Knowing only the hash of a data you cannot guess the data itself (calculation of pre-image is hard).
- Knowing both the hash and the data you cannot create a different data that hashes to the same number (calculation of second pre-image is hard).
- These properties imply that if you present a content ID to an *untrusted* peer and they show you some content that has the content ID you asked for, you can be sure that they showed you the genuine content that belongs to the ID.

Content IDs are used to identify and refer to a unique piece of data, such as claims. Content IDs are usually created by defining a serialization format for a dataset and applying a digest algorithm (see hash functions).

## Claim

A set of data that contains information about a subject entity.
The `nonce` field is used for data-masking, which you can read about [below](#maskable-claim-properties).

```json
# Example
{
  "subject": "did:morpheus:ezFoo",
  "content": { "ageOver": { "nonce": "zB58bar", "value": 42 } }
}
```

Note that this definition slightly differs from its W3C's counterpart and corresponds mostly to
[W3C's verifiable credential](https://w3c.github.io/vc-data-model/#credentials).
We lack the **verifiable** from the definition simply because we only care about verifiable data
and do not bother with unverifiable ones at all.

### Claim Subject

A DID of the entity (persona, company, etc.) the claim is about.

### Claim ID

Identifiers for claims are derived as the Content ID of its serialized form. In most practical cases the `subject` and the `content` fields need to be revealed separately, but the `content` might be collapsed to its [content ID](#content-id).

### JSON Masking

JSON documents can be represented as trees, considering primitives types - such as strings and numbers - as its leaves, while composite types - i.e. objects and arrays - creating its nodes.
This JSON tree can be transformed into a [Merkle tree](https://en.wikipedia.org/wiki/Merkle_tree) by recursively creating a content ID (i.e. hashing) all child nodes first, then calculating a hash of the parent node from their children.
The root hash of this Merkle tree provides a JSON content ID (a.k.a. digest or fingerprint) that masks the whole document. Note that this content ID enables integrity verification of contents that are potentially unknown at the moment and exposed only later on demand. You can also choose to "keep some subtree contents open", resulting in a "partially masked" Json document which has the same hash as the original one.

### Maskable Claim Properties

Using JSON as data format of verifiable claims, partial masking allows the user to replace the actual claim details by their content hashes, while still allowing verification of the integrity of the claim as a whole. For certain low entropy data, e.g. the `ageOver` property, it's relatively easy to brute-force the value from its hash. To make it harder, properties can be marked as "maskable". The value of these properties will be wrapped into an object (see the example above) with a big enough nonce (256 bit).

- Properties with object or array types can also be marked as maskable. This introduces increasing depth into the tree so it must be used with care.
- Using the same subject, same claim properties, but different nonces will result in different content hashes for the claim. This can improve privacy when requesting witness statements, but creates additional overhead when presenting these statements together as they refer to seemingly unrelated claims.

## Claim Schema

A schema for the `content` field of a claim, defining what information it needs to contain. These schemas can be defined ahead of time by witnesses (or anyone for that matter) and registered on a blockchain, so that the contents of claims they attest can reliably be machine-read.

```json
# Example
{
  "type": "object",
  "required": ["ageOver"],
  "properties": {
    "ageOver": {
      "type": "number",
      "description": "A number of whole years lived by the claimant. The actual age of the claimant can be much higher, but never lower.",
      "maskable": true,
      "minimum": 0,
      "maximum": 255
    }
  }
}
```

## Witness Request

Requests are sent by the **subject** or its delegate (a.k.a the **claimant**) for witnessing, containing all information required by the process of an [Authority](#authority).

```json
# Example
{
  "claim": {
    "subject": "did:morpheus:ezFoo",
    "content": { "ageOver": { "nonce": "zBASE58", "value": 42 } }
  },
  "claimant": "keyLink": "did:morpheus:ezCLAIMANT#5",
  "processId": "cjuPROCESS",
  "evidence": { "idCardScan": "uSCAN_BASE64" },
  "nonce": "uBIG_BASE64",
}
```

Note that hte `cju` prefix above is a [Content ID](#content-id) using JSON serialization and Base64 encoded after applying an SHA3-256 digest algorithm.

## Signed Witness Request

A [witness request](#Witness-Request) signed by the **subject** or its delegate (a.k.a the **claimant**). This will be sent to an [Authority](#authority).

```json
# Example
{
  "signature": {
    "publicKey": "pezBLAH",
    "bytes": "sezFOO",
  },
  "content": {
    "processId": "cjuPROCESS",
    "claimant": "did:morpheus:ezCLAIMANT#0",
    "claim": {
      "subject": "did:morpheus:ezFoo",
      "content": { "ageOver": { "nonce": "zBASE58", "value": 42 } }
    },
    "evidence": { "idCardScan": "uSCAN_BASE64" },
    "nonce": "uBIG_BASE64"
  }
}
```

### Evidence

Attached auxiliary information allowing verification of a claim, e.g. scanned documents, photos, etc.

For some use cases, any piece of evidence may be wrapped inside a self-signed [statement](#witness-statement) and then licensed using a [presentation](#claim-presentation) (see later). This serves several purposes:

1. The witness can request a license to store the evidence in exchange for signing the statement
2. The claimant testifies that he did not upload fraudulent data
3. If no license is requested by the witness, he is not authorized to store the data, allowing the client to legally enforce their right to data privacy.

### Process

Defines the following policies:

- the expected schema of the claim
- the expected schema of the evidence
- the expected schema of the constraints in the created witness statement
- an implied specification of the workflow and context used to determine if the claim is true and should be signed based on the attached evidence (the constraints)

This makes the process of requesting a statement fully transparent to anyone.

```json
# Example
{
  "name": "ID Card Based Age Verification",
  "version": 1,
  "description": "Describes how an age can be verified based on a presented ID card. Links to a regulation of a given jurisdiction.",
  "claimSchema": "cjuCLAIM_SCHEMA",
  "evidenceSchema": "cjuEVIDENCE_SCHEMA",
  "constraintsSchema": "cjuCONSTRAINTS_SCHEMA",
}
```

## Witness Statement

The complete testimony to be signed, containing the claim, the constraints and a nonce.

```json
# Example
{
  "claim": {
    "subject": "DID",
    "content": { "yearsOld": { "nonce": "uBIG_BASE64", "value": 21 } }
  },
  "processId": "cjuLINK_TO_PROCESS",
  "constraints": {
    "after": "ISO8601-datetime",
    "before": "ISO8601-datetime",
    "witness": "did:morpheus:ezCLERK#5",
    "authority": "did:morpheus:ezGOVERNMENT_OFFICE",
    "content": null
  },
  "nonce": "uBIG_BASE64",
}
```

### Statement Constraints

Restrictions that apply to the validity of the witness statement, e.g. timestamp, expiry, witness DID, on behalf of authority DID, etc.

## Signed Witness Statement

Cryptographic proof that the witness agrees to the statement.
Statements can be either the actual witness statement or just the [Content ID](#content-id) of it.

```json
# Example
{
  "signature": {
    "publicKey": "pezBLAH",
    "bytes": "sezFOO",
  },
  "content": { ... see Witness Statement|content ID ... }
}
```

## Claim Presentation

A collection of claims provided for validation for a verifier.

```json
# Example
{
  "claims": [{
    "claim": {
      "subject": "DID",
      "content": {
        "residence": {
          "country": { "nonce": "uBASE64", "value": "Germany" },
          "city": { "nonce": "uBAR64", "value": "Berlin" },
          "street": { "nonce": "uFOO64", "value": "Unter den Linden"},
        }
      }
    },
    "statements": [{
      "signature": {
        "publicKey": "pezBLAH",
        "bytes": "sezFOO",
      },
      "content": { ... see Witness Statement|content ID }
    }, ...]
  }, ...],
  "licenses": [{
    "issuedTo": "did:morpheus:ezINSPECTOR",
    "purpose": "Single entrance to Pub",
    "expiry": "ISO8601-datetime",
  }, {
    "issuedTo": "did:morpheus:ezANALYTICS_COMPANY",
    "purpose": "Statistics",
    "expiry": "ISO8601-datetime",
  }, ...]
}
```

Note that contrary to its W3C's counterpart, this definition lacks word **verifiable**
simply because we only care about verifiable data and do not bother with unverifiable ones at all.


### Licensing

Claim presentations and therefore evidences (using self-signed presentations) can be shared with 3rd parties for a wide variety of purposes, including commercial use.

Based on dozens of user privacy violation scandals, terms of utilizing user data must be clarified and respected.

For example, registering on a webshop to buy a pendrive, you only want to share your email for receiving the receipt or warranty documents, but don't want to share your email for direct marketing or user tracking.

[GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) is a regulation going towards that direction, but in practise did not have good enough educational effect on privacy-awareness of EU citizens.

To avoid arbitrary usage of data within claim, presentations define licenses to restrict terms of usage. Whenever user data is utilized in any way, the data processor must present a valid (and not expired) license attached to personal data to prove its compliance to regulations.

TBD: The exact details of how licensing should work need to be worked out. I imagine that expiry could be specified as "immediate", "one-use" or "one-time" for example.

## Masked Claim Presentation

The creator of the claim presentation can choose to present only ++parts of++ a claim together with the signed witness statements to a verifier, masking out remaining parts leaving just their content hashes.

It is mathematically possible to retain sensitive data from the signed claim, still having an evidence of the original signature on the original data (see [Maskable Claim Properties](#maskable-claim-properties)).

```json
# Example
{
  "claims": [{
    "claim": {
      "subject": "did:morpheus:ezBar",
      "content": {
        "residence": {
          "country": { "nonce": "uBASE64", "value": "Germany" },
          "city": "cjuCITY_HASH",
          "street": "cjuSTREET_HASH"
        }
      }
    },
    "statements": [ ... see the statements above ...]
  }, ...],
  "licenses": [ ... see licenses above ... ]
}
```

## Timestamping Statements

A timestamp included in a witness statement (depending on the constraints' schema) is only reliable if the witness is trusted by the inspector. Additional confidence in the timestamp of a signed statement (e.g. for a contract) can be achieved by using a blockchain.

- proving that a signature happened **before** a time instance: sending the content hash of the signed witness statement to the blockchain in a transaction. The consensus of all blockchain nodes make it practically impossible to insert transactions into the history of the blockchain, therefore it provides a strict ordering among blocks.
- proving that a signature happened **after** a time instance: bundle a block height and its hash to the object in question (a claim or a witness statement) before signing (see [After-Envelope below](#after-envelope)). It is practically impossible to guess what the hash of a future block will be. Also, it is practically impossible to change the hash of a given block, therefore knowing the block hash is good evidence for something happening after the time the block was created.

> Note that tying witness statements to the blockchain and registering changes of DID Documents are both using a blockchain as a public immutable ledger but are otherwise completely unrelated actions and usually happen independently. They need to use the same blockchain only to prove the order of different events.

### Revoking a Right from a Key

When a right is revoked from a key of a DID Document, there might be some signatures that are cryptographically valid, but without a proof of when that signature happened. These cannot be treated as fully authorized signatures, because there is no way to ensure that the signature was created before the key got revoked.
As a special case, the implicit DID document's default key could be revoked in the future, when the Ed25519 cryptography is replaced by a quantum-proof one on that DID.

Therefore, if a key is *restricted* in any way, all statements that were signed with that key and NOT registered to the blockchain before the restriction (SIGNED_BEFORE) will expire.

- A verifier must give a **warning** (yellow) to an inspector when the signing key was revoked and there is no proof on the blockchain that signing happened **before** that revocation. (There might be other information off-chain that could prove the ordering of events)
- A verifier must give an **error** (red) to an inspector when either the signature is cryptographically invalid or it can be proven that signing happened **after** the revocation.

### Granting a Right to a Key

When a key was granted new rights on a DID, in most use-cases you have to prove that the signature happened **after** that grant.

Therefore, if delegation was involved and the object is not wrapped in an AfterEnvelope (or the envelope is invalid), verification of the signature must return a warning that the integrity of the statement could not be fully verified.

- A verifier must a give a **warning** (yellow) to an inspector when there is no proof in the statement that signing happened **after** that grant. (There might be other information off-chain that could prove the ordering of events)
- A verifier must give an **error** (red) to an inspector when either the signature is cryptographically invalid or it can be proven that signing happened **before** the right was granted.

### After-Envelope

To verify that a [Witness Statement](#witness-statement) has been signed after a certain Block, it can be wrapped inside a AfterEnvelope before signing it to create a SignedWitnessStatement. The AfterEnvelope includes the height and the hash of a recent block of the chain, proving that this information was known to the creator of the envelope. This concept can be applied to any object that is signable, like claim presentations, witness requests, etc.
