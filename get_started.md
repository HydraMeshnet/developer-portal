# Get Started

## What is IOP?

Internet of People (IOP) is building the IOP technology stack to foster decentralization while meeting the diverse needs of users, businesses, and institutions in the Web 3.0 world.

IOP's technology is open source and available for anyone. Although IOP provides a complete solution to the problems of online identity and privacy, it is fully modular without vendor lock-in: users and businesses are free to use and combine any part of the stack they want.

## IOP Technology Stack

IOP is fully modular and has several well-separated entities. The stack is divided into two main components:

- IOP **S**elf **S**overeign **I**dentity (SSI)
- IOP Hydra

These two main components provide a complete solution for various use cases. Examples include managing digital IDs (DID) or implementing an SSI-based application.

The diagram below shows the structure and relationship matrix between these two main components and their entities. After the diagram, we provide a detailed explanation of these entities and their role inside the system.

<img src="/assets/SSI_flow.png" class="d-block mx-auto">

### Decentralized Access Control

Our SSI framework is a framework for self-controlled identities, data protection and access management (IAM) based on [W3C standards](https://w3c.github.io/did-core) that provides fully open SSI solutions. The framework combines the management and verification of access control requirements of interconnected organizations in a single system. The system offers privacy by default. Public blockchain technologies enable us to keep a verifiable history of the system without revealing private data.

It is possible to create and store multiple schemas, DIDs, keys, rights, and proof timestamps on a public blockchain. These can define authentication rules and manage access rights for each user. Designed with a privacy-first mindset, our SSI framework allows each real-life person to have multiple, seemingly independent personas to split user data into unrelated datasets by topic, (e.g. professional life, family, friends, etc.) for better privacy. The verifiable claims (VCs) are kept off-chain to enhance user privacy, while it preserves the capability of authenticating the data inside the claims.

The entities defined below are part of our SSI framework.

<div class="mb-4">
    <a href="/#/ssi" class="btn btn-sm btn-outline-primary mt-auto mr-1">LEARN MORE</a>
    <a href="/#/sdk/ssi" class="btn btn-sm btn-outline-primary mr-1">SDK</a>
    <a href="/#/sdk/ssi" class="btn btn-sm btn-outline-primary">API</a>
    <img src="/assets/flutter_square_logo.png" class="tech-logo ml-2" title="Supports Flutter/Dart">
    <img src="/assets/ts_square_logo.png" class="tech-logo ml-3" title="Supports Typescript">
</div>

#### Entities

##### Wallet (Holder)

An application that holds public and private keys and other information, such as claims or its representations. It can create a claim (a.k.a.: [Witness Request](/glossary?id=witness-request)) and sign it, thus transforming it to a [Signed Witness Request](/glossary?id=signed-witness-request). This ties the identity of the signer to the Witness Request. Once signed, the holder can send it to an Authority that verifies it. We call this process "witnessing", hence the name Witness Request.

##### Authority (Issuer)

A company, government, or any other certificate provider entity that is trusted by many to be a reliable [witness](/glossary?id=witness). It can receive a Signed Witness Request from a holder. After verifying the data, the Authority signs the statement and sends it back as a verified claim, or what we call a [Signed Witness Statement](/glossary?id=signed-witness-statement).

<a href="/#/api/authority_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

##### Inspector

A company,  service provider, or any individual that wants to verify a claim presented by its subject. This claim appears as a statement signed by a witness that is deemed trustworthy by the inspector. For example, an inspector can be a conductor, an event gatekeeper, a bartender, etc.

Usually, inspectors provide a list of [scenarios](/glossary?id=scenario) with all the details they need.

<a href="/#/api/inspector_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

##### Verifier

Note that we separated [W3C's verifier](https://w3c.github.io/vc-data-model/#dfn-verifier) into a potentially different inspector (gatekeeper) and verifier (API operator).

A service provider entity (might be conflated with the inspector) that is verifying the validity of a signature by looking up DID documents and comparing access rights.

*The verifier does not see any private information contained in the claim, only cryptographical hashes, signatures, and other information relevant to validate the cryptography.*

<a href="/#/api/verifier_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

#### Layer-1 and Layer-2 API

SSI extends the Hydra Blockchain with a plugin that adds two additional APIs to the Blockchain: a layer-1 and a layer-2 API. These APIs enable you to write and read the consensus-based SSI state.

<a href="/#/api/api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

### The Hydra Blockchain

A dPoS blockchain extended with a plugin to provide a public ledger for IOP SSI. This can be deployed in minutes with Docker.

<a href="/#/hydra" class="btn btn-sm btn-outline-primary">LEARN MORE</a>

## Showcase

To present our vision, we have an umbrella project, IOP Fort (or project Prometheus), where we demonstrate how our stack can be used for various use cases.

<a href="/#/fort" class="btn btn-sm btn-outline-primary mt-auto mb-2">LEARN MORE</a>
