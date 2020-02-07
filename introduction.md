# Introduction to Morpheus

Even we were quite surprised when we realized how complex it is to not make any shortcuts and build a gatekeeper-free open system for managing identities. Let us introduce you with the broad picture through a use-case: Creating digital ID cards based on the state-provided plastic card and getting its content witnessed by a 3rd party authority.

## The KYC use-case

In short, the user digitalizes their ID card, which gets verified by an authority that is trusted by some service providers. The user can then use this verified claim to open an account at a service provider revealing only required fields excluding unnecessary personally identifiable data.

In details, the following are the steps to achieve all this above:

1. User installs KYC application on their mobile phone.
   1. (todo) The KYC application automatically installs dependencies, like a crypto wallet to create,
   backup and manage all their cryptographic keys.
   2. User creates separate anonymous personas for each area of their lives. No need to publicly bind these personas together. These are like separate email addresses for different purposes, it just does not need an email provider to create them. Each of these personas are basically a cryptographic keypair, which has a private and a public key, and an identifier. This identifier is also called a digital identity or DID for short.
   3. These personas will be owned by the user and they need to make sure to have backups of them, like they do with any crypto wallet. (todo) The Mercury home nodes provide an easy way to keep these backups in the user's control.

2. User chooses a 3rd party that is trusted by people and companies to be authoritative, such as a government office, a post office, a utility company or a bank.
   1. The user can get a link to the authority service as a QR code or a link on their webpage.
   2. Usually these authorities support multiple processes, so the user chooses the ID-card digitalization process.
   3. The application downloads what kind of information can be claimed by that process, what kind of evidence is required by the authority (say taking a photo of the ID card held by the user in their hand).

3. User starts to create a claim by filling in a form and providing the needed evidence.
   1. User signs all these information in the name of the persona they want to claim these on.
   2. The signed witness request will be sent to the authority, where they give a ticket to ask for status of their progress.

4. When the authority receives a witness request, one of their clerks will choose to work on it based on their internal workflows.
   1. The clerk will see all the details of the request, including claim fields, pieces of evidence provided and the validity of the signature. They will carefully investigate whether the claims match the evidence based on the process they published.
   2. Hopefully the request will be approved and a statement will be created and signed by the clerk on behalf of the authority. This statement might contain restrictions and constraints limiting the validity of it in time and jurisdiction.
   3. The request is not pending anymore, the user can download the statement anytime. The authority must destroy the evidence unless they required a license from the user to store them longer.

5. The user downloads the statement using the ticket they got to their request.
   1. The KYC application stores the statement on the user's device. (todo) These pieces of data can also be backed up on Mercury home nodes or on other external storage solutions.
   2. The authority has to store the statement until the end of its validity. After that they have to delete it, unless they are mandated by law to keep records longer.
   3. The user might upload the same witness request several times. The authority has to give the same ticket for the same signed request, so the authorities do not need to work twice and the users do not need to backup tickets.

6. The user notices that a nearby swimming pool gives a 20% discount for citizens resident in its district.
   1. The user also notices that the swimming pool supports Morpheus and has a service endpoint to prove district of residence based on digitalized ID cards.
   2. The user follows a link or scans a QR code to choose this scenario.
   3. The user creates a presentation masking out all data but their district of residence using the statement signed by the authority trusted by the swimming pool.
   4. The user signs and uploads this presentation to the service endpoint of the swimming pool. This presentation has a unique identifier which can be rendered as a QR code.

7. The user shows the unique identifier at the entrance of the swimming pool (using a QR code or NFC tag) to apply for a discount at the point-of-sale.
   1. The cashier uses inspector software integrated to the POS to resolve the contents of the presentation and verify its validity. The discount is automatically applied or an error message is shown if the signature or the residence is not matching the requirements.

## Applications and Services

- User application
- Authority service
- Clerk application
- Inspector service
- Cashier plugin
