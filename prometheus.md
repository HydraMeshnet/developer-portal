# IoP Fort (Project Prometheus)

IoP Fort is a set of tools, SDKs and utilities that help you to utilize [IoP DAC](morpheus.md) power.

In this document we give you an overview and some example to show how powerful IoP Fort is on top DAC.

## Table of Contents <!-- omit in toc -->

- [What is IoP Fort](#what-is-iop-fort)
  - [Claim Management and Data Masking](#claim-management-and-data-masking)
- [Reference Implementation](#reference-implementation)
  - [The Swimming Pool KYC Usecase](#the-swimming-pool-kyc-usecase)
  - [Other Possible Use Cases](#other-possible-use-cases)
- [SDK](#sdk)
- [Authority Service](#authority-service)
- [Inspector Service](#inspector-service)

## What is IoP Fort

After reading about [IoP DAC](morpheus.md) you might think that IoP "only" provides a blockchain for DIDs. Which is far away from truth. IoP DAC is not just for DIDs, it's for decentralized IAM solutions as wel, but IoP does not stop at this point.

### Claim Management and Data Masking

In real life, loads of situations occur when you must present (or even copy or share) your personal information in order to apply for services or enter a hotel. In almost all of these cases they only need a proof, that you're eligible to use their service or product. The problem with this is that massive data leaks happen frequently, so your data and your personal digital life is not safe as long as you give it to random companies daily basis.

This is where DAC is very usable, but as it's only a framework. Hence, we introduce our umbrella project as we call *Project Prometheus*, or IoP Fort.

IoP Fort is currently a set of mobile SDKs built in [Flutter](https://flutter.dev/) (cross-platform) and a set of backend (currently reference) applications that works offline *or* on top of DAC.

Using these SDKs you'll be able to provide solutions for the mentioned problems above by letting the users be able to strictly define what data (and only that data) they would like to share or present with other parties. It's a bit complex, so to be able to enhance the further reading, we created a reference use case with where we describe in a very detailed way an exact problem which we implemented for you using Fort SDK and DAC, as an example. You can read about it in the next section.

## Reference Implementation

### The Swimming Pool KYC Usecase

To be able to understand how powerful IoP DAC and Fort all together as quickly as possible, we took a common situation when one would like to apply for a discount but that requires some personal data. Please read the story [here](usecases/swimming_pool.md).

We also created a reference implementation where we actually solve this via IoP DAC and IoP Fort. The source code and its documentation is available [here](https://github.com/Internet-of-People/morpheus-kyc-ui).

This implementation contains all help you need to start building your own application with the SDKs you can find [here](#SDK).

### Other Possible Use Cases

Of course, the possbilities are endless, but we'd like to provide some more example to help you understand the power of IoP.

- [Digitalize ID Card](usecases/id_card.md)
- [Buying Tickets for Public Transportation](usecases/public_transportation.md)
- [Buying Tickets for a Movie](usecases/movie_theater.md)

Beside these, there are other scenarios as well we did not specified:

- Auditable event (concert, performance, sport match) attendance (when the GateKeeper's invalidate action is also public on the chain).
- Lottery bet/draw timestamping.
- Registration/attending/grading of exams at a university.
- Anonymous elections (registration to ballots, casting votes, ballot closing).
- Presenting waybills in a supply chain selectively masking data based on the inspector.

## SDK

To be able to build IoP Fort Applications, we provide a

- Dart SDK for mobile apps (TBD URL),
- a Typescript [reference implementation](https://github.com/internet-of-people/morpheus-ts/tree/master/packages/authority-service) for [Authorities](glossary#Authority),
- a Typescript [reference implementation](https://github.com/internet-of-people/morpheus-ts/tree/master/packages/inspector-service) for [Inspectors](glossary#Inspector) and [Verifiers](glossary#Verifier)

Using these SDKs you're able to communicate between entities (Users, Authorities, Inspectors) and with DAC.

## Authority Service

<https://github.com/internet-of-people/morpheus-ts/tree/master/packages/authority-service>

A separated application to receive witness requests and provide an interface to accept or deny requests.
In the future we will use Mercury for publishing this service, but for it's a simple HTTP endpoint.

The service has to validate witness request signatures, thus internally depends on the Layer2 API of a blockchain node to resolve [DID Document](glossary.md#DID-Document) history.

Please check the [API documentation](https://github.com/internet-of-people/morpheus-ts/tree/master/packages/authority-service/README.md#API) in its repository.

## Inspector Service

<https://github.com/internet-of-people/morpheus-ts/tree/master/packages/inspector-service>

The service has to validate witness statement signatures in presentations, thus internally depends on the Layer2 API of a blockchain node to resolve Did Document history.

We might even integrate these features into the hydra-core node either as part of the morpheus-plugin or another extra plugin.

Please check the [API documentation](https://github.com/internet-of-people/morpheus-ts/tree/master/packages/authority-service/README.md#API) in its repository.
