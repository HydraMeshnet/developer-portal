# Get Started

## What is IOP?

Internet of People (IOP) is building the IOP technology stack to foster decentralization while meeting the diverse needs of users, businesses, and institutions in the Web 3.0 world.

IOP's technology is open source and available for anyone. Although IOP is dedicated to providing a complete solution to the problems of online identity and privacy, IOP is fully modular without vendor lock-in: users and businesses are free to use and combine any part of the stack they want.

## IOP Technology Stack

As mentioned, IOP is fully modular, hence has several, well separated entities, but we are separated the stack into two main categories.

- IOP DAC
- IOP Hydra

These two main components give you a complete solution for various usecases where you have to manage your digital IDs (DID) or you have to implement a SSI based application.

The diagram below shows you a complete structure and relationship matrix between these two main components and its entities. After the diagram we provide a detailed explanation.

<img src="/assets/SSI_flow.png" class="d-block mx-auto">

### DAC

DAC is a Decentralized Access Control framework based on [W3C standards](https://w3c.github.io/did-core) to provide SSI solutions, store schemas, decentralized IDs (DIDs), keys, rights and proof timestamps on a ledger for public verification, keeping verifiable claims (VCs) off-ledger.

These entities defined below are all part of our framework that we call DAC.

<div class="mb-4">
    <a href="/#/dac" class="btn btn-sm btn-outline-primary mt-auto mr-1">LEARN DAC</a>
    <a href="/#/sdk/dac" class="btn btn-sm btn-outline-primary mr-1">SDK</a>
    <a href="/#/sdk/dac" class="btn btn-sm btn-outline-primary">API</a>
    <img src="/assets/flutter_square_logo.png" class="tech-logo ml-2" title="Supports Flutter/Dart">
    <img src="/assets/ts_square_logo.png" class="tech-logo ml-3" title="Supports Typescript">
</div>

#### Entities

##### Wallet (Holder)

An application that holds public and private keys and other informations, such as verified claims or its presentations. It can create a claim and can send it to an Authority to verify/prove it. We call this process as "witnessing", hence the name is [Witness Request](/glossary?id=witness-request).

##### Authority (Issuer)

A company, state government or any other certificate provider entity that is trusted by many to be a reliable [witness](/glossary?id=witness). It can receive and after verification sign Witness Requests. These verified data will be sent back as a verified claim, or as we call: [Signed Witness Request](/glossary?id=signed-witness-request).

<a href="/#/api/authority_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

##### Inspector

Another company, individual or any service provider entity that wants to verify the validity of a claim, presented by the subject in the form of a statement from a witness that is deemed trustworthy by the inspector. For example, an inspector can be a conductor, an event gatekeeper, a bartender, etc.

Usually inspectors provide a list of [scenarios](/glossary?id=scenario) with all the details they need.

<a href="/#/api/inspector_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

##### Verifier

Note that we have separated [W3C's verifier](https://w3c.github.io/vc-data-model/#dfn-verifier) into a potentially different inspector (~gatekeeper) and verifier (~API operator).

A service provider entity (might be conflated with the inspector) that is verifying the validity of a signature by looking up DID documents and comparing access rights.

*The verifier does not see any private information contained in the claim, only cryptographical hashes, signatures and other information relevant to validate the cryptography.*

<a href="/#/api/verifier_api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

#### Layer-1 and Layer-2 API

DAC extends the Hydra Blockchain with a plugin that adds two additional APIs to the Blockchain.
A layer-1 and a layer-2 API. These APIs enables you to write and read the consensus based DAC state.

<a href="/#/api/api" class="btn btn-sm btn-outline-primary mt-auto mb-2">BROWSE API</a>

### Hydra Blockchain (Project Hydra)

A dPos blockchain extended with a plugin to provide a public ledger for IOP DAC. Can be deployed in minutes with Docker.

<a href="/#/hydra" class="btn btn-sm btn-outline-primary">LEARN MORE</a>

## Showcase

To be able to present our vision, we have an umbrella project, IOP Fort (or project Prometheus), where we demonstrate how can these technologies/modules be used for various usecases.

<a href="/#/fort" class="btn btn-sm btn-outline-primary mt-auto mb-2">LEARN MORE</a>