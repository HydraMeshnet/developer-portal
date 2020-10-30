# IOP DNS (Project Coeus)

## What is IOP DNS?

Computers usually work with identifiers based on binary formats, from sequence numbers through network addresses to UUIDs. Though they are effective, they are also hard to read and memorize by humans. As a solution, humans often use a list of names or words that computers then map to numbers. For example, the [IANA](https://en.wikipedia.org/wiki/Internet_Assigned_Numbers_Authority) supervises the Domain Name System mapping from domain names to IP addresses.

We strive to create a naming system that is

- decentralized, i.e. fault-tolerant, unsupervised and anyone can join the network with his own node
- open, i.e. anyone can register and maintain his own set of names
- generic purpose, i.e. it can name not only network addresses, but anything from schemas and protocols through cryptocurrency accounts and DIDs to devices and rights

## Our Solution

We provide a DNS service which satisfies all the goal mentioned above. DNS's [layer-1](/api/layer1_api) and [layer-2](/api/layer2_api) API provides a service which can be used to register domains with that holds data attached to it. This data is restricted to comply with the top level domain's schema definition. There are other things you can do with DNS, we describe those below in more detail.

### Architecture and Data Structure

Similarly to legacy naming systems, the Decentralized Naming System supervises a [tree structure](https://en.wikipedia.org/wiki/Tree_%28data_structure%29). Each node is aware of its own path and child nodes, but the tree has to be traversed to collect all farther ascendents or descendents. Note that each node can deduce the path of all parents from its own path.

#### Edges

The tree has named edges. Edge names target humans to remember easily. The human-readable path of a node is also usually referred to as domain (name) and child node as subdomain.

Edge names must consist of lowercase letters and digits from the ASCII character set. Hyphen, dot, underscore, colon, space and all other characters are forbidden. The goal is to prevent confusion often experienced in other systems allowing different entries with names that seem the same for human readers but differ in technical representation, e.g. different Unicode character set or encoding (e.g. NFC vs NFKD), cases (`name` vs `Name`) , separators (`snake_case` vs `kebab-case` vs `camelCase` vs `space case`), etc.

For easy conversion of arbitrary names to this character set, see the [AnyAscii library](https://github.com/anyascii/anyascii) and its [live demo](https://anyascii.com/) for experimentation.

The root node is hardly ever referenced in practice being only a technical, blank node. Top-level domains are referred to as `.domainname` where the leading dot separator marks an absolute path starting from the root. Subdomains paths are written as `.edge.names.along.the.path.to.node`.

#### Domain Node Data

All nodes of the tree contain node-related custom data. Node data must be a JSON value that must conform to a JSON schema stored together with the data as characterization of the node. 

IOP DNS implements a mapping for valid paths (i.e. domain names) to node records, i.e. the corresponding JSON value of the node. Thus the JSON value has to contain all technical details to further use the result, e.g. a JSON schema for `.schame` nodes, a cryptocurrency address for `.wallet` nodes, an actual DID for `.did` nodes, etc. Authorization rules for updating the node or registering subdomains, registration prices and other domain details are all kept separately as additional metainformation of nodes.

> NOTE that this is possible but delayed in the initial release and maybe added in v2 if at all.

#### Domain Hierarchy

The root has an empty schema and an empty JSON object, but all children must contain non-empty schema and data. JSON schema of each node must conform to the schema of all of its ancestor nodes as well, i.e. each node inherits the schema of its parent node and can further restrict it into a subschema. Note that JSON schemas have `additionalProperties: true` by default, therefore conformance checks accept any unspecified extra fields as valid. In other words, a subdomain can
- restrict an existing field, requiring a subtype of its previous type or even a specific fixed value.
- require a completely new field.

To ease the implementation of such schema subtype validation is extremely high, thus we take a different approach by iteratively checking data against all ancestor schemas of a node as well.

##### Top Level Domains (TLD)

Top-level domains are predefined, reserved and hardwired into source code. They also have an immutable name, schema and data, but otherwise available and handled using the same interfaces like all other domains.

Top-level domains do not expire. Subdomains registered by clients always have an expiry date or maybe a Hydra blockheight in initial versions.

In the initial release, the naming system will support only the top-level `.schema` domain which restricts that `.schema.path.to.name` must resolve to a JsonSchema string (with a maximum size to be defined later).
In later releases, a lot more domains are planned like `.did`, `.right(.system)`, `.publickey`, `.wallet`, `.device`, `.uuid`, etc.

### CRUD Operations

#### Create

Custom subdomains can be registered by anyone on a first come first serve basis as long as price and authorization both meet the requirements. Creator of the domain must explicitly specify authorization rules to update the domain or register subdomains, e.g. authenticate as a DID to update the domain but anyone can register subdomains for a defined price.

Registering a complex node path like `.one.two.three.four` needs a separate registration operation for each new subdomain, but such operations can be batched into a single transaction if desired (analog to chained directory creation with `mkdir -p` on Linux).

#### Read

While other operations that mutate domains are sent as Hydra transactions, immutable read operations are served on a separate API. See the architectural description for more details.

#### Update

There are multiple kinds of update operations, each allowing an atomic update of a domain detail. System information like parent, name, schema, registered subdomains, etc are all immutable. If such updates are badly needed, use an explicit delete and then register the same domain structure with a different name, schema, etc instead.

Using an `update` operation, the JSON data associated with the node can be changed. It still must conform to the JSON schema of the node and all of its parents.

Using a `renew` operation, expiry date of domains can be prolonged. Domains already expired still can be renewed by its original owner for a grace period (e.g. a month) to prevent losing domains accidentally. After the grace period, domains once again can be freely registered according to the regular system rules.

Using a `transfer` operation, domains can be sold or donated to a new owner updating the owner details necessary for further domain changes. Note that this might also be implemented with a trivial variant of a generic update operation. The operation contains both new owner details and an optional Hydra transaction paying the domain price (on top of Hydra transaction fees). If any of them atomically fails then the transfer does not apply.

#### Delete

Domains can be explicitly deleted before their original expiration. Deleting just means expiring the domain earlier and without a grace period, these operations are equivalent otherwise. Deleting a node with existing children detaches the whole subtree, i.e. recursively deletes all child nodes as well.

Resolving the state of a deleted domain will fail after the deletion. Ideally, queries for older snapshots of the domain record could resolve just as before and clients could also query the full history of a domain if needed, but that feature is delayed as written above.

There's no possibility of tombstoning a domain permanently, e.g. thus burning a competitor's brand name in advance. A domain can always be registered again, replacing the latest expired or deleted entry.

## Develop on DNS

In order to try out DNS, you have to connect to a Hydra network. You can do that locally or using IOP's infrastructure.
Please follow the guide [how to run a local testnet node](/hydra#run-testnet-node) or read how can you [access IOP's Hydra network](/hydra#hydra-networks).

### Samples

We provide you sample codes base in an npm package that uses the SDK. It's more useful for demonstration purposes.

<a href="https://github.com/Internet-of-People/ts-examples/tree/master/coeus" target="_blank" class="btn btn-sm btn-outline-primary">Download Samples</a>

## API

We provide you a detailed API documentation where you learn what's the difference between layer-1 and layer-2 APIs.

<a href="/api/" class="btn btn-sm btn-outline-primary">BROWSE API DOCUMENTATION</a>