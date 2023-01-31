# IOP Hydra

Hydra is a dPoS blockchain extended with a layer-2 consensus to provide a public ledger for the IOP SSI (Self-Sovereign Identity) and IOP DNS (Domain Naming System) frameworks.
Hydra is built utilizing the modular architecture of [Ark](https://ark.io/).

IOP SSI is based on <a href="https://w3c.github.io/did-core">W3C standards</a> to store schemas, decentralized IDs (DIDs), keys, rights and proof timestamps on a ledger for public verification, keeping verifiable claims (VCs) off-ledger.

## Hydra Networks

The [Hydra blockchain](https://github.com/Internet-of-People/hydra-core) has three networks available.

### Testnet

Browser: [https://test.explorer.hydraledger.io/](https://test.explorer.hydraledger.io/)

- The network we run locally when we test changes and we don't expect to involve a wider audience.
- Although it was intended for local use or testing, we have a running testnet in the cloud where we try to integrate things first to avoid devnet outages. Hence it's available for everyone.
- This network has play-around tokens and transactions.
- Has 1 server up and running by IOP Ventures and to simplify communication we do not plan to invite 3rd parties to run extra nodes as part of this network. We don't guarantee its always up or consistent. It can be wiped any time without notice.

| name            | zone           | IP            |
| --------------- | -------------- | ------------- |
| testnet-genesis | europe-west1-b | 35.187.56.222 |

Any 3rd party developers can start their own local testnet for integration testing. Read more about [running a testnet node](#Run-Testnet-Node).

### Devnet

Browser: [https://dev.explorer.hydraledger.io/](https://dev.explorer.hydraledger.io/)

- The network where testing occurs before being deployed on the mainnet.
- The network is available for everyone and is used by developers for testing their applications and by security experts for responsible disclosures.
- The network has play-around tokens and transactions.
- Currently, we have no faucet. [Contact us](https://iop.global/contact-us/) for getting DHYDs.
- Has 5 servers up and running 24/7 by IOP Ventures, but there are delegates who are testing their forging tools on their own devnet servers.

| name            | zone              | IP             |
| --------------- | ----------------- | -------------- |
| devnet-genesis  | europe-west1-b    | 35.240.62.119  |
| devnet-forger-1 | europe-west4-a    | 35.204.124.143 |
| devnet-forger-2 | us-central1-a     | 34.68.118.161  |
| devnet-forger-3 | europe-north1-a   | 35.228.196.114 |
| devnet-forger-4 | asia-southeast1-b | 34.87.3.205    |

### Mainnet

Browser: [https://explorer.hydraledger.io/](https://explorer.hydraledger.io/)

- The backbone of Hydra and the network we run in production. This is usually known as the Public Network since this network is utilized by end-users.
- This network is available for everyone.
- It has real transactions with real tokens.
- It has 4 servers up and running 24/7 by IOP Ventures, and each forging delegate is running their own servers

| name                | zone                          | IP                 |
| ------------------- | ----------------------------- | ------------------ |
| mainnet-genesis     | europe-west1-b                | 35.195.150.223     |
| mainnet-seed-1      | europe-west1-b                | 34.76.165.50       |
| mainnet-seed-12     | us-east1-c                    | 35.231.24.181      |
| mainnet-seed-20     | asia-south1-c                 | 34.93.248.166      |

## Install & Run

You can start a Hydra node in the following two ways:

- Using [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)
- Using [core-control](https://github.com/Internet-of-People/core-control)

To prevent surprises and reduce required efforts debugging your software environment and deployment state,
  we strongly recommend using Docker, since its containers make operating a node
  much safer, more deterministic, and maintainable than with core-control.
  
Unless you have experience with Docker, we recommend following these steps:

- Install Docker and the Docker-compose image builder.
  For example, Ubuntu/Debian-based Linux OS only need  `sudo apt install docker.io docker-compose`
- Make sure that your user has proper access rights, i.e. is in group `docker`.
  On Linux systems, check `/etc/group` and search for line `docker`.
  If your user is not there, add it using e.g. `sudo usermod -a -G docker your_username`

### Run Testnet Node via Docker

**Requirements: [Docker](https://docs.docker.com/) knowledge.**

The `testnet` consists of only a single - usually local - server without a real network to connect to. (The closest concept is called `regtest` in BTC). You can use [IOP's testnet server](#Testnet) for testing or you can start your own server as described below.

Testnet currently works out of the box only with Docker. Core-control integration should also be possible (e.g. by adding some testnet-related configuration files to core-control) but not supported.

1. If you have no Postgresql running, start one: 
   ```bash
   $ docker run -it --rm --name postgres-hydra -e POSTGRES_DB=hydra_testnet -e POSTGRES_USER=hydra -e POSTGRES_PASSWORD=password postgres:11-alpine
   ```
   **Note:** you may need to change the Docker's parameters depending on your needs.
1. Create a `hydra-core` directory.
1. Create a `hydra-core/config` directory.
1. Create a file with the following content (**change what you need to change**) at `hydra-core/config/testnet.env`:
   ```
   CORE_ENV=test
   CORE_LOG_LEVEL=info
   CORE_LOG_LEVEL_FILE=info

   CORE_DB_HOST=postgres-hydra
   CORE_DB_PORT=5432

   CORE_P2P_HOST=0.0.0.0
   CORE_P2P_PORT=4700

   CORE_WEBHOOKS_HOST=0.0.0.0
   CORE_WEBHOOKS_PORT=4704

   CORE_EXCHANGE_JSON_RPC_HOST=0.0.0.0
   CORE_EXCHANGE_JSON_RPC_PORT=8080

   CORE_API_HOST=0.0.0.0
   CORE_API_PORT=4703

   CORE_WALLET_API_HOST=0.0.0.0
   CORE_WALLET_API_PORT=4040

   CORE_API_RATE_LIMIT=true
   CORE_API_RATE_LIMIT_USER_LIMIT=1000
   ```
1. Start forger under `hydra-core` directory:
   ```bash
   $ docker run --link postgres-hydra -it -p 4700:4700 -p 4703:4703 -p 4040:4040 --name core --rm --mount type=bind,src=${PWD}/config,dst=/root/config_overwrite internetofpeople/hydra-core:latest-testnet testnet normal auto_forge
   ```
1. Confirm that your node is running and SSI API is ready:
   ```bash
   Configs need to be generated...
   ✔ Prepare directories
   ✔ Publish environment
   ✔ Publish configuration
   Config overwrite provided, copying to its final place...
   Configs generated.
   Starting in normal mode with auto forging...
   [2022-03-23 14:08:40.542] INFO : Starting P2P Interface
   [2022-03-23 14:08:41.140] INFO : Socket worker started, PID: 92
   [2022-03-23 14:08:41.144] INFO : Socket worker started, PID: 91
   [2022-03-23 14:08:41.180] INFO : Setting up core-magistrate-transactions.
   [2022-03-23 14:08:41.407] INFO : HYDRA Starting up Hydra Plugin....
   [2022-03-23 14:08:41.408] INFO : HYDRA Creating Morpheus handlers....
   [2022-03-23 14:08:41.409] INFO : HYDRA Initializing Components.
   [2022-03-23 14:08:41.409] INFO : HYDRA Version: 5.0.2.
   [2022-03-23 14:08:41.410] INFO : HYDRA Initializing.
   [2022-03-23 14:08:41.410] INFO : HYDRA Starting up Ark Connector.
   [2022-03-23 14:08:41.410] INFO : HYDRA Has been started.
   [2022-03-23 14:08:41.411] INFO : HYDRA Registering MorpheusTransactionHandler.
   [2022-03-23 14:08:41.414] INFO : HYDRA Registering CoeusTransactionHandler.
   [2022-03-23 14:08:41.552] INFO : Starting Database Manager
   [2022-03-23 14:08:41.552] INFO : Establishing Database Connection
   [2022-03-23 14:08:41.725] WARN : Migrating transactions table to assets. This may take a while.
   [2022-03-23 14:08:42.009] WARN : No block found in database
   [2022-03-23 14:08:42.036] INFO : Connecting to transaction pool
   [2022-03-23 14:08:42.110] INFO : Starting Blockchain Manager :chains:
   [2022-03-23 14:08:42.112] INFO : Verifying database integrity
   [2022-03-23 14:08:42.119] INFO : Verified database integrity
   [2022-03-23 14:08:42.125] INFO : Last block in database: 1
   [2022-03-23 14:08:42.126] INFO : State Generation - Step 1 of 23: Block Rewards
   [2022-03-23 14:08:42.128] INFO : State Generation - Step 2 of 23: Fees & Nonces
   [2022-03-23 14:08:42.138] INFO : State Generation - Step 3 of 23: Transfer
   [2022-03-23 14:08:42.140] INFO : State Generation - Step 4 of 23: SecondSignature
   [2022-03-23 14:08:42.141] INFO : State Generation - Step 5 of 23: DelegateRegistration
   [2022-03-23 14:08:42.147] INFO : State Generation - Step 6 of 23: Vote
   [2022-03-23 14:08:42.155] INFO : State Generation - Step 7 of 23: MultiSignature
   [2022-03-23 14:08:42.157] INFO : State Generation - Step 8 of 23: Ipfs
   [2022-03-23 14:08:42.158] INFO : State Generation - Step 9 of 23: MultiPayment
   [2022-03-23 14:08:42.159] INFO : State Generation - Step 10 of 23: DelegateResignation
   [2022-03-23 14:08:42.160] INFO : State Generation - Step 11 of 23: HtlcLock
   [2022-03-23 14:08:42.161] INFO : State Generation - Step 12 of 23: HtlcClaim
   [2022-03-23 14:08:42.163] INFO : State Generation - Step 13 of 23: HtlcRefund
   [2022-03-23 14:08:42.164] INFO : State Generation - Step 14 of 23: BusinessRegistration
   [2022-03-23 14:08:42.165] INFO : State Generation - Step 15 of 23: BusinessResignation
   [2022-03-23 14:08:42.166] INFO : State Generation - Step 16 of 23: BusinessUpdate
   [2022-03-23 14:08:42.167] INFO : State Generation - Step 17 of 23: BridgechainRegistration
   [2022-03-23 14:08:42.168] INFO : State Generation - Step 18 of 23: BridgechainResignation
   [2022-03-23 14:08:42.169] INFO : State Generation - Step 19 of 23: BridgechainUpdate
   [2022-03-23 14:08:42.170] INFO : State Generation - Step 20 of 23: Entity
   [2022-03-23 14:08:42.171] INFO : State Generation - Step 21 of 23: MorpheusTransaction
   [2022-03-23 14:08:42.171] INFO : MORPHEUS Bootstrapping Morpheus plugin....
   [2022-03-23 14:08:42.173] INFO : State Generation - Step 22 of 23: CoeusTransaction
   [2022-03-23 14:08:42.173] INFO : COEUS Bootstrapping Coeus plugin....
   [2022-03-23 14:08:42.174] INFO : State Generation - Step 23 of 23: Vote Balances & Delegate Ranking
   [2022-03-23 14:08:42.177] INFO : State Generation complete! Wallets in memory: 55
   [2022-03-23 14:08:42.177] INFO : Number of registered delegates: 53
   [2022-03-23 14:08:42.189] INFO : Starting Round 1
   [2022-03-23 14:08:42.191] INFO : Saving round 1
   [2022-03-23 14:08:42.196] INFO : Transaction Pool Manager build wallets complete
   [2022-03-23 14:08:42.205] INFO : Your network connectivity has been verified by 208.67.222.222
   [2022-03-23 14:08:42.242] INFO : Your NTP connectivity has been verified by time.google.com
   [2022-03-23 14:08:42.242] INFO : Local clock is off by 5ms from NTP
   [2022-03-23 14:08:42.244] INFO : Checking 0 peers
   [2022-03-23 14:08:42.244] INFO : 0 of 0 peers on the network are responsive
   [2022-03-23 14:08:42.244] INFO : Median Network Height: 0
   [2022-03-23 14:08:42.245] INFO : Couldnt find enough peers. Falling back to seed peers.
   [2022-03-23 14:08:44.113] INFO : Checking 0 peers
   [2022-03-23 14:08:44.367] INFO : Public HTTP API Server running at: http://0.0.0.0:4703
   [2022-03-23 14:08:44.367] INFO : Wallet API Server running at: http://0.0.0.0:4040
   [2022-03-23 14:08:44.372] INFO : MORPHEUS Morpheus HTTP API READY.
   [2022-03-23 14:08:44.394] INFO : Webhooks are disabled
   [2022-03-23 14:08:44.394] INFO : COEUS Coeus HTTP API READY.
   [2022-03-23 14:08:44.550] INFO : Loaded 53 active delegates: ...
   [2022-03-23 14:08:44.552] INFO : Forger Manager started.
   ```

### Run Devnet Node

The `devnet` is a network of many forgers and relay nodes for experimentation. (The closest concept is called `testnet` in BTC).
To participate in IOP's devnet network, you can use either Docker or core-control. It takes only minutes to install and start a relay or forger node.

<div class="alert alert-info">
  A full state synchronization may take hours depending on your server's performance.
</div>

#### Run Devnet Node Using Docker

**Requirements: [Docker](https://docs.docker.com/) knowledge.**

1. If you have no Postgresql running, start one: 
   ```bash
   $ docker run -it --rm --name postgres-hydra -e POSTGRES_DB=hydra_devnet -e POSTGRES_USER=hydra -e POSTGRES_PASSWORD=password postgres:11-alpine
   ```
   **Note:** you may need to change the Docker's parameters depending on your needs.
1. Create a `hydra-core` directory.
1. Create a `hydra-core/config` directory.
1. Create a file with the following content (**change what you need to change**) at `hydra-core/config/devnet.env`:
   ```
   CORE_LOG_LEVEL=info
   CORE_LOG_LEVEL_FILE=info

   CORE_DB_HOST=postgres-hydra
   CORE_DB_PORT=5432

   CORE_P2P_HOST=0.0.0.0
   CORE_P2P_PORT=4702

   CORE_WEBHOOKS_HOST=0.0.0.0
   CORE_WEBHOOKS_PORT=4704

   CORE_EXCHANGE_JSON_RPC_HOST=0.0.0.0
   CORE_EXCHANGE_JSON_RPC_PORT=8080

   CORE_API_HOST=0.0.0.0
   CORE_API_PORT=4703

   CORE_WALLET_API_HOST=0.0.0.0
   CORE_WALLET_API_PORT=4040

   CORE_API_RATE_LIMIT=true
   CORE_API_RATE_LIMIT_USER_LIMIT=1000
   ```
1. Create a file with your delegates' phrases at `hydra-core/config/delegates.json`:
   ```json
   { "secrets": [COMMA_SEPARATED_DELEGATES_PHRASE_LIST] }
   ```
   Example:
   ```json
   {"secrets": [
      "setup impose tone same animal endless useless item syrup much client clerk", // delegate 1
      "clump stadium guide add treat fury enough celery credit prize hybrid eyebrow" // delegate 2
   ]}
   ```
1. Start forger under `hydra-core` directory:
   ```bash
   $ docker run --link postgres-hydra -it -p 4702:4702 -p 4703:4703 -p 4040:4040 --name core --rm --mount type=bind,src=${PWD}/config,dst=/root/config_overwrite internetofpeople/hydra-core:latest-devnet devnet normal auto_forge
   ```
1. Confirm that your node is started syncronizing:
   ```bash
   Configs need to be generated...
   ✔ Prepare directories
   ✔ Publish environment
   ✔ Publish configuration
   Config overwrite provided, copying to its final place...
   Configs generated.
   Starting in normal mode with auto forging...
   [2022-03-23 14:18:19.074] INFO : Starting P2P Interface
   [2022-03-23 14:18:19.671] INFO : Socket worker started, PID: 91
   [2022-03-23 14:18:19.678] INFO : Socket worker started, PID: 92
   [2022-03-23 14:18:19.712] INFO : Setting up core-magistrate-transactions.
   [2022-03-23 14:18:19.918] INFO : HYDRA Starting up Hydra Plugin....
   [2022-03-23 14:18:19.918] INFO : HYDRA Creating Morpheus handlers....
   [2022-03-23 14:18:19.920] INFO : HYDRA Initializing Components.
   [2022-03-23 14:18:19.921] INFO : HYDRA Version: 5.0.2.
   [2022-03-23 14:18:19.922] INFO : HYDRA Initializing.
   [2022-03-23 14:18:19.922] INFO : HYDRA Starting up Ark Connector.
   [2022-03-23 14:18:19.923] INFO : HYDRA Has been started.
   [2022-03-23 14:18:19.925] INFO : HYDRA Registering MorpheusTransactionHandler.
   [2022-03-23 14:18:19.931] INFO : HYDRA Registering CoeusTransactionHandler.
   [2022-03-23 14:18:20.054] INFO : Starting Database Manager
   [2022-03-23 14:18:20.055] INFO : Establishing Database Connection
   [2022-03-23 14:18:20.246] WARN : Migrating transactions table to assets. This may take a while.
   [2022-03-23 14:18:20.587] WARN : No block found in database
   [2022-03-23 14:18:20.624] INFO : Connecting to transaction pool
   [2022-03-23 14:18:20.681] INFO : Starting Blockchain Manager :chains:
   [2022-03-23 14:18:20.683] INFO : Verifying database integrity
   [2022-03-23 14:18:20.687] INFO : Verified database integrity
   [2022-03-23 14:18:20.689] INFO : Last block in database: 1
   [2022-03-23 14:18:20.689] INFO : State Generation - Step 1 of 23: Block Rewards
   [2022-03-23 14:18:20.691] INFO : State Generation - Step 2 of 23: Fees & Nonces
   [2022-03-23 14:18:20.694] INFO : State Generation - Step 3 of 23: Transfer
   [2022-03-23 14:18:20.696] INFO : State Generation - Step 4 of 23: SecondSignature
   [2022-03-23 14:18:20.697] INFO : State Generation - Step 5 of 23: DelegateRegistration
   [2022-03-23 14:18:20.702] INFO : State Generation - Step 6 of 23: Vote
   [2022-03-23 14:18:20.704] INFO : State Generation - Step 7 of 23: MultiSignature
   [2022-03-23 14:18:20.705] INFO : State Generation - Step 8 of 23: Ipfs
   [2022-03-23 14:18:20.706] INFO : State Generation - Step 9 of 23: MultiPayment
   [2022-03-23 14:18:20.707] INFO : State Generation - Step 10 of 23: DelegateResignation
   [2022-03-23 14:18:20.708] INFO : State Generation - Step 11 of 23: HtlcLock
   [2022-03-23 14:18:20.709] INFO : State Generation - Step 12 of 23: HtlcClaim
   [2022-03-23 14:18:20.710] INFO : State Generation - Step 13 of 23: HtlcRefund
   [2022-03-23 14:18:20.712] INFO : State Generation - Step 14 of 23: BusinessRegistration
   [2022-03-23 14:18:20.713] INFO : State Generation - Step 15 of 23: BusinessResignation
   [2022-03-23 14:18:20.714] INFO : State Generation - Step 16 of 23: BusinessUpdate
   [2022-03-23 14:18:20.714] INFO : State Generation - Step 17 of 23: BridgechainRegistration
   [2022-03-23 14:18:20.715] INFO : State Generation - Step 18 of 23: BridgechainResignation
   [2022-03-23 14:18:20.716] INFO : State Generation - Step 19 of 23: BridgechainUpdate
   [2022-03-23 14:18:20.717] INFO : State Generation - Step 20 of 23: Entity
   [2022-03-23 14:18:20.718] INFO : State Generation - Step 21 of 23: MorpheusTransaction
   [2022-03-23 14:18:20.719] INFO : MORPHEUS Bootstrapping Morpheus plugin....
   [2022-03-23 14:18:20.720] INFO : State Generation - Step 22 of 23: CoeusTransaction
   [2022-03-23 14:18:20.720] INFO : COEUS Bootstrapping Coeus plugin....
   [2022-03-23 14:18:20.721] INFO : State Generation - Step 23 of 23: Vote Balances & Delegate Ranking
   [2022-03-23 14:18:20.723] INFO : State Generation complete! Wallets in memory: 55
   [2022-03-23 14:18:20.724] INFO : Number of registered delegates: 53
   [2022-03-23 14:18:20.736] INFO : Starting Round 1
   [2022-03-23 14:18:20.739] INFO : Saving round 1
   [2022-03-23 14:18:20.744] INFO : Transaction Pool Manager build wallets complete
   [2022-03-23 14:18:20.753] INFO : Your network connectivity has been verified by 8.8.4.4
   [2022-03-23 14:18:20.767] INFO : Your NTP connectivity has been verified by pool.ntp.org
   [2022-03-23 14:18:20.768] INFO : Local clock is off by 4ms from NTP
   [2022-03-23 14:18:23.226] INFO : Checking 6 peers
   [2022-03-23 14:18:23.231] INFO : 6 of 6 peers on the network are responsive
   [2022-03-23 14:18:23.232] INFO : Median Network Height: 5,895,814
   [2022-03-23 14:18:23.233] INFO : Discovered 6 peers with v2.7.24.
   [2022-03-23 14:18:27.835] INFO : Downloaded 2400 new blocks accounting for a total of 35 transactions
   [2022-03-23 14:18:27.902] INFO : Starting Round 2
   [2022-03-23 14:18:27.908] INFO : Saving round 2
   [2022-03-23 14:18:28.003] INFO : Skipping broadcast of block 102 as blockchain is not ready
   [2022-03-23 14:18:28.005] INFO : Starting Round 3
   [2022-03-23 14:18:28.008] INFO : Saving round 3
   [2022-03-23 14:18:28.041] INFO : Starting Round 4
   [2022-03-23 14:18:28.045] INFO : Saving round 4
   ...
   ```
1. Your node soon will be up, when the sync is finished.

#### Via core-control

Please follow the detailed guide in the [core-control's repository](https://github.com/Internet-of-People/core-control).

#### Security Considerations

The following ports are the only ports that need to be open to ensure the correct working of your node:

- Ingress Traffic:
   tcp:4702, tcp:4703, tcp: 4705, tcp:4040
- Egress Traffic:
   tcp:4702

Leaving unused ports open is a security risk, therefor we strongly advice to check whether unused ports are closed.

### Run Mainnet Node

To participate in IOP's mainnet network, you can use either Docker or core-control. It takes only minutes to install and start a relay or forger node.

<div class="alert alert-info">
  A full state synchronization may take hours depending on your server's performance.
</div>

#### Run Mainnet Node Using Docker

**Requirements: [Docker](https://docs.docker.com/) knowledge.**

1. If you have no Postgresql running, start one: 
   ```bash
   $ docker run -it --rm --name postgres-hydra -e POSTGRES_DB=hydra_mainnet -e POSTGRES_USER=hydra -e POSTGRES_PASSWORD=password postgres:11-alpine
   ```
   **Note:** you may need to change the Docker's parameters depending on your needs.
1. Create a `hydra-core` directory.
1. Create a `hydra-core/config` directory.
1. Create a file with the following content (**change what you need to change**) at `hydra-core/config/mainnet.env`:
   ```
   CORE_LOG_LEVEL=info
   CORE_LOG_LEVEL_FILE=info

   CORE_DB_HOST=postgres-hydra
   CORE_DB_PORT=5432

   CORE_P2P_HOST=0.0.0.0
   CORE_P2P_PORT=4701

   CORE_WEBHOOKS_HOST=0.0.0.0
   CORE_WEBHOOKS_PORT=4704

   CORE_EXCHANGE_JSON_RPC_HOST=0.0.0.0
   CORE_EXCHANGE_JSON_RPC_PORT=8080

   CORE_API_HOST=0.0.0.0
   CORE_API_PORT=4703

   CORE_WALLET_API_HOST=0.0.0.0
   CORE_WALLET_API_PORT=4040

   CORE_API_RATE_LIMIT=true
   CORE_API_RATE_LIMIT_USER_LIMIT=1000
   ```
1. Create a file with your delegates' phrases at `hydra-core/config/delegates.json`:
   ```json
   { "secrets": [COMMA_SEPARATED_DELEGATES_PHRASE_LIST] }
   ```
   Example:
   ```json
   {"secrets": [
      "setup impose tone same animal endless useless item syrup much client clerk", // delegate 1
      "clump stadium guide add treat fury enough celery credit prize hybrid eyebrow" // delegate 2
   ]}
   ```
1. Start forger under `hydra-core` directory:
   ```bash
   $ docker run --link postgres-hydra -it -p 4701:4701 -p 4703:4703 -p 4040:4040 --name core --rm --mount type=bind,src=${PWD}/config,dst=/root/config_overwrite internetofpeople/hydra-core:latest-mainnet mainnet normal auto_forge
   ```
1. Confirm that your node is started syncronizing:
   ```bash
   Configs need to be generated...
   ✔ Prepare directories
   ✔ Publish environment
   ✔ Publish configuration
   Config overwrite provided, copying to its final place...
   Configs generated.
   Starting in normal mode with auto forging...
   [2022-03-23 14:18:19.074] INFO : Starting P2P Interface
   [2022-03-23 14:18:19.671] INFO : Socket worker started, PID: 91
   [2022-03-23 14:18:19.678] INFO : Socket worker started, PID: 92
   [2022-03-23 14:18:19.712] INFO : Setting up core-magistrate-transactions.
   [2022-03-23 14:18:19.918] INFO : HYDRA Starting up Hydra Plugin....
   [2022-03-23 14:18:19.918] INFO : HYDRA Creating Morpheus handlers....
   [2022-03-23 14:18:19.920] INFO : HYDRA Initializing Components.
   [2022-03-23 14:18:19.921] INFO : HYDRA Version: 5.0.2.
   [2022-03-23 14:18:19.922] INFO : HYDRA Initializing.
   [2022-03-23 14:18:19.922] INFO : HYDRA Starting up Ark Connector.
   [2022-03-23 14:18:19.923] INFO : HYDRA Has been started.
   [2022-03-23 14:18:19.925] INFO : HYDRA Registering MorpheusTransactionHandler.
   [2022-03-23 14:18:19.931] INFO : HYDRA Registering CoeusTransactionHandler.
   [2022-03-23 14:18:20.054] INFO : Starting Database Manager
   [2022-03-23 14:18:20.055] INFO : Establishing Database Connection
   [2022-03-23 14:18:20.246] WARN : Migrating transactions table to assets. This may take a while.
   [2022-03-23 14:18:20.587] WARN : No block found in database
   [2022-03-23 14:18:20.624] INFO : Connecting to transaction pool
   [2022-03-23 14:18:20.681] INFO : Starting Blockchain Manager :chains:
   [2022-03-23 14:18:20.683] INFO : Verifying database integrity
   [2022-03-23 14:18:20.687] INFO : Verified database integrity
   [2022-03-23 14:18:20.689] INFO : Last block in database: 1
   [2022-03-23 14:18:20.689] INFO : State Generation - Step 1 of 23: Block Rewards
   [2022-03-23 14:18:20.691] INFO : State Generation - Step 2 of 23: Fees & Nonces
   [2022-03-23 14:18:20.694] INFO : State Generation - Step 3 of 23: Transfer
   [2022-03-23 14:18:20.696] INFO : State Generation - Step 4 of 23: SecondSignature
   [2022-03-23 14:18:20.697] INFO : State Generation - Step 5 of 23: DelegateRegistration
   [2022-03-23 14:18:20.702] INFO : State Generation - Step 6 of 23: Vote
   [2022-03-23 14:18:20.704] INFO : State Generation - Step 7 of 23: MultiSignature
   [2022-03-23 14:18:20.705] INFO : State Generation - Step 8 of 23: Ipfs
   [2022-03-23 14:18:20.706] INFO : State Generation - Step 9 of 23: MultiPayment
   [2022-03-23 14:18:20.707] INFO : State Generation - Step 10 of 23: DelegateResignation
   [2022-03-23 14:18:20.708] INFO : State Generation - Step 11 of 23: HtlcLock
   [2022-03-23 14:18:20.709] INFO : State Generation - Step 12 of 23: HtlcClaim
   [2022-03-23 14:18:20.710] INFO : State Generation - Step 13 of 23: HtlcRefund
   [2022-03-23 14:18:20.712] INFO : State Generation - Step 14 of 23: BusinessRegistration
   [2022-03-23 14:18:20.713] INFO : State Generation - Step 15 of 23: BusinessResignation
   [2022-03-23 14:18:20.714] INFO : State Generation - Step 16 of 23: BusinessUpdate
   [2022-03-23 14:18:20.714] INFO : State Generation - Step 17 of 23: BridgechainRegistration
   [2022-03-23 14:18:20.715] INFO : State Generation - Step 18 of 23: BridgechainResignation
   [2022-03-23 14:18:20.716] INFO : State Generation - Step 19 of 23: BridgechainUpdate
   [2022-03-23 14:18:20.717] INFO : State Generation - Step 20 of 23: Entity
   [2022-03-23 14:18:20.718] INFO : State Generation - Step 21 of 23: MorpheusTransaction
   [2022-03-23 14:18:20.719] INFO : MORPHEUS Bootstrapping Morpheus plugin....
   [2022-03-23 14:18:20.720] INFO : State Generation - Step 22 of 23: CoeusTransaction
   [2022-03-23 14:18:20.720] INFO : COEUS Bootstrapping Coeus plugin....
   [2022-03-23 14:18:20.721] INFO : State Generation - Step 23 of 23: Vote Balances & Delegate Ranking
   [2022-03-23 14:18:20.723] INFO : State Generation complete! Wallets in memory: 55
   [2022-03-23 14:18:20.724] INFO : Number of registered delegates: 53
   [2022-03-23 14:18:20.736] INFO : Starting Round 1
   [2022-03-23 14:18:20.739] INFO : Saving round 1
   [2022-03-23 14:18:20.744] INFO : Transaction Pool Manager build wallets complete
   [2022-03-23 14:18:20.753] INFO : Your network connectivity has been verified by 8.8.4.4
   [2022-03-23 14:18:20.767] INFO : Your NTP connectivity has been verified by pool.ntp.org
   [2022-03-23 14:18:20.768] INFO : Local clock is off by 4ms from NTP
   [2022-03-23 14:18:23.226] INFO : Checking 6 peers
   [2022-03-23 14:18:23.231] INFO : 6 of 6 peers on the network are responsive
   [2022-03-23 14:18:23.232] INFO : Median Network Height: 5,895,814
   [2022-03-23 14:18:23.233] INFO : Discovered 6 peers with v2.7.24.
   [2022-03-23 14:18:27.835] INFO : Downloaded 2400 new blocks accounting for a total of 35 transactions
   [2022-03-23 14:18:27.902] INFO : Starting Round 2
   [2022-03-23 14:18:27.908] INFO : Saving round 2
   [2022-03-23 14:18:28.003] INFO : Skipping broadcast of block 102 as blockchain is not ready
   [2022-03-23 14:18:28.005] INFO : Starting Round 3
   [2022-03-23 14:18:28.008] INFO : Saving round 3
   [2022-03-23 14:18:28.041] INFO : Starting Round 4
   [2022-03-23 14:18:28.045] INFO : Saving round 4
   ...
   ```
1. Your node soon will be up, when the sync is finished.

#### Via Core Control

Please follow the detailed guide in the [core-control's repository](https://github.com/Internet-of-People/core-control).

#### Security Considerations

The following ports are the only ports that need to be open to ensure the correct working of your node:

- Ingress Traffic:
tcp:4701, tcp:4703, tcp: 4705, tcp:4040
- Egress Traffic:
   tcp:4701

Leaving unused ports open is a security risk, therefor we strongly advice to check whether unused ports are closed.
