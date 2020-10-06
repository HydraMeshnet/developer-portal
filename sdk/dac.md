# IOP DAC SDK

IOP's DAC is a **D**ecentralized **A**ccess **C**ontrol framework based on <a href="https://w3c.github.io/did-core">W3C standards</a> to store schemas, decentralized IDs (DIDs), keys, rights and proof timestamps on a ledger for public verification, keeping verifiable credentials/claims (VCs) off-ledger.

Please visit the [get started page](/get_started) to get a full overview of the IOP stack.

## Install

<!-- tabs:start -->

#### ** NodeJS (Typescript) **

To install the Typescript SDK, use [npm](https://www.npmjs.com/package/@internet-of-people/sdk) or our [Github repository](https://github.com/Internet-of-People/morpheus-ts).

```bash
npm install @internet-of-people/sdk --save
```

<span class="text-muted">Note: The package provides type definitions for [Typescript](https://www.typescriptlang.org/).</span>

#### ** Flutter (Android) **

To access our SDK in your Flutter Android application, run our installer script, which does the following:

- It downloads the necessary dynamic libraries and puts them at the right place. These files are required, because the SDK's crypto codebase is implemented in Rust and uses Dart FFI.
- It'll add our Dart SDK into your `pubspec.yaml` file.

You just have to run this under your project's root on your Linux or MacOS (Windows is not yet supported):
```bash
curl https://raw.githubusercontent.com/Internet-of-People/morpheus-dart/master/tool/init-flutter-android.sh | sh
```

<!-- tabs:end -->

## Tutorial Center

In this section we provide multiple guides that walk you through a simple use case introducing and teaching the DAC SDK.

<div class="container ml-0 pl-0">
  <div class="row ml-0 pl-0">
    <div class="col-sm-4 pl-0 ml-0">
      <div class="card h-100">
        <div class="card-body d-flex flex-column">
          <h4 class="card-title">Sending HYD Programatically</h4>
          <p class="card-text">In this guide you will learn how to send HYD without using a desktop wallet.</p>
          <a href="/#/sdk/tutorial_send_hyd" class="btn btn-sm btn-outline-primary mt-auto">START TUTORIAL</a>
        </div>
      </div>
    </div>
    <div class="col-sm-4 pl-0 ml-0">
      <div class="card h-100">
        <div class="card-body d-flex flex-column">
          <h4 class="card-title">Contract Signature Proof On-Chain</h4>
          <p class="card-text">In this guide you will learn to create your first DID and after signing a contract how you can store a proof about it on-chain, without revealing any <abbr title="Personally Identifiable Information">PII</abbr>.</p>
          <a href="/#/sdk/tutorial_dac_contract" class="btn btn-sm btn-outline-primary mt-auto">START TUTORIAL</a>
        </div>
      </div>
    </div>
    <div class="col-sm-4 pl-0 ml-0">
      <div class="card h-100">
        <div class="card-body d-flex flex-column">
          <h4 class="card-title">Create/Load a Secure Vault</h4>
          <p class="card-text">Learn how to create a secure, persistent vault using DAC SDK.</p>
          <a href="/#/sdk/tutorial_create_vault" class="btn btn-sm btn-outline-primary mt-auto">START TUTORIAL</a>
        </div>
      </div>
    </div>
  </div>
  <div class="row ml-0 pl-0 mt-3">
    <div class="col-sm-4 pl-0 ml-0">
      <div class="card h-100">
        <div class="card-body d-flex flex-column">
          <h4 class="card-title">Swimming Pool Discount</h4>
          <p class="card-text">In this guide we introduce you more advanced concepts and other participants in the IOP ecosystem.</p>
          <a class="btn btn-sm btn-outline-primary mt-auto disabled">COMING SOON</a>
        </div>
      </div>
    </div>
  </div>
</div>
