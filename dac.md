# IOP DAC (Project Morpheus)

Decentralized Access Control framework based on <a href="https://w3c.github.io/did-core">W3C standards</a> to provide SSI solutions, store schemas, decentralized IDs (DIDs), keys, rights and proof timestamps on a ledger for public verification, keeping verifiable credentials/claims (VCs) off-ledger.

This page gives you a detailed overview of DAC's architecture, API and SDK that
provides an easy integration with other apps and tools.

## What is IOP DAC?

DAC is a decentralized identity and access management (IAM) framework, therefore
it can manage and verify access control requirements of interconnected organizations in a single system.
DAC keeps a timeline of all previous changes, thus proofs (e.g. timestamped signatures) can be later verified retrospectively.

### Identity, Keys and Access Control

Like any access control system, DAC allows creating multiple users (a.k.a DID, persona, profile),
define authentication rules and manage access rights for each user you control.
Designed with a privacy-first mindset, DAC allows each real life person to have multiple,
seemingly independent personas to split user data into unrelated datasets by topic,
e.g. completely separate professional life, family, friends, dating and hobbies for better privacy.

We currently support authenticating by signature of a public key or its hash.
At the moment we're having a fixed set of access rights and working on a customizable set of rights for each DID.

### Schemas

DAC can manage schemas to help other communicating parties settling an agreement on the data structures used.
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
DAC enables storing content hashes on the ledger, allowing proofs that some content
(e.g. a signature or just a plain document) was created before it was added to the ledger.
Note that proving a content was created after a time does not need a ledger,
just including reliably timestamped information into the content (e.g. ledger events or news headlines).
Also note that hashes stored on ledger are small and do not give any hint about the content timestamped.

### Decentralized Ledger (DLT)

DAC needs a ledger to order and keep a history of transactions using a decentralized consensus.
Though there's no technical requirement to use any specific ledger technology,
DAC is only implemented for the IOP Hydra blockchain.

In practice, DAC will always know which DIDs had which rights at which block height. It means, it's not just a decentralized right management API, but it also has an auditable, consensus based timeline.
DAC is running as a layer-2 plugin in the Hydra blockchain. Every time the node restarts/rewinds, its state is always recreated from layer-1 blockchain data. Consequently, data corruption is impossible and DAC state is still based on the layer-1 consensus. DAC uses [custom Ark transactions](https://blog.ark.io/an-introduction-to-blockchain-application-development-part-2-2-909b4984bae). So if you'd like to update your DID document, you can do that by sending a transaction to the Hydra blockchain.

All nodes by default are able to participate in the Hydra network and by default support this custom [AIP29](https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md) (see below) transaction, but still they're not forced to handle DID Document state.

It's important to note, that DAC and Hydra will NOT store any private data, hence its fully [GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) compliant.

Read more about custom transactions and its use cases and technical details:

- <https://blog.ark.io/an-introduction-to-blockchain-application-development-part-2-2-909b4984bae>
- <https://blog.ark.io/ark-core-gti-introduction-to-generic-transaction-interface-57633346c249>
- <https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md>

## Develop on DAC

In order to try out DAC, you have to connect to a Hydra network. You can do that locally or using IOP's infrastructure.
Please follow the guide [how to run a local testnet node](hydra#run-testnet-node) or read how can you [access IOP's Hydra network](hydra#hydra-networks).

### Tutorials

We provide you detailed tutorials on various use cases where you can learn and explorer our DAC SDK. 

<a href="/#/sdk/dac" class="btn btn-sm btn-outline-primary">Visit Tutorial Center</a>

### Samples

We also provide you sample codes base in an npm package that uses the SDK. It's more useful for demonstration purposes.

<a href="https://github.com/Internet-of-People/morpheus-ts/tree/master/packages/examples" target="_blank" class="btn btn-sm btn-outline-primary">Download Samples</a>

We also made a demonstration video what is DAC (project Morpheus) and how can you use it.

<iframe width="560" height="500" src="https://www.youtube.com/embed/bnFDw7pIT3Y" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## API

We provide you a detailed API documentation where you learn what's the difference between layer-1 and layer-2 APIs.

<a href="/#/api/api" class="btn btn-sm btn-outline-primary">BROWSE API DOCUMENTATION</a>