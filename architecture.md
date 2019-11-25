# DIDs on Chain Architecture (Morpheus)

Here we define what kind of participants are needed to be fulfill the example use case (building on the KYC example). Also we define what toolset, API, etc. is needed for the given participants, hence the architecture will fully be described.

## Participants and its Architecture

### User Dependencies

Required toolset:
- keyvault for key-management
- DID with related DID document
- read process entries of BANK1
- share the latest DID document somewhere -> blockchain
- create claims + WitnessRequest
- sign WitnessRequest
- verify SignedWitnessStatement
- create presentations
- transfer presentations to Inspector

```mermaid
graph TB
  BlockchainDidAPI --> BlockchainDidPlugin
  BlockchainDidPlugin --> HydraCore
  
  DidManager --> npm:arkecosystem
  BlockchainDidPlugin --> npm:arkecosystem
  DidManager --> KeyVault
  
  WitnessRequestManager --> ProcessManager
  WitnessStatementManager --> ProcessManager
  ClaimManager --> ProcessManager
  User --> BlockchainDidAPI
  User --> DidManager
  User --> WitnessStatementManager
  User --> WitnessRequestManager
  User --> ProcessManager
  User --> PresentationManager
  User --> ClaimManager
  BlockchainDidPlugin --> DidManager
```

### Blockchain Plugin Dependencies

Required toolset:
- receive transactions for creating/modifying DID documents
- resolve DID to DID Document
- search for the DID document
  - by timestamp-range?
  - optional, caching for performance: by cryptographic public key and/or key id
- handle DID document updates

```mermaid
graph TB
  BlockchainDidAPI --> BlockchainDidPlugin
  BlockchainDidPlugin --> HydraCore
  BlockchainDidPlugin --> DidManager
  DidManager --> npm:arkecosystem
  BlockchainDidPlugin --> npm:arkecosystem
  DidManager --> KeyVault
```

### Bank1 Dependencies

Required toolset:
- keyvault for key-management
- DID with related DID document
- share process entries with Users
- verify User's WitnessRequest
- sign WitnessStatement

```mermaid
graph TB
  BlockchainDidAPI --> BlockchainDidPlugin
  BlockchainDidPlugin --> HydraCore
  
  DidManager --> npm:arkecosystem
  DidManager --> KeyVault
  BlockchainDidPlugin --> npm:arkecosystem
  BlockchainDidPlugin --> DidManager

  WitnessRequestManager --> ProcessManager
  WitnessStatementManager --> ProcessManager
  ClaimManager --> ProcessManager
  Bank1 --> BlockchainDidAPI
  Bank1 --> DidManager
  Bank1 --> WitnessRequestManager
  
  Bank1 --> ClaimManager
  Bank1 --> WitnessStatementManager
  Bank1 --> ProcessManager
  
```

### Bank2 Inspector Dependencies

Required toolset:
- securely connects to a verifier and uses its verification service (by sending signatures, content IDs and DIDs) masking out all contents
- a tool to receive and display the presentation received from its subject
- a tool to display the verification status or error(s)


```mermaid
graph TB
  WitnessStatementManager --> ProcessManager
  Bank2Inspector --> WitnessStatementManager
  Bank2Inspector --> ClaimManager
  ClaimManager --> ProcessManager
  Bank2Inspector -- requires --> VerifierAPI
```

### Bank2 Verifier Dependencies

Required toolset:
- securely receives the signatures, content IDs and DIDs from the delegated Inspector (no personal information)
- can connect to the blockchain to resolve DID Documents from DIDs and check blockhashes and logical timestamps
- can calculate cryptography

```mermaid
graph TB
  BlockchainDidAPI --> BlockchainDidPlugin
  BlockchainDidPlugin --> HydraCore

  DidManager --> npm:arkecosystem
  DidManager --> KeyVault
  BlockchainDidPlugin --> npm:arkecosystem
  BlockchainDidPlugin --> DidManager

  Bank2Verifier --> BlockchainDidAPI
  Bank2Verifier -- implements --> VerifierAPI
  Bank2Verifier --> CryptographicCalculator
```

## Describing Architecture

### KeyVault

The Prometheus KeyVault derives public keys for DID generation under the "morpheus" subtree.
> I'm still not convinced here [name=Bartmoss]

Already done directly with `prometheusd`, likely using `prometheus-cli`. If the use case requires, KeyVault can easily be extracted out into a standalone runnable.
- generate new keypair
- listing keys
- sign with a key: (TBD: currently prometheus supports signing claims only)
    - witnessRequest
    - witnessStatement
    - claimPresentation
    - Hydra AIP-11 transaction
    - "message signing"
- verify signature for a content ID with a provided public key
- verify if a provided key ID belongs to a provided public key

### DID Manager

