# Hydra API

This API exposes all resources and data provided by a Hydra node; and is the preferred way of interacting with the Hydra network.
Note that each node has its own internal blockchain and state, meaning it may have forked or be out of sync, causing queries to fail.

## Endpoints

### Blockchain

Retrieve the latest block and supply of the blockchain.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/blockchain
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data": {
    "block": {
      "height":3890840,
      "id":"1d4c2beb40087842f20feb39e23292311269dff16018df5ecf94fd3f2ac0e1cd"
    },
    "supply":"36451392000000000"
  }
}
```
</details>

### Blocks

Blocks are added every eight seconds to the blockchain by a Delegate Node. Due to network/technical errors, a Delegate might miss a block. The time between two blocks is then 16 seconds, as the round continues to the next Delegate.

All state changes to the blockchain are in the form of blocks; they contain a set of transactions and metadata. A block is rejected if one or more of the transactions is invalid; or if the metadata is invalid. Thus a block returned from the Hydra API is always valid.

#### List All Blocks

The Hydra API may be used to query for blocks. This dataset contains millions of blocks; thus for analytical purposes, we recommend you use the Elasticsearch plugin or query the database directly.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/blocks?page=1&limit=100
```

##### Parameters

| Name | Type | Description
|---|---|---
| page | int | The number of the page that will be returned.
| limit | int | The number of resources per page.
| id | string | The identifier of the block to be retrieved.
| height | int | The height of the block to be retrieved.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta": {
    "totalCountIsEstimate":true,
    "count":100,
    "pageCount":38910,
    "totalCount":3890949,
    "next":"/blocks?page=2&limit=100&transform=true",
    "previous":null,
    "self":"/blocks?page=1&limit=100&transform=true",
    "first":"/blocks?page=1&limit=100&transform=true",
    "last":"/blocks?page=38910&limit=100&transform=true"
  },
  "data": [
    {
      "id":"759c24c777a005eec7bb8b816ce121adfed92888d6fd370504f718171256badb",
      "version":0,
      "height":3891007,
      "previous":"803e4f9a1b54f7fe1e6679df281ef50fe688ed56d3d85d96065472568c95ac8c",
      "forged":{
        "reward":"800000000",
        "fee":"0",
        "total":"800000000",
        "amount":"0"
      },
      "payload":{
        "hash":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
        "length":0
      },
      "generator":{
        "username":"lambomambo",
        "address":"hTAb4QbZMq9AMoH1YBu9CymdrvQqqg5ZmX","publicKey":"032ab8c7d2960e680e124a08b562bb561d8c663402dbf965c97350574da9e4cfd1"
      },"signature":"3044022072a6c716af547f40978ecf3cea90858a5996678fee73921e0ea3686bcafb6a6902205e4e2b0bb6a73c95ce0703f24ef43ef4afc0e113385496bba2a99f96b51a3e3a",
      "confirmations":0,
      "transactions":0,
      "timestamp":{
        "epoch":47543940,
        "unix":1614868740,
        "human":"2021-03-04T14:39:00.000Z"
      }
    }
  ]
}
```

</details>

#### Retrieve a block

Blocks may be retrieved by ID or by height. The height is an incremental integer.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/blocks/{id|height}
```

##### Parameters

| Name | Type | Description
|---|---|---
| id | string | The identifier of the block to be retrieved.
| height | int | The height of the block to be retrieved.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data": {
    "id":"759c24c777a005eec7bb8b816ce121adfed92888d6fd370504f718171256badb",
    "version":0,
    "height":3891007,
    "previous":"803e4f9a1b54f7fe1e6679df281ef50fe688ed56d3d85d96065472568c95ac8c",
    "forged":{
      "reward":"800000000",
      "fee":"0",
      "total":"800000000",
      "amount":"0"
    },
    "payload":{
      "hash":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
      "length":0
    },
    "generator":{
      "username":"lambomambo",
      "address":"hTAb4QbZMq9AMoH1YBu9CymdrvQqqg5ZmX","publicKey":"032ab8c7d2960e680e124a08b562bb561d8c663402dbf965c97350574da9e4cfd1"
    },"signature":"3044022072a6c716af547f40978ecf3cea90858a5996678fee73921e0ea3686bcafb6a6902205e4e2b0bb6a73c95ce0703f24ef43ef4afc0e113385496bba2a99f96b51a3e3a",
    "confirmations":0,
    "transactions":0,
    "timestamp":{
      "epoch":47543940,
      "unix":1614868740,
      "human":"2021-03-04T14:39:00.000Z"
    }
  }
}
```
</details>

#### List All Transactions in a Block

Instead of deserializing the block’s payload; you can also obtain the transactions of each block as proper transaction objects directly.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/blocks/{id|height}/transactions?page=1&limit=100
```

