# Get Started

## What is IOP?

Internet of People (IOP) is building the IOP technology stack to foster decentralization while meeting the diverse needs of users, businesses, and institutions in the Web 3.0 world.

IOP's technology is open source and available for anyone. Although IOP provides a complete solution to the problems of online identity and privacy, it is fully modular without vendor lock-in: users and businesses are free to use and combine any part of the stack they want.

## IOP Technology Stack

IOP is fully modular and has several well-separated entities. The stack is divided into two layers which contain three main components in total:

- Layer-1
  - IOP Hydra Blockchain
- Layer-2
  - IOP **S**elf **S**overeign **I**dentity (SSI)
  - IOP **D**omain **N**aming **S**ystem (DNS)

These three main components provide a complete solution for various use cases. Examples include managing digital IDs (DID); implementing an SSI-based application or storing schema documents in a decentralized DNS.

The diagram below shows the structure and relationship matrix between these three main components. Below the diagram we explain all parts shown there.

<img src="/assets/IOP_Stack.png" class="d-block mx-auto mt-5">

### Layer-1: Hydra Blockchain

A dPoS blockchain extended with a plugin to provide a public ledger for IOP SSI and DNS. This can be deployed in minutes with Docker.
This layer can receive transfer transactions and SSI/DNS state modifier transactions at the same time.

<a href="/hydra" class="btn btn-sm btn-outline-primary">LEARN MORE</a>

### Layer-2: Hydra Plugin

Layer-2 operates as a plugin inside the Hydra blockchain. Hence it shares the same consensus rules with the Hydra network for transactions. Layer-2 transactions are stored in the same database as other Hydra transactions. This financial layer keeps track of balances of wallets and orders the transactions in the pool based on paid fees and wallet nonces.

A layer-2 transaction is simply a Hydra transaction containing customized data. Therefore layer-2 transactions are sent like other Hydra transactions using the layer-1 API to modify the blockchain's state.

However, the ledger's layer-2 related state is separated from the layer-1 state. Reading the layer-2 state can be done using the layer-2 API.

Currently, layer-2 maintains a state that consists of two independent components as discussed below.

#### Self Sovereign Identity (SSI)

Our SSI framework provides self-controlled identities, data protection and access management (IAM) based on [W3C standards](https://w3c.github.io/did-core) enabling fully open SSI solutions.

<div class="mb-4">
  <a href="/ssi" class="btn btn-sm btn-outline-primary mt-auto mr-1">LEARN MORE</a>
  <a href="/sdk/" class="btn btn-sm btn-outline-primary mr-1">SDK</a>
  <a href="/api/" class="btn btn-sm btn-outline-primary">API</a>
  <img src="/assets/flutter_square_logo.png" class="tech-logo ml-2" title="Supports Flutter/Dart">
  <img src="/assets/ts_square_logo.png" class="tech-logo ml-3" title="Supports Typescript">
</div>

To present our vision, we have an umbrella project, IOP Fort (or project Prometheus), where we demonstrate how our stack can be used for various use cases. Read more about this showcase [here](/fort).


#### Domain Naming System (DNS)

IOP's DNS provides a decentralized solution for resolving domains. However, our DNS solution does not end here. We strive to create a naming system that is

- decentralized, i.e. fault-tolerant, unsupervised and anyone can join the network with his own node;
- open, i.e. anyone can register and maintain his own set of names;
- generic purpose, i.e. it can name not only network addresses, but anything from schemas and protocols through cryptocurrency accounts and DIDs to devices and rights.

<div class="mb-4">
  <a href="/dns" class="btn btn-sm btn-outline-primary mt-auto mr-1">LEARN MORE</a>
  <a href="/sdk/" class="btn btn-sm btn-outline-primary mr-1">SDK</a>
  <a href="/api/" class="btn btn-sm btn-outline-primary">API</a>
  <img src="/assets/ts_square_logo.png" class="tech-logo ml-3" title="Supports Typescript">
</div>
