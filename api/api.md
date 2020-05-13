# DAC API

DAC's API consists of two main parts. [Layer-1](glossary.md?id=Layer-1) and [layer-2](glossary.md?id=Layer-2). On layer-1 you do write operations that change the blockchain's state, while on layer-2 you do read operations without touching the state.

#### Why is it Separated?

DAC operates as a plugin inside the Hydra blockchain. Hence it shares the same consensus rules with the Hydra network for transactions. DAC transactions are stored in the same database, the same way as other Hydra transactions. This financial layer keeps track of balances of wallets and orders the transactions in the pool based on paid fees and wallet nonces.

A DAC transaction is simply a Hydra transaction containing customized data. Therefore DAC transactions are sent simply like other Hydra transactions using the Layer-1 API to modify the blockchain's state.

However, reading the ledger's extended DAC-related state can be done only separately on the Layer-2 API.

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
          Use it for:
          <ul>
              <li>Add a key to a DID</li>
              <li>Revoke a key from a DID</li>
              <li>Add a right to a DID</li>
              <li>Revoke a right from a DID</li>
              <li>Tombstone a DID</li>
              <li>Register a before proof</li>
              <li>Etc.</li>
          </ul>
        </div>
        <div class="mt-auto">
          <a href="/#/api/layer1_api" class="btn btn-primary">BROWSE LAYER-1 API</a>
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
          Use it for:
          <ul>
              <li>Query DID Document</li>
              <li>Query DID Document Transactions</li>
              <li>Query DID Document Operations</li>
              <li>Query Before Proof Existance</li>
              <li>Query Before Proof History</li>
              <li>Query DAC Transaction Status</li>
              <li>Etc.</li>
          </ul>
        </div>
        <div class="mt-auto">
          <a href="/#/api/layer2_api" class="btn btn-primary">BROWSE LAYER-2 API</a>
        </div>
      </div>
    </div>
  </div>
</div>