##### Parameters

| Name | Type | Description
|---|---|---|
| id | string | The identifier of the block to be retrieved.
| height | int | The height of the block to be retrieved.
| page | int | The number of the page that will be returned.
| limit	| int | The number of resources per page.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta": {
    "totalCountIsEstimate":false,
    "count":54,
    "pageCount":1,
    "totalCount":54,
    "next":null,
    "previous":null,
    "self":"/blocks/1/transactions?page=1&limit=100&transform=true",
    "first":"/blocks/1/transactions?page=1&limit=100&transform=true",
    "last":"/blocks/1/transactions?page=1&limit=100&transform=true"
  },
  "data":[
    {
      "id":"e825e9073c27f1960fae16fbddad4060b9ac47e59c685fc13a3623d785930b71","blockId":"87ba5e9f060fdaa39ebfd7ac0fb826800cd8044de683598adfcd9d65a25f2f72",
      "version":1,
      "type":0,
      "typeGroup":1,
      "amount":"33500000000000000",
      "fee":"0",
      "sender":"hK4vrDjGWhjDd32YGe3X7Fm16WdMPkxULM","senderPublicKey":"038ee4c20d6f7a746591f8c4b9ca32b78bcd49be7701c4283c4ba2bca27a6759e1","recipient":"hHdggKwR1Eaj9dUv4shKKYnxrgKLcqtkyd","signature":"3045022100cd67de885b49d6c7f9290addbf9149dd6074266f894463d009f2d7f0b744bad402204087aaba5c937104e56b908653d83302cce30d7301be8abe9af92289b5e074ea",
      "confirmations":3891076,
      "timestamp":{
        "epoch":0,
        "unix":1567324800,
        "human":"2019-09-01T08:00:00.000Z"
      },
      "nonce":"1"
    },
  ]
}
```
</details>

### Node

The node resource is useful for service discovery, health checks, and obtaining network configurations, such as fees, API, and token information.

#### Retrieve the configuration
Used to access a node’s configuration and the network it is attached to (identified by the ```nethash```).

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/node/configuration
```

