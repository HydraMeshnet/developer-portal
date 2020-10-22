<style>
  .sidebar {
    display:none;
  }

  .content {
    position: relative;
    top: initial;
    left: initial;
    right: initial;
    bottom: initial;
  }
</style>

<div class="jumbotron">
  <h1 class="display-3 text-center">Welcome to the IOP Developer Portal!</h1>
  <p class="lead">
    Take full control of your digital life! Internet of People (IOP) provides self-sovereign identity (SSI) allowing multiple independent private personas. You can create and witness claims about personas and also share only the requested parts of such claims for verification, letting you securely manage every aspect of your life.
  </p>
  <p>
    IOP's technology is open source and available for anyone. Although IOP is dedicated to providing a complete solution to the problems of online identity and privacy, IOP is fully modular without vendor lock-in: users and businesses are free to use and combine any part of the stack they want.
  </p>
  <div class="text-center mb-5 mt-4">
    <a href="/#/get_started" id="get-started-btn" class="btn btn-lg btn-primary">GET STARTED</a>
  </div>
  <div class="row">
    <div class="col-sm-6">
      <div class="card h-100">
        <div class="card-body d-flex flex-column">
          <div class="row no-gutters">
            <div class="col-2">
              <img src="/assets/hydra_logo.png" class="iop-logo mt-2">
            </div>
            <div class="col-10 mt-2 pl-3">
              <h4 class="card-title">IOP Hydra Blockchain</h4>
              <h6 class="card-subtitle text-muted">Project Hydra</h6>
            </div>
          </div>
          <p class="card-text">dPoS blockchain extended with a layer-2 consensus to provide a public ledger for the IOP SSI. It can be deployed in minutes with Docker.</p>
          <div class="mt-auto">
            <a href="/#/hydra" class="btn btn-sm btn-outline-primary w-50">INSTALL</a>
            <img src="/assets/docker_square_logo.png" class="tech-logo ml-2" title="Docker">
            <img src="/assets/ts_square_logo.png" class="tech-logo ml-3" title="Typescript">
          </div>
        </div>
      </div>
    </div>
    <div class="col-sm-6">
      <div class="card h-100">
        <div class="card-body d-flex flex-column">
          <div class="row no-gutters">
            <div class="col-2">
              <img src="/assets/morpheus_logo.png" class="iop-logo mt-2">
            </div>
            <div class="col-10 mt-2 pl-3">
              <h4 class="card-title">IOP SSI</h4>
              <h6 class="card-subtitle text-muted">Project Morpheus</h6>
            </div>
          </div>
          <p class="card-text">Decentralized Access Control framework based on <a href="https://w3c.github.io/did-core">W3C standards</a> to provide SSI solutions, store schemas, decentralized IDs (DIDs), keys, rights and proof timestamps on a ledger for public verification, keeping verifiable claims (VCs) off-ledger.</p>
          <div class="d-inline-flex">
            <a href="/#/sdk/ssi" class="btn btn-sm btn-outline-primary mr-2 w-25">SDK</a>
            <a href="/#/api/api" class="btn btn-sm btn-outline-primary w-25">API</a>
            <img src="/assets/flutter_square_logo.png" class="tech-logo ml-2" title="Flutter">
            <img src="/assets/ts_square_logo.png" class="tech-logo ml-3" title="Typescript">
          </div>
        </div>
      </div>
    </div>
  </div>
</div>