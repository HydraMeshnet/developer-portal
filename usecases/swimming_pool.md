# Introduction

Even we were quite surprised when we realized how complex it is to not make any shortcuts and build a gatekeeper-free open system for managing identities. Let us introduce you with the broad picture through a use-case: Creating digital ID cards based on the state-provided plastic card and getting its content witnessed by a 3rd party authority.

## Table of Contents

## The Swimming Pool Usecase

In short, the user digitalizes their ID card, which gets verified by an [authority](glossary.md?id=Authority) that is trusted by some service providers. The user can then use this verified [claim](glossary.md?id=Claim) to open an account at a service provider [revealing only required fields excluding unnecessary personally identifiable data](glossary.md?id=Masked-Claim-Presentation).

In details, the following are the steps to achieve all this above:

1. User installs KYC application on their mobile phone.
   1. The KYC application automatically installs dependencies, like a crypto wallet to create,
   backup and manage all their cryptographic keys. Note: the wallet is still in development.
   2. User creates separate anonymous [personas](glossary.md?id=Persona) for each area of their lives. No need to publicly bind these personas together. These are like separate email addresses for different purposes, it just does not need an email provider to create them. Each of these personas are basically a cryptographic keypair, which has a private and a public key, and an identifier. This identifier is also called a digital identity or [DID](glossary.md?id=DID) for short.
   3. These personas will be owned by the user and they need to make sure to have backups of them, like they do with any crypto wallet. In the future the Mercury home nodes will provide an easy way to keep these backups in the user's control.

2. User chooses a 3rd party that is trusted by people and companies to be authoritative, such as a government office, a post office, a utility company or a bank.
   1. The user can get a link to the authority service as a QR code or a link on their webpage.
   2. Usually these authorities support multiple processes, so the user chooses the ID-card digitalization process.
   3. The application downloads what kind of information can be claimed by that process, what kind of evidence is required by the authority (say taking a photo of the ID card held by the user in their hand).

3. User starts to create a claim by filling in a form and providing the needed evidence.
   1. User signs all these information in the name of the persona they want to claim these on.
   2. The [signed witness request](glossary.md?id=Signed-Witness-Request) will be sent to the authority, where they give a ticket to ask for status of their progress.

4. When the authority receives a signed witness request, one of their clerks will choose to work on it based on their internal workflows.
   1. The clerk will see all the details of the request, including claim fields, pieces of evidence provided and the validity of the signature. They will carefully investigate whether the claims match the evidence based on the process they published.
   2. Hopefully the request will be approved and a [statement](glossary.md?id=Signed-Witness-Statement) will be created and signed by the clerk on behalf of the authority. This statement might contain restrictions and constraints limiting the validity of it in time and jurisdiction.
   3. The request is not pending anymore, the user can download the statement anytime. The authority must destroy the evidence unless they required a license from the user to store them longer.

5. The user downloads the statement using the ticket they got to their request.
   1. The KYC application stores the statement on the user's device. These pieces of data can also be backed up on Mercury home nodes or on other external storage solutions in the future.
   2. The authority has to store the statement until the end of its validity. After that they have to delete it, unless they are mandated by law to keep records longer.
   3. The user might upload the same witness request several times. The authority has to give the same ticket for the same signed request, so the authorities do not need to work twice and the users do not need to backup tickets.

6. The user notices that a nearby swimming pool gives a 20% discount for citizens resident in its district.
   1. The user also notices that the swimming pool supports IoP DAC and has a service endpoint to prove district of residence based on digitalized ID cards.
   2. The user follows a link or scans a QR code to choose this scenario.
   3. The user creates a presentation masking out all data but their district of residence using the statement signed by the authority trusted by the swimming pool.
   4. The user signs and uploads this presentation to the service endpoint of the swimming pool. This presentation has a unique identifier which can be rendered as a QR code.

7. The user shows the unique identifier at the entrance of the swimming pool (using a QR code or NFC tag) to apply for a discount at the point-of-sale.
   1. The cashier uses inspector software integrated to the POS to resolve the contents of the presentation and verify its validity. The discount is automatically applied or an error message is shown if the signature or the residence is not matching the requirements.

## Applications and Services

In this very specific usecase we've used three applications and two services. For more detail about these services and SDK used in the applications, please visit [this page](fort).

### Applications

#### User App

This app is for layman who would like to use a service which requires proofs or they have to prove something they claim. It has a built-in Hydra wallet in it which can be used for e.g.: DID creation. Using this app users are able to create claims and ask for proofs from other (trusted) parties. In this example we call these parties as *Authorities*, especially a government office.

After they signed and sent their claim, they will receive back proof(s), so they can start create statements out from it by strictly sharing only those private data from the proof that they really need to share with a conditions they agree with.

Example: they digitilize their ID card via a government office, but with the swimming pool they only share their address and only for 5 mins while the automatic gate lets them enter the building.

#### Clerk App

This app is used by clerks sitting in the government office. They receive requests from the users who want to digitalize their ID cards. They can use this app to check these incoming requests and either accept or reject them. This app also contains a built-in Hydra wallet as clerks have to be able to sign these accept/reject operations.

#### Inspector App

This app is used by a cashier in this example, but it can be an automated gate too. This app is very use case specific, hence we tried to minimalize its complexity.
It only receives a url in a QR code, where they can download a presentation made (and signed) by a user app.
Validating the presentation the user might (if the validation and other restrictions are valid) receive the discount while entering the pool.

### Services

#### Authority Service

This is a lightweight service (written in Typescript) which provides endpoints for authorities where they can

- provide a list which processes are available there,
- receive witness requests,
- provide status of a witness request,
- provide a list of witness requests (for internal usage, for clerks),
- they can store and serve public and private blobs for data storage.

#### Inspector Service

This is a lightweight service (written in Typescript) which provides endpoints for inspectors/verifiers where they can

- provide a list of scenarios which they support,
- receive presentations to be able to either provide or deny the scenarios' result,
- they can store and serve public and private blobs for data storage.