##### Response
<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "core":{
      "version":"2.7.24"
    },
    "nethash":"802b6c0522a4b4005751f10ee507018dd8e1bcb6d81ef1e123899e0d2f5538db",
    "slip44":4741444,
    "wif":111,
    "token":"HYD",
    "symbol":"Ħ",
    "explorer":"https://hydra.iop.global",
    "version":100,
    "ports":{
      "@arkecosystem/core-p2p":null,
      "@arkecosystem/core-api":4705
    },
    "constants":{
      "height":3295500,
      "reward":800000000,
      "activeDelegates":53,
      "blocktime":12,
      "block":{
        "version":0,
        "maxTransactions":250,
        "maxPayload":8388608,
        "idFullSha256":true
      },
      "epoch":"2019-09-01T08:00:00.000Z",
      "fees":{
        "staticFees":{
          "transfer":10000000,
          "secondSignature":500000000,
          "delegateRegistration":2500000000,
          "vote":100000000,
          "multiSignature":500000000,
          "ipfs":500000000,
          "multiPayment":10000000,
          "delegateResignation":2500000000,
          "htlcLock":10000000,
          "htlcClaim":0,
          "htlcRefund":0
        }
      },
      "vendorFieldLength":255,
      "aip11":true,
      "htlcEnabled":true,
      "p2p":{
        "minimumVersions":["^2.6 || ^2.6.0-next.9"]
      },
      "morpheus":true,
      "coeus":true
    },
    "transactionPool":{
      "dynamicFees":{
        "enabled":true,
        "minFeePool":3000,
        "minFeeBroadcast":3000,
        "addonBytes":{
          "transfer":100,
          "secondSignature":250,
          "delegateRegistration":
          400000,
          "vote":100,
          "multiSignature":500,
          "ipfs":250,
          "multiPayment":500,
          "delegateResignation":100,
          "htlcLock":100,
          "htlcClaim":0,
          "htlcRefund":0,
          "businessRegistration":4000000,
          "businessUpdate":500,
          "businessResignation":100,
          "bridgechainRegistration":4000000,
          "bridgechainUpdate":500,
          "bridgechainResignation":100
        }
      }
    }
  }
}
```
</details>

#### Retrieve the Cryptography Configuration
Used to access a node’s configuration for the ```@arkecosystem/crypto``` package that handles all cryptography operations.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/node/configuration/crypto
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "exceptions":{
      "blocks":[],
      "blocksTransactions":{},
      "transactions":[],
      "outlookTable":{},
      "transactionIdFixTable":{},
      "wrongTransactionOrder":{},
      "negativeBalances":{}
    },
    "genesisBlock":{
      "version":0,
      "totalAmount":"33500000000000000",
      "totalFee":"0",
      "reward":"0",
      "payloadHash":"802b6c0522a4b4005751f10ee507018dd8e1bcb6d81ef1e123899e0d2f5538db","timestamp":0,"numberOfTransactions":54,
      "payloadLength":11831,
      "previousBlock":"0000000000000000000000000000000000000000000000000000000000000000",
      "generatorPublicKey":"03dde7ecd0a17c8f88dac8996b11496afe502c98eda4e693f0b73462b3059661de",
      "transactions":[{
        "id":"e825e9073c27f1960fae16fbddad4060b9ac47e59c685fc13a3623d785930b71",
        "timestamp":0,
        "version":1,
        "type":0,
        "fee":"0",
        "amount":"33500000000000000",
        "recipientId":"hHdggKwR1Eaj9dUv4shKKYnxrgKLcqtkyd",
        "senderPublicKey":"038ee4c20d6f7a746591f8c4b9ca32b78bcd49be7701c4283c4ba2bca27a6759e1",
        "expiration":0,
        "network":100,"signature":"3045022100cd67de885b49d6c7f9290addbf9149dd6074266f894463d009f2d7f0b744bad402204087aaba5c937104e56b908653d83302cce30d7301be8abe9af92289b5e074ea",
        "senderId":"hK4vrDjGWhjDd32YGe3X7Fm16WdMPkxULM",
        "typeGroup":1
      }],
      "height":1,
      "id":"70e142ff709de37b322a87de9d28d0ca5f17172e81509dca6070bc57c303f8ed",
      "blockSignature":"3045022100bca7825b18e5fa56d3ea79203a6108a411b1f56fbe8eb8611f5441573af838200220710408ee7d0e34f8375b4593f8a4ed5598f9e96909c598c0226113e5782bb154"
    },
    "milestones":[{
      "height":1,
      "reward":0,
      "activeDelegates":53,
      "blocktime":12,
      "block":{
        "version":0,
        "maxTransactions":250,
        "maxPayload":8388608,
        "idFullSha256":true
      },
      "epoch":"2019-09-01T08:00:00.000Z",
      "fees":{
        "staticFees":{
          "transfer":10000000,
          "secondSignature":500000000,
          "delegateRegistration":2500000000,
          "vote":100000000,
          "multiSignature":500000000,
          "ipfs":500000000,
          "multiPayment":10000000,
          "delegateResignation":2500000000,
          "htlcLock":10000000,
          "htlcClaim":0,
          "htlcRefund":0
          }
        },
        "vendorFieldLength":255
      }],
      "network":{
        "name":"mainnet",
        "messagePrefix":"HYD message:\n",
        "bip32":{
          "public":3238353751,
          "private":1307004399
        },
        "pubKeyHash":100,
        "nethash":"802b6c0522a4b4005751f10ee507018dd8e1bcb6d81ef1e123899e0d2f5538db",
        "wif":111,
        "slip44":4741444,
        "aip20":4741444,
        "client":{
          "token":"HYD",
          "symbol":"Ħ",
          "explorer":"https://hydra.iop.global"
        }
      }
    }
  }
} 
         
```
</details>

#### Retrieve Retrieve the Fee Statistics
Used to access a node’s fee statistics.
##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/node/fees?days=1
```

##### Parameters

| Name | Type | Description 
|---|---|---
| days | int | The number of days which will be regarded.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "days":1
  },
  "data":{
    "1":{
      "transfer":{
        "avg":"1089228",
        "max":"1140000",
        "min":"1026000",
        "sum":"515205000"
      },
      "vote":{
        "avg":"100000000",
        "max":"100000000",
        "min":"100000000",
        "sum":"100000000"
      },
      "multiPayment":{
        "avg":"10000000",
        "max":"10000000",
        "min":"10000000",
        "sum":"80000000"
      }
    },
    "2":{
      "entityRegistration":{
        "avg":"5000000000",
        "max":"5000000000",
        "min":"5000000000",
        "sum":"0"
      },
      "entityResignation":{
        "avg":"500000000",
        "max":"500000000",
        "min":"500000000",
        "sum":"0"
      },
      "entityUpdate":{
        "avg":"500000000",
        "max":"500000000",
        "min":"500000000",
        "sum":"0"
      }
    }
  }
}        
```
</details>