This part will be a NPM package, a fork of [@arkecosystem/crypto](https://www.npmjs.com/package/@arkecosystem/crypto).

- create implicit DID
- create explicit DID
- add key
- revoke key
- grant right
- revoke right
- tombstone DID

TBD: define these in more details.

### Witness Statement Manager

It will be a Typescript(?) library.
- access the details of a process (claim schema, statement schema, etc.)
- unwrap a SignedWitnessRequest into Signature, Claim, Evidence (v1); the license attached to the Evidence (v2).
- verify the Signature (relies on the Blockchain extension)
- get current BlockHeight and BlockHeader from the blockchain to create "signedAfter" field.
- display the claim
- display the evidence to compare with the claim
- display licensing information (v2)
- create a statement according to the schema defined in the proces
- sign a completed WitnessStatement to create a SignedWitnessStatement
- register any of these on the blockchain for a "signedBefore" proof
  - SignedWitnessStatementID
  - ClaimID+ConstraintID+signature
  - ClaimID+Constraint+signature
  - MaskedClaim+Constraint+signature (heavily discouraged :warning:)
  - Claim+Constraint+signature (extremely discouraged :bomb:)

TBD: Do we have a separate Object called "SignedBeforeProof" that we can attach to SignedWitnessStatements in a Presentation to make lookup easier?

### Process Manager

TBD

### Claim Manager

It will be a Typescript(?) library.
- get a list of processes (including schemas)
- create claim according to a schema according to a process
- save claim with given nonces
- load saved claim

### Presentation Manager

It will be a Typescript(?) library.
- mask out fields from a claim
- combine claims and statements
- create licensing information
- sign a completed ClaimPresentation to create a SignedClaimPresentation (utilizes the KeyVault)
- save/load signed presentations

### Witness Request Manager

- wrap evidence in self-signed presentations (optional)
- create request from claim and evidence according to process
- sign completed WitnessRequest to create SignedWitnessRequest

### Blockchain Did Plugin

This extension will be a plugin. We may split this plugin into 2 parts:
- One handling Level 1 consensus, which needs to be active on all nodes.
- The level 2 consensus (the DID Database) can be extracted into another plugin that can be activated at will.

Hence we ensure that all nodes by default are able to participate in the Hydra network and by default support this custom AIP29 (see below) transaction, but still they're not forced to handle DID Document state.

#### AIP29 Assets

We use [AIP29](https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md), custom transactions for managing DID documents in layer 1.

```json
# Layer 1 data structure:
"asset": {
  "DID1": {
    "operation_attempts": [
      { ..op1.. }, // see OperationAttempts above
      { ..op2.. },
    ],
    "signature": {
      "key": "DID_A:idx",
      "bytes": "sezFOO"
    },
  },
  "DID2": {
    "operation_attempts": [
      { ..op3.. },
      { ..op4.. },
    ],
    "signature": {
      "key": "DID_B:idx",
      "bytes": "sezBAR"
    },
  }
}
```


TBD: short description.

#### Wallet API

As we can't easily extend the core's wallet API without updating the core's code, the plugin's API described below will be listening on a new port.

> Note: if there is no such document on the blockchain for the specified DID, then an implicit DID Document will be returned.

```typescript
/**
 * Returns the DID document (the implicit one if there were no operations yet on this DID)
 *
 * Path: GET /:DID/[:BLOCK_HEIGHT]
 * Responses:
 *   - 200 OK
 *
 * @param blockHeight (optional) - a logical timefilter, practically how the DID document looked like at that blockHeight
 * @returns the DID document itself
 */
getDidDocument(did: string, blockHeight?: number): DidDocument;
```

```typescript
/**
 * Reads all **valid** operations that happened on a DID in a time interval
 *
 * Path: GET /:DID/operations/[:FROM_BLOCK_HEIGHT]/[:TO_BLOCK_HEIGHT]
 * Responses:
 *   - 200 OK
 *
 * @returns array of **valid** operations
 */
getOperations(did: string, fromBlockHeightInc?: number, toBlockHeightInc?: number): Array<Operation>;

/**
 * Reads all operation attempts that happened on a DID in a time interval, both valid and invalid.
 *
 * Path: GET /:DID/operation-attempts/[:FROM_BLOCK_HEIGHT]/[:TO_BLOCK_HEIGHT]
 * Responses:
 *   - 200 OK
 *
 * @returns array of operation attempts, including invalid operations.
 */
getOperationAttempts(did: string, fromBlockHeightInc?: number, toBlockHeightInc?: number): Array<OperationAttempt>;
```

```typescript
/**
 * Checks if the transaction contains invalid operations based on the latest block known to the Hydra node. If other
 * Operations related to these DIDs are forged before this transaction, the operation attempts might still be ignored.
 *
 * Path: POST /:DID/transaction/validate
 * Request Body: TRANSACTION_OBJECT
 * Responses:
 *   - 200 OK
 *
 * @returns array of errors if any
 */
checkTransactionValidity(transaction: Transaction): Array<Error>;

/**
 *  400 Bad request: data is not well-formed
 *  401 Unauthorized: some signature is invalid
 *  403 Forbidden: some signing DID is not granted the rights they use
 *  404 Not found: a key or right revocation did not find its target in the document
 */
class Error {
  invalidOperationAttempt: OperationAttempt;
  code: number;
  message: string;
}

class Transaction {
  "operations": Array<OperationAttempt>
}
```

#### Operations

Operation attempts are sent in a transaction. One transaction may contain many attempts. The transaction will be forged into a valid block if it was properly paid (layer 1 block consensus). If any of the operation attempts in a single transaction is invalid at the current state of the DID, all other operation attempts in that transaction will also be ignored. If all attempts were valid, these are recorded on the DIDs and can be retrieved as operations.
**All blockchain nodes will conclude the same way whether an operation attempt is valid or not (layer 2 DID state consensus).**


```typescript
// Register Before Proof
{
  operation: "registerBeforeProof",
  params: {
    contentId: string
  }
}

// Add Key
{
  operation: "addKey",
  params: {
    multiCipher: string,
    controllerDid?: string
  }
}

// Note: multiCipher will allow the plugin to derive the exact kind of Key that was transmitted. It will be a type similar to the ones listed below.
// enum KeyType {
//   Ed25519KeyId,
//   Ed25519PublicKey,
//   RSAPublicKey2018,
//   ...
}
```

```typescript
// Revoke Key
{
  operation: "revokeKey",
  params: {
    keyIndex: number,
  }
}
```


```typescript
{
  operation: "addRight",
  params: {
    keyIndex: number,
    right: RightType
  }
}

enum RightType {
  Impersonate,
  Update,
  ...
}
```

```typescript
{
  operation: "revokeRight",
  params: {
    keyIndex: number,
    right: RightType
  }
}
```

```typescript
{
  operation: "addService",
  params: {
    type: string,
    url: string
  }
}
```

```typescript
{
  operation: "removeService",
  params: {
    type: string,
    url: string
  }
}
```

```typescript
{
  operation: "tombstoneDid",
  params: {
    did: string
  }
}
```


## Component/Data Diagram

```mermaid
classDiagram
  class ContentId
  Serializable <|-- ContentId

  class Unique
  Unique: <<"interface">>

  class Signature
  Signature: +publicKey: PublicKey
  Signature: +bool validate(bytes: Serializable)

  class Serializable
  Serializable: <<"interface">>
  Serializable: +byte[] getBytes()
  Serializable: +ContentId contentId()

  class Signable
  Signable: <<"interface">>
  Serializable <|-- Signable
  Unique <|-- Signable
  Signable o-- ContentId
  Signable: +Signature signWith(key: PrivateKey)

  class Claim
  Claim: +MorpheusValue data
  Claim: +DID subject

  class IWitnessRequest
  Signable <|-- IWitnessRequest
  IWitnessRequest <|-- AfterEnvelopeWitnessRequest
  IWitnessRequest: +MorpheusValue evidence
  IWitnessRequest: +u256 nonce

  class AfterEnvelopeWitnessRequest
  AfterEnvelopeWitnessRequest: +blockHash
  AfterEnvelopeWitnessRequest: +IWitnessRequest request

  class WitnessRequest
  AfterEnvelopeWitnessRequest *-- WitnessRequest
  IWitnessRequest <|-- WitnessRequest

  class SignedWitnessRequest
  SignedWitnessRequest: +request: IWitnessRequest
  SignedWitnessRequest: +signature: Signature
  SignedWitnessRequest *-- IWitnessRequest
  SignedWitnessRequest *-- Signature
  Signable <|-- SignedWitnessRequest

  class IWitnessStatement
  IWitnessStatement *-- Claim : claim
  IWitnessStatement o-- WitnessProcess : process
  IWitnessStatement: +MorpheusValue constraints
  IWitnessStatement: +u256 nonce

  class AfterEnvelopeWitnessStatement
  AfterEnvelopeWitnessStatement: +statement: WitnessStatement
  IWitnessStatement <|-- AfterEnvelopeWitnessStatement

  class WitnessStatement
  IWitnessStatement <|-- WitnessStatement
  AfterEnvelopeWitnessStatement *-- WitnessStatement

  class SignedWitnessStatement
  SignedWitnessStatement: +signature: Signature
  SignedWitnessStatement: +statement: IWitnessStatement
  SignedWitnessStatement *-- Signature
  SignedWitnessStatement *-- IWitnessStatement
  Signable <|-- SignedWitnessStatement
  Signable <|-- IWitnessStatement

  class WitnessProcess
  WitnessProcess: +String name
  WitnessProcess: +u16 version
  WitnessProcess: +String description
  WitnessProcess: +MorpheusSchema claimSchema
  WitnessProcess: +MorpheusSchema evidenceSchema
  WitnessProcess: +MorpheusSchema contraintsSchema

  IWitnessRequest *-- Claim : claim
  IWitnessRequest o-- WitnessProcess : process
  Signable <|-- WitnessProcess
```

> **Note**: Though `SignedWitnessRequest` and `SignedWitnessStatement` are both `Serializable` and `Unique`, thus (implicitly) `Signable` themselves, they contain a signature already and it rarely makes sense to add another signature on top of that.
