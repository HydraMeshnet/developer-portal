# KYC use-case

## Witness service (Authority daemon)

A separate binary application to receive witness requests and provide an interface for inspectors to accept or deny requests.

In the future we will use Mercury for publishing this service, but for the MVP we will just implement an HTTP endpoint.

The service has to validate witness request signatures, thus internally depends on the Layer2 API of a blockchain node to resolve Did Document history.

### List processes

In the MVP we support a fixed set of processes that are hosted on a single server. Convenient creation of new processes and schemas are to be addressed in a later milestone.

### Get public blob by link

The public hashweb of the Authority that serves only public (not confidential, not personally identifiable, e.g. processes and schemas) data for unauthorized clients.

The type of the blob (e.g. image, city, street address) is included in the link. Initially, there must be only a few different link types available: blob/unknown, process and schema.

Putting the type into the link and not an envelop around the blob allows hashweb to treat the same blob in multiple ways (like trait objects do for a struct in rust)

The client sends a link (~typed hash) as a requests and receives the resolved blob in the response or an error.

### Receive a signed witness request from claimants

Returns a capability link to poll for status of the request. Since some verification and checks are done before accepting the request into the queue, we need to rate-limit this endpoint.

### Capability link: Query status of Witness Request

This endpoint includes some secret in the URI that was generated when the request was accepted for processing.

Pending/Approved/Denied. For approved requests, signed witness statement can be downloaded. For denied, a description of the problem is stated.

On the long term the claimant should be directly notified on the decision instead of polling a link, but that requires Mercury so it's for a later milestone.

### Clerk only: List witness requests

Contains hashlinks to the witness requests and some metadata (like when it was requested, assigned clerk, status of the request, etc.)

Can be filtered by metadata, e.g. to find an unassigned request for processing.

### Clerk only: Get protected blob by link

The private hashweb of the Authority that serves confidential data (possibly containing personally identifiable data) for authorized clients.

Witness request contents can be downloaded by their hashlink.

### Clerk only: Assign witness request(s)

Any clerk can set the assignee of a request to anything when the request is in pending state. Can self-assign, assign it to someone else or just remove the assignee. We just left it open to an external workflow, but we do not implement a worflow in this MVP.

### Assigned clerk only: Approve witness request

Uploads a signed statement by the clerk.

### Assigned clerk only: Deny witness request

Uploads a reasoning why the request was denied.

## Authority daemon client (Clerk tool)

A ticket-like system for clerks "consuming" witnessing tasks from a queue according to multiproducer-multiconsumer pattern with pessimistic locking.

### List witness requests

### Self-assign a witness request

- Pessimistically lock a single request
- Download contents

Continue with showing contents.

### Show current request details

### Deny current request

Upload a description of reasons of denial. Usually the possible reasons will be picked from a list included in the process description to help automation.

### Approve current request

Build a witness statement with appropriate constraints (defined in the process), sign it and upload the statement to be queriable by the claimant. We imagine the private key to be controlled by the clerk, but alternatively the clerk tool could use a wallet service provided by the authority.

### Unassign current request

## Verifier service (Daemon)

The service has to validate witness statement signatures in presentations, thus internally depends on the Layer2 API of a blockchain node to resolve Did Document history.

We might even integrate these features into the hydra-core node either as part of the morpheus-plugin or another extra plugin.

### Check signatures

Check validity of a DID signature in relation to a given Did at a given height

- content id
- signature object including signer pubkey or keyid (could be an after envelope including a contentId or a contentId on its own)
- on behalf of did (requires appropriate rights in Did Document)

- unmasked after envelope (if applicable) (to turn yellow to green or red in case the key is not default, therefore it has right only after some height)

- existing before proof on the blockchain (to turn yellow to green or red in case the key has lost rights at some height) (this does not need to be explicitly provided, but can be resolved by the service on its own)

## Presentation handler service (Inspection daemon, Verifier daemon client)

The configuration of the daemon contains

- an endpoint of the verifier service
- list of possible inspection scenarios a user can select from
- list of trusted authorities

In some simple cases, inspection scenarios can be scripted, so no inspector staff tool is needed to process them.

### List inspection scenarios

### Receive presentation for a given scenario

link or hashweb URL, or the presentation as the blob itself?

## Inspector tool (Inspection daemon client)

The simplest implementation of this tool is a CLI tool that reads a file containing a presentation and shows it with some generic formatting after signature validation.

TODO move this into glossary in specification

An inspection scenario describes a set of concatenated claims needed in a single presentation that are required to calculate a derived property of a DID and make an informed decision based on its value. Each claim must conform to a specified process, therefore a list of processes clearly defines the list of required claims.

An inspection might contain multiple scenarios, but the inspector must be able to calculate the same derived property for each scenario of the inspection.

### Verify presentation signatures

Verify signatures of a completely masked presentation by sending multiple requests to verifier. Checks

- witness signature of each statement
- license signature (presenter)

### Display presentation contents

"Property editor" for visual display of presentations. Validation of a presentation is completely process-dependent.

## Morpheus SDK (User tool)

Client state to be stored:

- Keyvault
- Global contact list (DIDs with private, custom associated data, e.g. alias, avatar, custom endpoints) (these are global players/authorities). In a later phase this should fetched from a global yellow pages online service on the blockchain and thus be part of cached data below.
- claims
  - list DIDs and nonces (see maskable claim properties) of previous usages
- evidences
  - list DIDs and nonces (see maskable claim properties) of previous usages
- Issued (signed?) presentations, initially for a single DID only in MVP, later for multiple DIDs with licensing proofs for each
- By DID:
  - friend list (DIDs with private, custom associated data, e.g. alias, avatar, custom endpoints)
  - witness requests with status links
  - signed witness statements

Data might worth caching with specified expiration to force periodic refetching of cached data:

- known witnesses including service endpoints
- processes and schemas, i.e. discovered partition of the hashweb
- DIDs encountered including full Did Document history (keys, rights, services)
- known inspectors including service endpoints
  - issued presentations
- By DID:
  - Issued (signed?) presentations by subject (rebuilt from the global presentation store mentioned in part 1)

### Add witness service contact

Request must contain at least a Did, alias and a service endpoint.

(After adding the contact, fetches and caches Did Document history and all processes and schemas related to this witness service.)

### Full-text search for available claim properties/schemas/processes/witnesses

This feature would add a lot to user convenience, but absolutely out of the scope of an initial MVP.

### Pick a process

### Create or select claim

### Create or select evidence

### Sign and send witness request to a selected witness (conforming to the process)

### Query witness request status

- Notify if still pending
- Display if rejected
- Import signed witness statement if approved

### List inspection scenarios accepted by an inspector

### Create presentation for an inspection scenario

### Send presentation to inspector

Results in a presentation link that can be shared with an inspector. Simplest implementation is saving to a file.