#### Retrieve the status
The status allows for health checking, showing if the node is in sync with the network.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/node/status
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "exceptions":{
      "blocks":[],
      "blocksTransactions":{},
      "transactions":[],
      "outlookTable":{},
      "transactionIdFixTable":{},
      "wrongTransactionOrder":{},
      "negativeBalances":{}
    },
    "genesisBlock":{
      "version":0,
      "totalAmount":"33500000000000000",
      "totalFee":"0",
      "reward":"0",
      "payloadHash":"802b6c0522a4b4005751f10ee507018dd8e1bcb6d81ef1e123899e0d2f5538db","timestamp":0,"numberOfTransactions":54,
      "payloadLength":11831,
      "previousBlock":"0000000000000000000000000000000000000000000000000000000000000000",
      "generatorPublicKey":"03dde7ecd0a17c8f88dac8996b11496afe502c98eda4e693f0b73462b3059661de",
      "transactions":[{
        "id":"e825e9073c27f1960fae16fbddad4060b9ac47e59c685fc13a3623d785930b71",
        "timestamp":0,
        "version":1,
        "type":0,
        "fee":"0",
        "amount":"33500000000000000",
        "recipientId":"hHdggKwR1Eaj9dUv4shKKYnxrgKLcqtkyd",
        "senderPublicKey":"038ee4c20d6f7a746591f8c4b9ca32b78bcd49be7701c4283c4ba2bca27a6759e1",
        "expiration":0,
        "network":100,"signature":"3045022100cd67de885b49d6c7f9290addbf9149dd6074266f894463d009f2d7f0b744bad402204087aaba5c937104e56b908653d83302cce30d7301be8abe9af92289b5e074ea",
        "senderId":"hK4vrDjGWhjDd32YGe3X7Fm16WdMPkxULM",
        "typeGroup":1
      }],
      "height":1,
      "id":"70e142ff709de37b322a87de9d28d0ca5f17172e81509dca6070bc57c303f8ed",
      "blockSignature":"3045022100bca7825b18e5fa56d3ea79203a6108a411b1f56fbe8eb8611f5441573af838200220710408ee7d0e34f8375b4593f8a4ed5598f9e96909c598c0226113e5782bb154"
    },
    "milestones":[{
      "height":1,
      "reward":0,
      "activeDelegates":53,
      "blocktime":12,
      "block":{
        "version":0,
        "maxTransactions":250,
        "maxPayload":8388608,
        "idFullSha256":true
      },
      "epoch":"2019-09-01T08:00:00.000Z",
      "fees":{
        "staticFees":{
          "transfer":10000000,
          "secondSignature":500000000,
          "delegateRegistration":2500000000,
          "vote":100000000,
          "multiSignature":500000000,
          "ipfs":500000000,
          "multiPayment":10000000,
          "delegateResignation":2500000000,
          "htlcLock":10000000,
          "htlcClaim":0,
          "htlcRefund":0
          }
        },
        "vendorFieldLength":255
      }],
      "network":{
        "name":"mainnet",
        "messagePrefix":"HYD message:\n",
        "bip32":{
          "public":3238353751,
          "private":1307004399
        },
        "pubKeyHash":100,
        "nethash":"802b6c0522a4b4005751f10ee507018dd8e1bcb6d81ef1e123899e0d2f5538db",
        "wif":111,
        "slip44":4741444,
        "aip20":4741444,
        "client":{
          "token":"HYD",
          "symbol":"Ħ",
          "explorer":"https://hydra.iop.global"
        }
      }
    }
  }
} 
         
```
</details>

#### Retrieve the Syncing Status
The syncing resource is very much alike node/status, providing information on the syncing progress. If a node is not syncing but significantly behind in blocks, it might be time to perform a check.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/node/syncing
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "syncing":false,
    "blocks":-1,
    "height":3891402,
    "id":"23de14f4285aa500e9cda177672fbc007dfce945d340f6d64650e9bb36934150"
  }
}   
```
</details>

### Peers

The peers resource is much like the node resource, but only exposes the IPs and ports of connected peers. Recursively traversing this API and its responses allow you to inspect the entire network.

