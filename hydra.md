# Hydra Blockchain

Hydra is a dPos blockchain, extended with IoP DAC, a layer-2 decentralized consensus, an access control framework.
DAC provides a [W3C compliant](https://w3c.github.io/did-core/) toolset to store and handle decentralized IDs (DIDs), rights and schemas on chain.

## Install & Run

Here we describe how can you start your Hydra node connecting to any of our networks. You have two ways to start a Hydra node.

- Using [Docker](https://www.docker.com/) and [Docker Compose](https://docs.docker.com/compose/)
- Using [core-control](https://github.com/Internet-of-People/core-control)

### Run Testnet Node

Testnets consist of only server, hence you cannot connect to a testnet network. You can use [IoP's testnet](#Testnet) for testing or you can start your own described below.

1. Clone out [Hydra Core](https://github.com/Internet-of-People/hydra-core). Alternatively you can download only the [testnet directory](https://github.com/Internet-of-People/hydra-core/tree/hydra-2.6.10/docker/production/testnet) with the Docker files.
1. Go to the testnet directory:

   ```bash
   $ cd docker/production/testnet
   ```

1. Unpack the basic configuration:

   ```bash
   $ tar -xvf mountpoints.tar.gz
   ```

1. Start Hydra Core:

   ```bash
   $ NETWORK=testnet MODE=genesis FORGING_MODE=auto_forge docker-compose up -d core
   ```

  This will fire up your node and a database for it.

1. Confirm that containers are up:

   ```plain
   ...
   Creating postgres-hydra ... done
   Creating hydra-core     ... done
   ...
   ```

1. Confirm node is running and DAC API is ready and processing blocks:

   ```bash
   $ tail -f mountpoints/logs/testnet/hydra-core-current.log
   ...
   [2020-03-04 09:35:51.607] INFO : MORPHEUS HTTP API READY.
   ...
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS Task blockApplied: Morpheus block-handler 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41 started.
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS onBlockApplied contains 0 transactions..
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS applyEmptyBlockToState height: 3 id: 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41
   ...
   ```

### Run Devnet Node

To participate in IoP's devnet network, your job is easy. You either use Docker or core-control it takes up minutes to install and start a relay or forger node.

<div class="alert alert-info">
  Note, that syncing up with the devnet may take up to hours depending on your server's performance.
</div>

#### Via Docker

1. Clone out [Hydra Core](https://github.com/Internet-of-People/hydra-core). Alternatively you can download only the [devnet directory](https://github.com/Internet-of-People/hydra-core/tree/hydra-2.6.10/docker/production/devnet) with the Docker files.
1. Go to the network's directory:

   ```bash
   $ cd docker/production/devnet
   ```

1. Unpack the basic configuration:

   ```bash
   $ tar -xvf mountpoints.tar.gz
   ```

1. If you'd like to start a forger, put your delegate's mnemonics into `mountpoints/config_overwrite/delegates.json`.
1. Start Hydra Core. This will fire up your node and a database for it:

   - As a relay node

     ```bash
     $ NETWORK=devnet MODE=normal FORGING_MODE=no_forge docker-compose up -d core
     ```

   - As a forger node

     ```bash
     $ NETWORK=devnet MODE=normal FORGING_MODE=auto_forge docker-compose up -d core
     ```

1. Confirm that containers are up:

   ```plain
   ...
   Creating postgres-hydra ... done
   Creating hydra-core     ... done
   ...
   ```

1. Confirm node is running and DAC API is ready and processing blocks:

   ```bash
   $ tail -f mountpoints/logs/devnet/hydra-core-current.log
   ...
   [2020-03-04 09:35:51.607] INFO : MORPHEUS HTTP API READY.
   ...
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS Task blockApplied: Morpheus block-handler 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41 started.
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS onBlockApplied contains 0 transactions..
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS applyEmptyBlockToState height: 3 id: 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41
   ...
   ```

#### Via Core Control

Please follow the detailed guide in the [core-control's repository](https://github.com/Internet-of-People/core-control).

### Run Mainnet Node

To participate in IoP's mainnet network, your job is easy. You either use Docker or core-control it takes up minutes to install and start a relay or forger node.

<div class="alert alert-info">
  Note, that syncing up with the mainnet may take up to hours depending on your server's performance.
</div>

#### Via Docker

1. Clone out [Hydra Core](https://github.com/Internet-of-People/hydra-core). Alternatively you can download only the [mainnet directory](https://github.com/Internet-of-People/hydra-core/tree/hydra-2.6.10/docker/production/mainnet) with the Docker files.
1. Go to the network's directory:

   ```bash
   $ cd docker/production/mainnet
   ```

1. Unpack the basic configuration:

   ```bash
   $ tar -xvf mountpoints.tar.gz
   ```

1. If you'd like to start a forger, put your delegate's mnemonics into `mountpoints/config_overwrite/delegates.json`.
1. Start Hydra Core. This will fire up your node and a database for it:

   - As a relay node

     ```bash
     $ NETWORK=mainnet MODE=normal FORGING_MODE=no_forge docker-compose up -d core
     ```

   - As a forger node

     ```bash
     $ NETWORK=mainnet MODE=normal FORGING_MODE=auto_forge docker-compose up -d core
     ```

1. Confirm that containers are up:

   ```plain
   ...
   Creating postgres-hydra ... done
   Creating hydra-core     ... done
   ...
   ```

1. Confirm node is running and DAC API is ready and processing blocks:

   ```bash
   $ tail -f mountpoints/logs/mainnet/hydra-core-current.log
   ...
   [2020-03-04 09:35:51.607] INFO : MORPHEUS HTTP API READY.
   ...
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS Task blockApplied: Morpheus block-handler 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41 started.
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS onBlockApplied contains 0 transactions..
   [2020-03-04 09:49:14.208] DEBUG: MORPHEUS applyEmptyBlockToState height: 3 id: 52ce276adc139531c472e3ee8938209ee27d90eb4dca1851915de4af0f7dba41
   ...
   ```

#### Via Core Control

Please follow the detailed guide in the [core-control's repository](https://github.com/Internet-of-People/core-control).

## Hydra Networks

The [Hydra blockchain](https://github.com/Internet-of-People/hydra-core) has three networks available.

### Testnet

Browser: [http://test.hydra.iop.global](http://test.hydra.iop.global)

- The network we run usually locally when we are testing changes and we don't expect to involve a wider audience.
- Although it was intended for local use or testing, we have a running testnet in the cloud where we try to integrate things first to avoid devnet outages. Hence it's available for everyone.
- This network has play-around coins and transactions.
- Has 1 server up and running by IOP Ventures and to simplify communication we do not plan to invite 3rd parties to run extra nodes as part of this network. We don't guarantee its always up or consistent. It can be wiped any time without notice.

| name | zone | IP |
|---|---|---|
| testnet-genesis | europe-west1-b | 35.187.56.222 |

Any 3rd party developers can start their own local testnet for integration testing. Read more about in the [beginning of this page](#Run-Testnet-Node).

### Devnet

Browser: [http://dev.hydra.iop.global](http://dev.hydra.iop.global)

- The network where testing occurs before being deployed on the mainnet.
- This network is available for everyone and is used by developers for testing their applications and security experts to do responsible disclosures.
- Has play-around coins and transactions.
- Currently we have no faucet. [Contact us](https://iop.global/contact-us/) for getting DHYDs.
- Has 5 servers up and running 24/7 by IOP Ventures, but there are delegates who are testing their forging tools on their own devnet servers.

| name | zone | IP |
|---|---|---|
| devnet-genesis | europe-west1-b | 35.240.62.119 |
| devnet-forger-1 | europe-west4-a | 35.204.124.143 |
| devnet-forger-2 | us-central1-a | 34.68.118.161 |
| devnet-forger-3 | europe-north1-a | 35.228.196.114 |
| devnet-forger-4 | asia-southeast1-b | 34.87.3.205 |
| devnet-forger-5 | us-east1-b | 35.185.32.241 |

### Mainnet

Browser: [http://hydra.iop.global](http://hydra.iop.global)

- The network we run in production, and it is the backbone of Hydra. This is usually known as the Public Network since this network is utilized by end users.
- This network is available for everyone.
- Has real coins, real transactions.
- Has 21 servers up and running 24/7 by IOP Ventures, and each forging delegate is running their own servers

| name | zone | IP |
|---|---|---|
| mainnet-genesis | europe-west1-b | 35.195.150.223 |
| mainnet-seed-1 | europe-west1-b | 34.76.165.50 |
| mainnet-seed-2 | europe-west1-d | 104.155.17.122 |
| mainnet-seed-3 | europe-north1-a | 35.228.202.124 |
| mainnet-seed-4 | europe-north1-b | 35.228.73.165 |
| mainnet-seed-5 | europe-west3-c | 35.198.174.42 |
| mainnet-seed-6 | europe-west3-a | 35.246.135.62 |
| mainnet-seed-7 | europe-west4-a | 34.90.0.113 |
| mainnet-seed-8 | europe-west4-b | 34.90.43.152 |
| mainnet-seed-9 | us-central1-a | 34.66.138.96 |
| mainnet-seed-10 | us-central1-c | 104.154.142.55 |
| mainnet-seed-11 | us-east1-b | 34.74.102.192 |
| mainnet-seed-12 | us-east1-c | 35.231.24.181 |
| mainnet-seed-13 | us-west1-b | 35.233.159.123 |
| mainnet-seed-14 | us-west1-c | 35.230.119.77 |
| mainnet-seed-15 | us-west2-a | 35.235.109.207 |
| mainnet-seed-16 | us-west2-b | 34.94.151.12 |
| mainnet-seed-17 | northamerica-northeast1-a | 35.203.123.223 |
| mainnet-seed-18 | asia-southeast1-b | 35.240.251.207 |
| mainnet-seed-19 | asia-northeast1-b | 35.190.233.247 |
| mainnet-seed-20 | asia-south1-c | 34.93.248.166 |
