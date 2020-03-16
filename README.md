# Decentralized Identities

Take full control of your digital identity. IoP Solutions lets you create multiple independent private personas, create or witness claims about those, letting you securely manage every aspect of your life.

IoP's technology is open sourced and available for anyone to use or develop for. Although IoP is dedicated to providing a complete solution to the problems of online identity and privacy, IoP is fully modular and there is no lock-in: users and businesses are free to use and combine whichever parts of the stack they want.
Find out more about our design philosophy and the [IoP](https://iop.global/) stack in our [visionary white paper](https://iop.global/whitepaper/).

This document describes the current status of the toolset available for businesses and developers.

## Table of Contents

We suggest to delve into the ideas presented in these documents in this order:

- [Reading Guide](#Reading-Guide)
  - [Hydra Blockchain & DAC](#Hydra-Blockchain-and-DAC)
      - [DAC Explained](#DAC-Explained)
      - [Developing-on-DAC](#Developing-on-DAC)
  - [Prometheus Applications & Claim Management](#Prometheus-Applications-and-Claim-Management)
      - [The Swimming Pool KYC Usecase](#The-Swimming-Pool-KYC-Usecase)
      - [Other Usecases](#Other-Usecases)
- [External Materials](#External-Materials)

## Reading Guide

We divided this document into two main - but 100% related - parts (be prepared that we love to alias everything with greek gods' names):

1. Hydra Blockchain
2. Prometheus Applications

If you don't understand a word, a phrase or you don't know which greek god is which, please consult the [glossary](glossary.md).

### Hydra Blockchain and DAC (Decentralized Access Control Framework)

Hydra is a dPos blockchain, extended with IoP DAC, a layer-2 decentralized consensus, an access control framework.
DAC provides a [W3C compliant](https://w3c.github.io/did-core/) toolset to store and handle decentralized IDs (DIDs), rights and schemas on chain.

You can read more about the Hydra network and its parameters [here](hydra_network.md).

#### DAC Explained

DAC (or project Morpheus) is a Hydra plugin, running as a layer-2 application. Layer-2 means that everytime the node restarts/rewinds, its state will always be recreated from the layer-1 (the blockchain itself) data, hence data corruption is not possible and the is still based on the layer-1 consensus.

DAC's goal is to provide a decentralized DID & right management API for other apps and tools. It's able to do that via [custom transactions](https://blog.ark.io/an-introduction-to-blockchain-application-development-part-2-2-909b4984bae). So if you'd like to update your DID document, you can do that by sending a transaction to the Hydra blockchain.

Using a blockchain as its base, DAC will always know which DIDs had which rights at which block height. It means, it's not just a decentralized right management API, but it also has an auditable, consensus based timeline.

It's important to note, that DAC and Hydra will NOT store any private data, hence its fully [GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) compliant.

#### Developing on DAC

> As of the time of writing this document, DAC is available at IoP's testnet and devnet. It will soon be released to mainnet as well, be prepared.

If you'd like to use DAC, you can do it right now, you only need some Hydras.

Read more about [here](morpheus.md) how can you access the DAC's API and its SDK.

### Prometheus Applications and Claim Management

Prometheus is a kind of umbrella word for applications, which are use DAC in any way. To be more specific, these applications are not just using DAC, but they use DAC and its rights management capability for various usecases where you'd like to handle your private data securely.

Please read about more Prometheus and its architecture [here](prometheus.md).

#### The Swimming Pool KYC Usecase

To be able to understand it as quickly as possible, we created a KYC usecase, where you'll see how powerful the IoP ecosystem.

Please read about more this usecase [here](usecases/swimming_pool.md).

#### Other Usecases

Of course, the possbilities are endless, but we'd like to provide some more example to help you understand the power of IoP.

- [Digitalize ID Card](usecases/id_card.md)
- [Buying Tickets for Public Transportation](usecases/public_transportation.md)
- [Buying Tickets for a Movie](usecases/movie_theater.md)

Beside these, there are other scenarios as well we did not specified:
- Auditable event (concert, performance, sport match) attendance (when the GateKeeper's invalidate action is also public on the chain).
- Lottery bet/draw timestamping.
- Registration/attending/grading of exams at a university.
- Anonymous elections (registration to ballots, casting votes, ballot closing).

> Everything that has to do with timestamping should basically move into it's own section because timestamping on chain is an "unrelated" mechanism to the PKI provided by Morpheus and in my view clutters up the explanations here. I agree though that it is an absolutely awesome feature that we need to include at some point.

## External Materials

### Custom Transactions

These articles describe ARK's custom transaction, its use cases and technical details.

- https://blog.ark.io/an-introduction-to-blockchain-application-development-part-2-2-909b4984bae
- https://blog.ark.io/ark-core-gti-introduction-to-generic-transaction-interface-57633346c249
- https://github.com/ArkEcosystem/AIPs/blob/master/AIPS/aip-29.md