#### List All Peers
Returns all peers known by the node. These are not necessarily all peers; only public nodes appear here.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/peers?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| page | The number of the page that will be returned. 
| limit	| The number of resources per page.
| orderBy	| The column by which the resources will be sorted.
| port | The port by which the resources will be filtered.
| status | The status by which the resources will be filtered.
| os | The operating system by which the resources will be filtered.
| version	| The node version by which the resources will be filtered.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "count":47,
    "pageCount":1,
    "totalCount":47,
    "next":null,
    "previous":null,
    "self":"/peers?page=1&limit=100",
    "first":"/peers?page=1&limit=100",
    "last":"/peers?page=1&limit=100"},
    "data":[{
      "ip":"104.155.17.122",
      "port":4701,
      "ports":{
        "@arkecosystem/core-api":4705,
        "@arkecosystem/core-wallet-api":4040,
        "@arkecosystem/core-webhooks":-1,
        "@arkecosystem/core-exchange-json-rpc":-1
      },
      "version":"2.7.24",
      "height":3891432,
      "latency":5
    }]
  }
}   
```
</details>

#### Retrieve a Peer
Specific peers can be found by IP address. Note that a peer may have their Hydra API disabled, and thus they are only reachable by the internal p2p API.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/peers/{ip}
```

##### Parameters

| Name | Description 
|---|---
| ip | The IP address of the peer to be retrieved.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "ip":"104.155.17.122",
    "port":4701,
    "ports":{
      "@arkecosystem/core-api":4705,
      "@arkecosystem/core-wallet-api":4040,
      "@arkecosystem/core-webhooks":-1,
      "@arkecosystem/core-exchange-json-rpc":-1
    },
    "version":"2.7.24",
    "height":3891455,
    "latency":27
  }
}   
```
</details>


### Transactions
Transactions are signed, serialized payloads; batched together to form a block.

#### List All Transactions

The paginated API is used to query for multiple transactions. You can apply filters through the query parameter to search for specific transactions.


##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/transactions?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| page | The number of the page that will be returned. 
| limit	| The number of resources per page.
| orderBy	| The column by which the resources will be sorted.
| type | The transaction type to be retrieved.
| blockId	| The block id to be retrieved.
| id | The transaction id to be retrieved.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "totalCountIsEstimate":true,
    "count":1,
    "pageCount":348070,
    "totalCount":348070,
    "next":"/transactions?page=2&limit=1&transform=true",
    "previous":null,
    "self":"/transactions?page=1&limit=1&transform=true",
    "first":"/transactions?page=1&limit=1&transform=true",
    "last":"/transactions?page=348070&limit=1&transform=true"
  },
  "data":[{
    "id":"d8cebc91b3337e6b8eb596a6f34f994d710cc2e9133ecb355829892be9d7b34d",
    "blockId":"ace26d0572eab1dd07b9fd857d29a2acfccc4b394462bf50493b3773de850c4b",
    "version":2,
    "type":0,
    "typeGroup":1,
    "amount":"1476441236",
    "fee":"1116000",
    "sender":"hLuKo3jK6aN4pVaheMazRmdHJns9No6QAP",
    "senderPublicKey":"035b72888405bbadf23107ba0914b4340d4a0dcf958107dd2831b64ee187a37fa9",
    "recipient":"hHSnn7c9ECJPcxurb7WGQ5Jj1E28y8wk45",
    "signature":"e2d9dcab63e4c947613149c924bead4135c4caab792c761bac8b9d7e72b8d1a20fbe30ee9862664e644680ea05be88242af566b6542f79b3bb733a5016a9e93d",
    "vendorField":"Delegate germanyambassador at your service",
    "confirmations":54,
    "timestamp":{
      "epoch":47548980,
      "unix":1614873780,
      "human":"2021-03-04T16:03:00.000Z"
    },
    "nonce":"35650"
  }]
}
```
</details>


#### Retrieve a Transaction

Obtaining a transaction by ID does not require advanced logic; as the API does not return a serialized transaction, but a nicer DTO.


##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/transactions/{id}
```

##### Parameters

| Name | Description 
|---|---
| id | The transaction id to be retrieved.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "id":"d8cebc91b3337e6b8eb596a6f34f994d710cc2e9133ecb355829892be9d7b34d",
    "blockId":"ace26d0572eab1dd07b9fd857d29a2acfccc4b394462bf50493b3773de850c4b",
    "version":2,
    "type":0,
    "typeGroup":1,
    "amount":"1476441236",
    "fee":"1116000",
    "sender":"hLuKo3jK6aN4pVaheMazRmdHJns9No6QAP",
    "senderPublicKey":"035b72888405bbadf23107ba0914b4340d4a0dcf958107dd2831b64ee187a37fa9",
    "recipient":"hHSnn7c9ECJPcxurb7WGQ5Jj1E28y8wk45",
    "signature":"e2d9dcab63e4c947613149c924bead4135c4caab792c761bac8b9d7e72b8d1a20fbe30ee9862664e644680ea05be88242af566b6542f79b3bb733a5016a9e93d",
    "vendorField":"Delegate germanyambassador at your service",
    "confirmations":54,
    "timestamp":{
      "epoch":47548980,
      "unix":1614873780,
      "human":"2021-03-04T16:03:00.000Z"
    },
    "nonce":"35650"
    }
}
```
</details>



