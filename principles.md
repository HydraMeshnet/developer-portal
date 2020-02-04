# Principles / Considerations

- There are ways to provide verifiable claims and claim presentations without a blockchain, only using signatures and private communication.

> Yes, but the purpose of the blockchain is to provide a decentralized source of information about the IDENTITY of the attestants over time, even when they change keys (which they should do in regular intervals) => decentralized PKI

- We might use a blockchain just to pay for witness services.

> Amon: Yes, and more important, at some point in time we should come up with a way to make a witness request and then PAY for that request on the blockchain with a completely unrelated HYD address.

- We might use a blockchain to store certification revocations.

> Amon: Yes, this is a great feature for the future (referred to as FfF from now on :P )

- We might also use a blockchain to timestamp operations, therefore provide a strict ordering of important events.

> Amon: see above

- We might also use a blockchain to prove that a single official Identity document is not certified for multiple DIDs/personas.

> What do you mean? A persona is defined by its underlying ID, isn't it? [name=Amon]
> Not by the state. States give you their own ID cards, this is what we are referring to here [name=Wigy]
> Ah, now I get it. Ok. this might be useful in repressive states, but we should not work in that direction. Rather sell it to authorities as a plus that if someone uses their identity for multiple personas, they can trace their relation :P [name=Amon]

- We might also use a blockchain to make the performance of a certification authority auditable. (how many certifications they made).

> Yes, agreed, this is possible if the authority stamps every claim they ever sign. We can include the concept of a `hasToBeStamped` flag in the claim schemas. If that flag is `true`, the siganture validation fails if the hash of the claim does not appear on the blockchain.

- There is no use case that justifies putting personally identifiable data unencrypted onto the blockchain!

> Modified but agreed

- Different certification authorities should derive a different hash from the same set of data so the privacy is improved.

> Agreed

- We can potentially use the same blockchain (i.e. Hydra) for all different purposes above. Also many different certification authorities might use the same blockchain as their database.

> Yes. Depending on use case, private blockchains might be warranted, though (delivery tracking, for example).

- Having many claims with a few fields on an entity is better for privacy than having a few claims with many fields. Presentations might get bigger, more witness requests need to be made, but decoupling these claims is beneficial.
