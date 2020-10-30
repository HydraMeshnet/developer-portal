# IOP SSI (Project Morpheus)

Our SSI framework is a framework for self-controlled identities, data protection and access management (IAM) based on [W3C standards](https://w3c.github.io/did-core) that provides fully open SSI solutions. The framework combines the management and verification of access control requirements of interconnected organizations in a single system. The system offers privacy by default. Public blockchain technologies enable us to keep a verifiable history of the system without revealing private data. See [our DID method](w3c) for further details.

This page gives you a detailed overview of SSI's architecture, API and SDK that
provides an easy integration with other apps and tools.

## Architecture

It is possible to create and store multiple schemas, DIDs, keys, rights, and proof timestamps on a public blockchain. These can define authentication rules and manage access rights for each user. Designed with a privacy-first mindset, our SSI framework allows each real-life person to have multiple, seemingly independent personas to split user data into unrelated datasets by topic, (e.g. professional life, family, friends, etc.) for better privacy. The verifiable claims (VCs) are kept off-chain to enhance user privacy, while it preserves the capability of authenticating the data inside the claims.

The entities defined below are part of our SSI framework.

<img src="/assets/SSI_flow.png" class="d-block mx-auto my-5">

### Entities

#### Wallet (Holder)

An application that holds public and private keys and other information, such as claims or its representations. It can create a claim (a.k.a.: [Witness Request](/glossary?id=witness-request)) and sign it, thus transforming it to a [Signed Witness Request](/glossary?id=signed-witness-request). This ties the identity of the signer to the Witness Request. Once signed, the holder can send it to an Authority that verifies it. We call this process "witnessing", hence the name Witness Request.

#### Authority (Issuer)

A company, government, or any other certificate provider entity that is trusted by many to be a reliable [witness](/glossary?id=witness). It can receive a Signed Witness Request from a holder. After verifying the data, the Authority signs the statement and sends it back as a verified claim, or what we call a [Signed Witness Statement](/glossary?id=signed-witness-statement).

<a href="/api/authority_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

#### Inspector

A company,  service provider, or any individual that wants to verify a claim presented by its subject. This claim appears as a statement signed by a witness that is deemed trustworthy by the inspector. For example, an inspector can be a conductor, an event gatekeeper, a bartender, etc.

Usually, inspectors provide a list of [scenarios](/glossary?id=scenario) with all the details they need.

<a href="/api/inspector_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

#### Verifier

Note that we separated [W3C's verifier](https://w3c.github.io/vc-data-model/#dfn-verifier) into a potentially different inspector (gatekeeper) and verifier (API operator).

A service provider entity (might be conflated with the inspector) that is verifying the validity of a signature by looking up DID documents and comparing access rights.

*The verifier does not see any private information contained in the claim, only cryptographical hashes, signatures, and other information relevant to validate the cryptography.*

<a href="/api/verifier_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

## Identity, Keys and Access Control

Like any access control system, SSI allows creating multiple users (a.k.a DID, persona, profile),
define authentication rules and manage access rights for each user you control.
Designed with a privacy-first mindset, SSI allows each real life person to have multiple,
seemingly independent personas to split user data into unrelated datasets by topic,
e.g. completely separate professional life, family, friends, dating and hobbies for better privacy.

We currently support authenticating by signature of a public key or its hash.
At the moment we're having a fixed set of access rights and working on a customizable set of rights for each DID.

### Schemas

SSI can manage schemas to help other communicating parties settling an agreement on the data structures used.
For example, before verification of claims, the presenter and verifier have to agree
on the type and format of claims to be verified.

We currently support JSON schemas.

### Claims

Each DID might have a set of related data, i.e. claims. Validity of claims be attested by witness signatures.
Then such claims can be collected and their relevant parts presented for verification.
Meanwhile other sensitive parts of claims are kept private, i.e. masked out from verifiers.

We currently support claim signatures and masking using JSON documents.

### Proof Timestamps

Validation of signatures usually include verifying that contents were signed during a given timeframe.
SSI enables storing content hashes on the ledger, allowing proofs that some content
(e.g. a signature or just a plain document) was created before it was added to the ledger.
Note that proving a content was created after a time does not need a ledger,
just including reliably timestamped information into the content (e.g. ledger events or news headlines).
Also note that hashes stored on ledger are small and do not give any hint about the content timestamped.

### Decentralized Ledger (DLT)

SSI needs a ledger to order and keep a history of transactions using a decentralized consensus.
Though there's no technical requirement to use any specific ledger technology,
SSI is only implemented for the IOP Hydra blockchain.

In practice, SSI will always know which DIDs had which rights at which block height. It means, it's not just a decentralized right management API, but it also has an auditable, consensus based timeline.
SSI is running as a layer-2 plugin in the Hydra blockchain. Every time the node restarts/rewinds, its state is always recreated from layer-1 blockchain data. Consequently, data corruption is impossible and SSI state is still based on the layer-1 consensus. SSI uses [custom Ark transactions](https://blog.ark.io/an-introduction-to-blockchain-application-development-part-2-2-909b4984bae). So if you'd like to update your DID document, you can do that by sending a transaction to the Hydra blockchain.

All nodes by default are able to participate in the Hydra network and by default support this custom [AIP29](https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md) (see below) transaction, but still they're not forced to handle DID Document state.

It's important to note, that SSI and Hydra will NOT store any private data, hence its fully [GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) compliant.

Read more about custom transactions and its use cases and technical details:

- <https://blog.ark.io/an-introduction-to-blockchain-application-development-part-2-2-909b4984bae>
- <https://blog.ark.io/ark-core-gti-introduction-to-generic-transaction-interface-57633346c249>
- <https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md>

## Develop on SSI

In order to try out SSI, you have to connect to a Hydra network. You can do that locally or using IOP's infrastructure.
Please follow the guide [how to run a local testnet node](/hydra#run-testnet-node) or read how can you [access IOP's Hydra network](/hydra#hydra-networks).

### Tutorials

We provide you detailed tutorials on various use cases where you can learn and explorer our SSI SDK. 

<a href="/sdk/" class="btn btn-sm btn-outline-primary">Visit Tutorial Center</a>

### Samples

We also provide you sample codes base in an npm package that uses the SDK. It's more useful for demonstration purposes.

<a href="https://github.com/Internet-of-People/ts-examples/tree/master/morpheus" target="_blank" class="btn btn-sm btn-outline-primary">Download Samples</a>

We also made a demonstration video what is SSI (project Morpheus) and how can you use it.

<iframe width="560" height="500" src="https://www.youtube.com/embed/bnFDw7pIT3Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## API

We provide you a detailed API documentation where you learn what's the difference between layer-1 and layer-2 APIs.

<a href="/api/" class="btn btn-sm btn-outline-primary">BROWSE API DOCUMENTATION</a>