#### List All Unconfirmed Transaction
Unconfirmed transactions have not been incorporated in the blockchain, but reside in the mempool. Although usually the mempool is cleared within minutes, during high network load a transaction with a low fee will live here for a considerable time. If you have set the transaction with a fee of near zero, it might not be picked up by a Delegate and will time out.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/transactions/unconfirmed?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| page | The number of the page that will be returned. 
| limit	| The number of resources per page.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "count":0,
    "pageCount":1,
    "totalCount":0,
    "next":null,
    "previous":null,
    "self":"/transactions/unconfirmed?page=1&limit=1&transform=true",
    "first":"/transactions/unconfirmed?page=1&limit=1&transform=true",
    "last":null
  },
  "data":[{
    "id":"03bae9691100d21484f39495bc211898bc0349c6f1285e17e248da3d9313352e",
    "version":2,
    "type":0,
    "typeGroup":1,
    "amount":"500000000",
    "fee":"10000000",
    "sender":"tmaw6nAhMGMEGyKBNPKZdtyBBxh9K5qw1S",
    "senderPublicKey":"0220cfdc38eed153a404c08888fbfed3c655569d3abccde9ef0d33d50c97e43818",
    "recipient":"tZu864hSusKUSryF2Sx7CDWSZPKxqAf1V7",
    "signature":"30440220253783ca39558e347e6861ce5c2f4c865c033489dc773089502f1e404fa853ec0220776d0d00811a5a09544c6f9b62b9cc816df111fc31be4d6cb143b67dbb821c6a",
    "confirmations":0,
    "nonce":"1"
  }]
}
```
</details>

#### Get an Unconfirmed Transaction
As with confirmed transactions, you may query for unconfirmed transactions directly.


##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/transactions/unconfirmed/{id}
```

##### Parameters

| Name  | Description 
|---|---
| id | The transaction id to be retrieved.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "id":"03bae9691100d21484f39495bc211898bc0349c6f1285e17e248da3d9313352e",
    "version":2,
    "type":0,
    "typeGroup":1,
    "amount":"500000000",
    "fee":"10000000",
    "sender":"tmaw6nAhMGMEGyKBNPKZdtyBBxh9K5qw1S",
    "senderPublicKey":"0220cfdc38eed153a404c08888fbfed3c655569d3abccde9ef0d33d50c97e43818",
    "recipient":"tZu864hSusKUSryF2Sx7CDWSZPKxqAf1V7",
    "signature":"30440220253783ca39558e347e6861ce5c2f4c865c033489dc773089502f1e404fa853ec0220776d0d00811a5a09544c6f9b62b9cc816df111fc31be4d6cb143b67dbb821c6a",
    "confirmations":0,
    "nonce":"1"
  }
}
```
</details>

#### Broadcast Transactions
Creating the correct payload for a transaction is non-trivial, as it requires cryptographic functions and a specific serialization protocol. Our crypto SDKs provide the functionality needed in most major programming languages. You can read more about it in the send transaction section.

##### Endpoint

```https
POST  https://hydra.iop.global:4705/api/v2/transactions
```

##### Parameters

| Name | Description 
|---|---
| transactions | The list of transactions to broadcast.


#### Get Transaction Fees (Non-Dynamic)
The static transaction fees are significantly higher than the dynamic transaction fees. Use the node resource to find dynamic fees, and prefer using these.


##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/transactions/fees
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "1":{
      "transfer":"10000000",
      "secondSignature":"500000000",
      "delegateRegistration":"2500000000",
      "vote":"100000000",
      "multiSignature":"500000000",
      "ipfs":"500000000",
      "multiPayment":"10000000",
      "delegateResignation":"2500000000",
      "htlcLock":"10000000",
      "htlcClaim":"0",
      "htlcRefund":"0"
    },
    "2":{
      "entityRegistration":"5000000000",
      "entityResignation":"500000000",
      "entityUpdate":"500000000"
    },
    "4242":{
      "morpheusTransaction":"10000000",
      "coeusTransaction":"10000000"
    }
  }
}
```
</details>

#### Get Transaction Types
The transaction types are network specific. Hydra currently supports twelve different transaction types.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/transactions/types
```

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "1":{
      "Transfer":0,
      "SecondSignature":1,
      "DelegateRegistration":2,
      "Vote":3,
      "MultiSignature":4,
      "Ipfs":5,
      "MultiPayment":6,
      "DelegateResignation":7,
      "HtlcLock":8,
      "HtlcClaim":9,
      "HtlcRefund":10
    },
    "4242":{
      "MorpheusTransaction":1,
      "CoeusTransaction":2
    }
  }
}
```
</details>


