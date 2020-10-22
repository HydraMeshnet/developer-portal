# IOP Fort (Project Prometheus)

Fort is an umbrella project for libraries and applications using Decentralized Acces Control for various use cases, allowing or demonstrating secure handling of private data.
For example, we provide an SDK for developing SSI-based applications in Flutter/Dart
and mobile applications for different participants in a simple use case for demonstration.

### Claim Management and Data Masking

In real life, loads of situations occur when you must present (or even copy or share) your personal information in order to apply for services like entering a hotel. In almost all of these cases they only need a proof, that you're eligible to use their service or product. The problem with this is that massive data leaks happen frequently, so your data and your personal digital life is not safe as long as you give it to random companies daily basis.

This is where SSI is very usable, but as it's only a framework. Hence, we introduce our umbrella project as we call *Project Prometheus*, or IOP Fort.

IOP Fort is currently a set of mobile SDKs built in [Flutter](https://flutter.dev/) (cross-platform) and a set of backend (currently reference) applications that works offline *or* on top of SSI.

Using these SDKs you'll be able to provide solutions for the mentioned problems above by letting the users be able to strictly define what data (and only that data) they would like to share or present with other parties. It's a bit complex, so to be able to enhance the further reading, we created a reference use case with where we describe in a very detailed way an exact problem which we implemented for you using Fort SDK and SSI, as an example. You can read about it in the next section.

## Reference Implementation

### The Swimming Pool KYC Usecase

To be able to understand how powerful IOP SSI and Fort all together as quickly as possible, we took a common situation when one would like to apply for a discount but that requires some personal data. Please read the story [here](usecases/swimming_pool.md).

We also created a reference implementation where we actually solve this via IOP SSI and IOP Fort. The source code and its documentation is available [here](https://github.com/Internet-of-People/morpheus-kyc-ui).

This implementation contains all help you need to start building your own application with the SDKs you can find [here](#SDK).

### Other Possible Use Cases

Of course, the possbilities are endless, but we'd like to provide some more example to help you understand the power of IOP.

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

<div class="row">
  <div class="col-sm-4">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <h4 class="card-title">Dart SDK</h4>
        <h6 class="card-subtitle mb-2 text-muted">For Flutter mobile app development.</h6>
        <p class="card-text">
          This package gives you all tools you need to develop IOP Fort applications using Dart and Flutter
        </p>
        <a href="https://github.com/Internet-of-People/morpheus-dart" target="_blank" class="btn btn-sm btn-outline-primary mt-auto">Download Dart SDK</a>
      </div>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <h4 class="card-title">Typescript Authority Service</h4>
        <h6 class="card-subtitle mb-2 text-muted">A reference implementation for Authorities.</h6>
        <p class="card-text">
          A separated application (a simple HTTP endpoint) to receive witness requests and provide an interface to accept or deny requests.
          The service has to validate witness request signatures, thus internally depends on the Layer2 API of a blockchain node to resolve DID Document history.
        </p>
        <a href="https://github.com/internet-of-people/morpheus-ts/tree/master/packages/authority-service" target="_blank" class="btn btn-sm btn-outline-primary mt-auto">Download Authority Service</a>
      </div>
    </div>
  </div>
  <div class="col-sm-4">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <h4 class="card-title">Typescript Inspector Service</h4>
        <h6 class="card-subtitle mb-2 text-muted">A reference implementation for Inspectors / Validators.</h6>
        <p class="card-text">
          The service has to validate witness statement signatures in presentations, thus internally depends on the Layer2 API of a blockchain node to resolve Did Document history.
          We might even integrate these features into the hydra-core node either as part of the morpheus-plugin or another extra plugin.
        </p>
        <a href="https://github.com/internet-of-people/morpheus-ts/tree/master/packages/inspector-service" target="_blank" class="btn btn-sm btn-outline-primary mt-auto">Download Inspector Service</a>
      </div>
    </div>
  </div>
</div>

## API

### Authority

Please check the API documentation in its repository.

<a href="https://github.com/internet-of-people/morpheus-ts/tree/master/packages/authority-service/README.md#API" target="_blank" class="btn btn-sm btn-outline-primary">Read API Documentation</a>

### Inspector

Please check the API documentation in its repository.

<a href="https://github.com/internet-of-people/morpheus-ts/tree/master/packages/authority-service/README.md#API" target="_blank" class="btn btn-sm btn-outline-primary">Read API Documentation</a>
