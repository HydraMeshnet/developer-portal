# API

Our API consists of two main parts.

- Write SSI/DNS states via [layer-1](glossary.md?id=Layer-1) transactions.
- Read SSI/DNS states via [layer-2](glossary.md?id=Layer-2) APIs.

Please visit our [get started page](get_started) to get a full overview of IOP's stack.

## Which API Do I Need?

<div class="row">
  <div class="col-sm-6">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <div class="row no-gutters">
          <div class="col-12 mt-2">
            <h4 class="card-title">Layer-1 API</h4>
            <h6 class="card-subtitle text-muted">Write State</h6>
          </div>
        </div>
        <div class="card-text mt-3">
          Use it to do SSI or DNS <strong>write</strong> operations, such as
          <ul>
            <li>Add/revoke a key to/from a DID</li>
            <li>Add/revoke a right to/from a DID</li>
            <li>Tombstone a DID</li>
            <li>Register a Proof of Existence</li>
            <li>Name your data (i.e. register DNS domain)</li>
            <li>Etc.</li>
          </ul>
        </div>
        <div class="mt-auto">
          <a href="/api/layer1_api" class="btn btn-outline-primary">BROWSE LAYER-1 API</a>
        </div>
      </div>
    </div>
  </div>
  <div class="col-sm-6">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <div class="row no-gutters">
          <div class="col-12 mt-2">
            <h4 class="card-title">Layer-2 API</h4>
            <h6 class="card-subtitle text-muted">Read State</h6>
          </div>
        </div>
        <div class="card-text mt-3">
          Use it to:
          <ul>
              <li>Query DID Document or its Transactions, Operations</li>
              <li>Query Proof of Existance or its History</li>
              <li>Query SSI Transaction Status</li>
              <li>Resolve data of a DNS domain</li>
              <li>Query metadata of a DNS domain</li>
              <li>Etc.</li>
          </ul>
        </div>
        <div class="mt-auto">
          <a href="/api/layer2_api" class="btn btn-outline-primary">BROWSE LAYER-2 API</a>
        </div>
      </div>
    </div>
  </div>
</div>

## SSI Entities' APIs

As explained in detail on the [Get Started page](/get_started), SSI has multiple entities defined for claim verification and issuance. IOP does not host these entities, but provides you a well-defined API described below and a [reference implementation in Typescript](https://github.com/Internet-of-People/morpheus-ts/tree/master/packages).

<div class="row">
  <div class="col-sm-6">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <div class="row no-gutters">
          <div class="col-12 mt-2">
            <h4 class="card-title">Authority API</h4>
            <h6 class="card-subtitle text-muted">Get a claim proved</h6>
          </div>
        </div>
        <div class="mt-3">
          <a href="/api/authority_api" class="btn btn-outline-primary">BROWSE AUTHORITY API</a>
        </div>
      </div>
    </div>
  </div>
  <div class="col-sm-6">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <div class="row no-gutters">
          <div class="col-12 mt-2">
            <h4 class="card-title">Inspector API</h4>
            <h6 class="card-subtitle text-muted">Present a proved claim</h6>
          </div>
        </div>
        <div class="mt-3">
          <a href="/api/inspector_api" class="btn btn-outline-primary">BROWSE INSPECTOR API</a>
        </div>
      </div>
    </div>
  </div>
  <div class="col-sm-6 mt-3">
    <div class="card h-100">
      <div class="card-body d-flex flex-column">
        <div class="row no-gutters">
          <div class="col-12 mt-2">
            <h4 class="card-title">Verifier API</h4>
            <h6 class="card-subtitle text-muted">Verify proved claims</h6>
          </div>
        </div>
        <div class="mt-3">
          <a href="/api/verifier_api" class="btn btn-outline-primary">BROWSE VERIFIER API</a>
        </div>
      </div>
    </div>
  </div>
</div>