### Wallets
Wallets are addresses containing, or previously having contained Hydra's. A wallet’s public key may be unknown to the network, in that case, it is referred to as a cold wallet.

#### List All Wallets
A paginated API is provided to obtain all wallets, including empty ones.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/wallets?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| page | The number of the page that will be returned.
| limit	| The number of resources per page.


##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "count":1,
    "pageCount":1354,
    "totalCount":1354,
    "next":"/wallets?page=2&limit=1",
    "previous":null,
    "self":"/wallets?page=1&limit=1",
    "first":"/wallets?page=1&limit=1",
    "last":"/wallets?page=1354&limit=1"
  },"data":[{
    "address":"hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa",
    "publicKey":"034cfc7033018afc464eff1b9c01680ecbf594a88208ba8ca9513381d74d44c33f",
    "nonce":"2",
    "balance":"11600080108300000",
    "attributes":{},
    "isDelegate":false,
    "isResigned":false
  }]
}
```
</details>

#### Retrieve a Wallet
Specific wallets can be obtained either by their publicKey or address.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/wallets/{id}
```

##### Parameters

| Name | Description 
|---|---
| id | The publicKey or address of the wallet to be retrieved.


##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "data":{
    "address":"hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa",
    "publicKey":"034cfc7033018afc464eff1b9c01680ecbf594a88208ba8ca9513381d74d44c33f",
    "nonce":"2",
    "balance":"11600080108300000",
    "attributes":{},
    "isDelegate":false,
    "isResigned":false
  }
}
```
</details>

#### List All Transactions of a Wallet
All transactions belonging to a wallet can be obtained using this API.
##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/wallets/{id}/transactions?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| id | The publicKey or address of the wallet to be retrieved.
| page | The number of the page that will be returned.
| limit	| The number of resources per page.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "totalCountIsEstimate":true,
    "count":1,
    "pageCount":292,
    "totalCount":292,
    "next":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=2&limit=1&transform=true",
    "previous":null,
    "self":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=1&limit=1&transform=true",
    "first":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=1&limit=1&transform=true",
    "last":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=292&limit=1&transform=true"
  },
  "data":[{
    "id":"416e2fbc7da908bf8906cfd250b33c26bb8ca997241f1606bf298ba60d2002f1",
    "blockId":"5bfa56c7b9d10f8025030c1036fda6059f9c514b7d1a1a9ffce84b6a68270a33",
    "version":1,
    "type":0,
    "typeGroup":1,
    "amount":"11600000000000000",
    "fee":"900000",
    "sender":"hHdggKwR1Eaj9dUv4shKKYnxrgKLcqtkyd",
    "senderPublicKey":"03dde7ecd0a17c8f88dac8996b11496afe502c98eda4e693f0b73462b3059661de",
    "recipient":"hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa",
    "signature":"3045022100d02b41b99cb75b09a78a35c725b4bf8bcfe761035c26f67a9701de398d031942022014b0aac1ccb56468391de39176543c4aff53342732782d2cd692c161633e5b2d",
    "confirmations":3553810,
    "timestamp":{
      "epoch":4330612,
      "unix":1571655412,
      "human":"2019-10-21T10:56:52.000Z"
    },
    "nonce":"8"
  }]
}
```
</details>

#### List All Sent Transactions of a Wallet
Outgoing transactions can be obtained for each wallet using this API.
##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/wallets/{id}/transactions/sent?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| id | The publicKey or address of the wallet to be retrieved.
| page | The number of the page that will be returned.
| limit	| The number of resources per page.


