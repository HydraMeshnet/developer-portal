# IOP DNS (Project Coeus)

## What is IOP DNS?

Computers usually work with identifiers based on binary formats, from sequence numbers through network addresses to UUIDs. Though they are effective, they are also hard to read and memorize by humans. As a solution, humans often use a list of names or words that computers then map to numbers. For example, the [IANA](https://en.wikipedia.org/wiki/Internet_Assigned_Numbers_Authority) supervises the Domain Name System mapping from domain names to IP addresses.

We strive to create a naming system that is

- decentralized, i.e. fault-tolerant, unsupervised and anyone can join the network with their node
- open, i.e. anyone can register and maintain their set of names
- generic, i.e. it can name not only network addresses but anything from schemas and protocols through cryptocurrency accounts and DIDs to devices and rights

The IOP DNS service satisfies these goals. DNS's [layer-1](/api/layer1_api) and [layer-2](/api/layer2_api) API provides a service which can be used to register and resolve domain names with data attached. You can do other things with DNS, as described below.

### Architecture and Data Structure

Similar to legacy naming systems, the Decentralized Naming System supervises a [tree structure](https://en.wikipedia.org/wiki/Tree_%28data_structure%29). Each node is aware of its path and child nodes, but the tree has to be traversed to collect all farther ascendants or descendants. Note that each node can deduce the path of all parents from its own path.

#### Edges

The tree has named edges. Humans can remember edge names easily. The human-readable path of a node is referred to as the domain (name) and a child node as the subdomain.

Edge names must consist of lowercase letters and digits from the ASCII character set. Hyphen, dot, underscore, colon, space, and other characters are forbidden. The goal is to prevent confusion often experienced in other systems allowing different entries with names that look the same for humans but differ in their technical representation (e.g. different Unicode character set or encoding (NFC vs NFKD), cases (`name` vs `Name`), separators (`snake_case` vs `kebab-case` vs `camelCase` vs `space case`), etc.).

For easy conversion of arbitrary names to this character set, see the [AnyAscii library](https://github.com/anyascii/anyascii) and its [live demo](https://anyascii.com/) for experimentation.

The root node is hardly referenced in practice since it is a technical, blank node. `.domainname` refers to top-level domains where the leading dot separator marks an absolute path starting from the root. Subdomain paths are written as `.edge.names.along.the.path.to.node`.

#### Domain Node Data

All nodes of the tree contain node-related custom data. Node data must be a JSON value that conforms to a JSON schema stored together with the data as characterization of the node. 

IOP DNS implements a mapping from valid paths (i.e. domain names) to node records (i.e. the corresponding JSON value of the node). Thus the JSON value has to contain all technical details to use the result, e.g. a JSON schema for `.schema` nodes, a cryptocurrency address for `.wallet` nodes, an actual DID for `.did` nodes, etc. Authorization rules for updating the node or registering subdomains, registration prices, and other domain details are all kept separately as additional meta-information of nodes.

#### Domain Hierarchy

The root domain has an empty schema and an empty JSON object, but all children must contain a non-empty schema and data. The JSON schema of each node must conform to the schema of all of its ancestor nodes as well, i.e. each node inherits the schema of its parent node and can further restrict it into a subschema. Note that JSON schemas have `additionalProperties: true` by default. Therefore conformance checks accept any unspecified extra fields as valid. In other words, a subdomain can
- restrict an existing field by requiring a subtype of its previous type or a specific fixed value.
- require a completely new field.

The implementation efforts of such schema subtype validation are extremely high, thus iteratively checking data against all ancestor schemas of a node provides an easier approach.

##### Top Level Domains (TLD)

Top-level domains are predefined, reserved and hardwired into the source code. They have an immutable name, schema and data, but can be accessed and handled using the same interfaces as all other domains.

Top-level domains do not expire. Subdomains registered by clients always have an expiry date, implemented as a Hydra blockheight in initial versions.

In the initial release, the naming system supports only the top-level `.schema` domain that restricts that `.schema.path.to.name` must resolve to a JsonSchema string.
In later releases, more domains like `.did`, `.right(.system)`, `.publickey`, `.wallet`, `.device`, `.uuid`, etc. are planned.

### CRUD Operations

#### Create

The creator of a domain must explicitly specify authorization rules to update the domain or register subdomains. Customized rules allow flexible scenarios (e.g. authenticate as a public key to update a domain and pay a defined price to register subdomains). Custom subdomains can be registered by anyone on a first-come, first-served basis as long as the creator is authorized by the higher-level domain rules and pays the required fee.

Registering a complex node path like `.one.two.three.four` needs a separate registration operation for each new subdomain. These operations can be bundled into a single transaction (analog to chained directory creation with `mkdir -p` on Linux).

#### Read

While Hydra transactions can mutate domains, a separate API serves immutable read operations. See the [API description](/api) for more details.

#### Update

There are multiple kinds of update operations, each allowing an atomic update of a domain detail. System information like parent, name, schema, registered subdomains, etc. is immutable. To update these, use an explicit delete and then register the same domain structure with a different name, schema, etc. instead.

An `update` operation can change the JSON data associated with a node. It must still conform to the JSON schema of the node and all of its parents.

A `renew` operation can prolong the expiry date of a domain. The domain owner can renew expired domains for a grace period (currently a month) to prevent losing a domain accidentally. After the grace period, anyone can register these domains again according to the regular system rules.

A `transfer` operation updates the owner details necessary for further domain changes.  This allows a domain to be sold or to be donated to a new owner. The operation contains both the details of the new owner and an optional Hydra transaction paying the domain price (on top of Hydra transaction fees). If any of them atomically fails then the transfer does not go through.

#### Delete

Domains can be explicitly deleted before their original expiration. The deletion of a domain means that it expires earlier and without a grace period. Expired and deleted domains behave the same. Deleting a node with existing children detaches the whole subtree (i.e. recursively deletes all child nodes as well).

Resolving the state of a deleted domain will fail after the deletion. Ideally, queries for older snapshots of the domain record could resolve just as before and clients could query the full history of a domain if needed. This is a feature to be implemented in the future.

There is no possibility of tombstoning a domain permanently, e.g. burning a competitor's brand name in advance. A domain can always be registered again, replacing the latest expired or deleted entry.

## Develop on DNS

To try out DNS, you have to connect to a Hydra network. You can experiment on your local machine or using IOP's infrastructure.
Please follow the guide [how to run a local testnet node](/hydra#run-testnet-node) or read [how to access IOP's Hydra network](/hydra#hydra-networks).

### Samples

We provide a git repository with an example codebase that uses our SDK. It's more useful for demonstrational purposes.

<a href="https://github.com/Internet-of-People/ts-examples/tree/master/coeus" target="_blank" class="btn btn-sm btn-outline-primary">GO TO REPOSITORY</a>

## API

We provide you detailed API documentation where you can learn the difference between layer-1 and layer-2 features.

<a href="/api" class="btn btn-sm btn-outline-primary">BROWSE API DOCUMENTATION</a>