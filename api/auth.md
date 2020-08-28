# Authorization

Some of the endpoints in this API need authorization (and therefore authentication). Only a public key which can impersonate the resource's claimant DID can access the API. Because of these reasons, these endpoints need to use `https` to protect the privacy of the process.

We use [JWT](https://jwt.io) in http authentication headers. In the end it will be transferred in the [standard HTTP auth header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization) as a [Bearer token](https://tools.ietf.org/html/rfc6750).

The Bearer token is issued by the caller and verified by the callee service.

## Sequence diagram

```mermaid
sequenceDiagram

App->>+Client SDK: download private blob
Client SDK->>+Client SDK: Sign URL by secret key
Client SDK-->>-Client SDK: bearer(public key, URL)
Client SDK->>+Service: GET /privateBlob + bearer

Service->>+Server SDK: check bearer(public key, URL)
Server SDK-->>-Service: timestamp

Service->>Service: check last timestamp by pk was older than the current one
Service->>Service: save current timestamp by pk for at least expiration + leeway
Service->>Service: lookup blob in DB

Service-->>-Client SDK: blob
Client SDK-->>-App: blob
```

## Example JWT Header

```json
{
  "alg":"Multicipher",
  "kid":"pez2CLkBUjHB8w8G87D3YkREjpRuiqPu6BrRsgHMQy2Pzt6"
}
```

IOP SSI uses Ed25519 keys, wrapped into a Multicipher format, hence the `alg` JWT header field is set to that. We put one of the DID's public key to the `kid` as the authentication key for the caller.

## Example JWT payload

```json
{
  "exp":1596195776,
  "nbf":1596195476,
  "jti":"cjupqquRRag2lKTWAje-fDgorYUBEn4Ni6K8RMuNhXWNa8"
}
```

To avoid replay attacks, each token needs a nonce, which we implement with always changing time contstraints which defines the from/to validity of a request in the `exp` and `nbf` fields.

Whenever there is a POST request that needs authorization, the JSON digest of the POST payload needs to be added in the `jti` field of the JWT payload. This ensures that the POST payload will not be tampered with even if some parts of the host environment is outsourced (Cloudflare, GCP, AWS, etc.)

## Example JWT signature

```json
sez838N6VoprCcoQnZ45BQ2kL3YXKpgQCg6v97jM1L8y6uQs3ZRn7L5HV5RmwkSJvcqeB23DcWWpST9TB4u7YYAhKen
```

## Final Token

Both the JWT header and payload is utf8, then base64url encoded, finally concatenated with a `'.'`. For our example this ends up being `eyJhbGciOiJNdWx0aWNpcGhlciIsImtpZCI6InBlejJDTGtCVWpIQjh3OEc4N0QzWWtSRWpwUnVpcVB1NkJyUnNnSE1ReTJQenQ2In0.eyJleHAiOjE1OTYxOTU3NzYsIm5iZiI6MTU5NjE5NTQ3NiwianRpIjoiY2p1cHFxdVJSYWcybEtUV0FqZS1mRGdvcllVQkVuNE5pNks4Uk11TmhYV05hOCJ9.c2V6ODM4TjZWb3ByQ2NvUW5aNDVCUTJrTDNZWEtwZ1FDZzZ2OTdqTTFMOHk2dVFzM1pSbjdMNUhWNVJtd2tTSnZjcWVCMjNEY1dXcFNUOVRCNHU3WVlBaEtlbg`

The signature calculated for the above string is then base64url encoded and again concatenated with a `'.'` to get the whole JWT that has to go to the http Authentication header.