##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "totalCountIsEstimate":true,
    "count":1,
    "pageCount":292,
    "totalCount":292,
    "next":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=2&limit=1&transform=true",
    "previous":null,
    "self":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=1&limit=1&transform=true",
    "first":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=1&limit=1&transform=true",
    "last":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=292&limit=1&transform=true"
  },
  "data":[{
    "id":"416e2fbc7da908bf8906cfd250b33c26bb8ca997241f1606bf298ba60d2002f1",
    "blockId":"5bfa56c7b9d10f8025030c1036fda6059f9c514b7d1a1a9ffce84b6a68270a33",
    "version":1,
    "type":0,
    "typeGroup":1,
    "amount":"11600000000000000",
    "fee":"900000",
    "sender":"hHdggKwR1Eaj9dUv4shKKYnxrgKLcqtkyd",
    "senderPublicKey":"03dde7ecd0a17c8f88dac8996b11496afe502c98eda4e693f0b73462b3059661de",
    "recipient":"hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa",
    "signature":"3045022100d02b41b99cb75b09a78a35c725b4bf8bcfe761035c26f67a9701de398d031942022014b0aac1ccb56468391de39176543c4aff53342732782d2cd692c161633e5b2d",
    "confirmations":3553810,
    "timestamp":{
      "epoch":4330612,
      "unix":1571655412,
      "human":"2019-10-21T10:56:52.000Z"
    },
    "nonce":"8"
  }]
}
```
</details>

#### List All Received Transactions of a Wallet
Incoming transactions can be obtained as well, Equivalent to transactions/search with parameter recipientId set.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/wallets/{id}/transactions/received?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| id | The publicKey or address of the wallet to be retrieved.
| page | The number of the page that will be returned.
| limit	| The number of resources per page.


##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "totalCountIsEstimate":true,
    "count":1,
    "pageCount":292,
    "totalCount":292,
    "next":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=2&limit=1&transform=true",
    "previous":null,
    "self":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=1&limit=1&transform=true",
    "first":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=1&limit=1&transform=true",
    "last":"/wallets/hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa/transactions?page=292&limit=1&transform=true"
  },
  "data":[{
    "id":"416e2fbc7da908bf8906cfd250b33c26bb8ca997241f1606bf298ba60d2002f1",
    "blockId":"5bfa56c7b9d10f8025030c1036fda6059f9c514b7d1a1a9ffce84b6a68270a33",
    "version":1,
    "type":0,
    "typeGroup":1,
    "amount":"11600000000000000",
    "fee":"900000",
    "sender":"hHdggKwR1Eaj9dUv4shKKYnxrgKLcqtkyd",
    "senderPublicKey":"03dde7ecd0a17c8f88dac8996b11496afe502c98eda4e693f0b73462b3059661de",
    "recipient":"hYg5DX3dQrzGYUzMZgxeeaVUVcWpw2VEGa",
    "signature":"3045022100d02b41b99cb75b09a78a35c725b4bf8bcfe761035c26f67a9701de398d031942022014b0aac1ccb56468391de39176543c4aff53342732782d2cd692c161633e5b2d",
    "confirmations":3553810,
    "timestamp":{
      "epoch":4330612,
      "unix":1571655412,
      "human":"2019-10-21T10:56:52.000Z"
    },
    "nonce":"8"
  }]
}
```
</details>

#### List All Votes of a Wallet
Returns all votes made by the wallet.

##### Endpoint

```https
GET  https://hydra.iop.global:4705/api/v2/wallets/{id}/votes?page=1&limit=100
```

##### Parameters

| Name | Description 
|---|---
| id | The publicKey or address of the wallet to be retrieved.
| page | The number of the page that will be returned.
| limit	| The number of resources per page.

##### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "meta":{
    "totalCountIsEstimate":true,
    "count":1,
    "pageCount":1,
    "totalCount":1,
    "next":null,
    "previous":null,
    "self":"/wallets/hMcc5meoRGHspv6VMyUfWowLZcADHcLneZ/votes?page=1&limit=1&transform=true",
    "first":"/wallets/hMcc5meoRGHspv6VMyUfWowLZcADHcLneZ/votes?page=1&limit=1&transform=true",
    "last":"/wallets/hMcc5meoRGHspv6VMyUfWowLZcADHcLneZ/votes?page=1&limit=1&transform=true"
  },
  "data":[{
    "id":"3aab1da27b0b1da6c74d905b564d96c9006efaa7ccd367fc452e16f8e5095f43",
    "blockId":"15e3c4a793f8c6d330d492471ff91d8adaf83f84bc85bfba2ffa7d476baa7ae6",
    "version":2,
    "type":3,
    "typeGroup":1,
    "amount":"0",
    "fee":"100000000",
    "sender":"hMcc5meoRGHspv6VMyUfWowLZcADHcLneZ",
    "senderPublicKey":"02878233a6e9dc74b3f950b704575d2c5107fc4aa69ebdf50bc98c1be83024de35",
    "recipient":"hMcc5meoRGHspv6VMyUfWowLZcADHcLneZ",
    "signature":"3044022029a49c7a765d9f53dd5be199c3a98381c06a85c83e1052fe46cff99aa8ba9f6c0220693db53fc37221b048368688765f5d8d0d2118ba1d1436f88940f6ef13237e28",
    "asset":{
      "votes":["+032f06537399b982545863bfaf12d127dd1bf7a0b39a991822980779414bd902d2"]
    },
    "confirmations":241069,
    "timestamp":{
      "epoch":44286828,
      "unix":1611611628,
      "human":"2021-01-25T21:53:48.000Z"
    },
    "nonce":"3"
  }]
}
```
</details>

