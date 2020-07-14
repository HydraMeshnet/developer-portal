# Authority API

To understand what's an authority, please read our glossary [here](glossary?id=authority).

## Endpoints

### List Processes

Returns all [processes](glossary?id=process) available at the [authority](glossary?id=authority).

Note: It's possible that process will not be objects but only a [content id](glossary?id=content-id). In that case, use the [blob storage endpoint](#Download-Public-Blob) to download the process itself.

```http
GET /processes
```

#### Example

```bash
curl http://127.0.0.1:8080/processes
```

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "processes": [
    "cjuc1fS3_nrxuK0bRr3P3jZeFeT51naOCMXDPekX8rPqho",
    "cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg",
    "cjujqhFEN_T2BV-TcyGNTHNeUds3m8aAc-vIWUdZSyK9Sw"
  ]
}
```

</details>

### Download Public Blob

The public hashweb of the Authority that serves only public (not confidential, not personally identifiable, e.g. processes and schemas) data for unauthorized clients.

```http
GET /blob/:id
```

#### Example

```bash
curl http://127.0.0.1:8080/blob/cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| id | string | **Required**. The id of the blow you'd like to download |

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "name": "Digitalize ID card",
  "version": 1,
  "description": "Using a selfie with your ID card we make that piece of plastic obsolete.",
  "claimSchema": "cjuQcHqNwTfmwUMfQPH0tnzmLY1pjDU_6RhO6PzNRsgZtY",
  "evidenceSchema": "cjuJt4rbRkRCRjMcsfqtZ_QZ02a2TMIGFOH2gGySXkS6_E",
  "constraintsSchema": null
}
```

</details>

### Download Private Blob

The private hashweb of the Authority that serves confidential data (possibly containing personally identifiable data) for authorized clients.

```http
GET /private-blob/:id
```

#### Example

```bash
curl http://127.0.0.1:8080/private-blob/cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| id | string | **Required**. The id of the blow you'd like to download |

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
CONFIDENTAL_DATA
```

</details>

### Post Witness Request

Returns a capability link to poll for status of the request. Since some verification and checks are done before accepting the request into the queue, we need to rate-limit this endpoint in the future.

```http
POST /requests
```

#### Example

```bash
curl -d '{"signature":{"publicKey":"pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6","bytes":"sez8TJUpKMQXoMzD9nNchD2Ze23wWsSfWGeJBPCmyVKZFevPwJBvcazghLztVn9DjtEvVycDk1yVWacL81eYDjBrJWE"},"content":{"processId":"cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg","claimant":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr#0","claim":{"subject":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr","content":{"address":"A simple address","dateOfBirth":"22/03/1980","placeOfBirth":{"city":"Berlin","country":"Germany"}}},"evidence":{},"nonce":"uWgrHk2qbBtuUErYkJpr0y0P/1noSHbNgk+J2oYOxbTE+"}}' -H "Content-Type: application/json" -X POST http://127.0.0.1/requests
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| did | string | **Required**. The DID of the document that you'd like to query. E.g.: `did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr` |
| blockHeight | number | Optional. A logical timefilter, practically how the DID document looked like at that blockHeight. If not providing it, the current height will be used. |

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "capabilityLink": "uA6o7GI7UQ8ZNWZxkF5FjjRmkeEK6YBT7EkEuVpLxfY-8"
}
```

</details>

### List Witness Requests

Contains hashlinks to the witness requests and some metadata (like when it was requested, assigned clerk, status of the request, etc.). It's used internally by for example clerks, hence it must be authenticated and authorized. TODO: authentication is not yet implemented.

```http
GET /requests
```

#### Example

```bash
curl http://127.0.0.1:8080/requests
```

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "requests": [
    {
      "capabilityLink": "uAn0nejG8RAdFMNMVtrNWH-hHaqPUrVixb98-FujIm1ay",
      "requestId": "cjuBy2Zn1m4VQ6CkyWrXinMxzDort58qlrBKxpNgcamj1Q",
      "dateOfRequest": "2020-03-12T04:52:04.000Z",
      "status": "approved",
      "processId": "cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg",
      "notes": null
    }
  ]
}
```

</details>

### Get Witness Request Status

This endpoint includes some secret in the URI that was generated when the request was accepted for processing.

Pending/Approved/Denied. For approved requests, signed witness statement can be downloaded. For denied, a description of the problem is stated.

```http
GET /requests/:capabilityLink/status
```

#### Example

```bash
curl http://127.0.0.1:8080/requests/uA6o7GI7UQ8ZNWZxkF5FjjRmkeEK6YBT7EkEuVpLxfY-8/status
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| capabilityLink | string | **Required**. The capbailityLink received back when the request was sent in. |

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "status": "approved",
  "signedStatement": {
    "signature": {
      "publicKey": "pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6",
      "bytes": "sezAAk8QmRNxaVG7KVGsMGPFB6zbFoKYq9Ky89Mv1gwdrqvXV5xNrn3hzxYATUrLZwBtS4acGNWGZhi1pgc2UwQvKkE"
    },
    "content": {
      "claim": {
        "subject": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
        "content": {
          "address": "Berlin, Strasse",
          "dateOfBirth": "15/03/2002",
          "placeOfBirth": {
            "city": "Berlin",
            "country": "Germany"
          }
        }
      },
      "processId": "cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg",
      "constraints": {
        "after": "2020-03-13T15:13:34.090083",
        "before": "2021-03-13T00:00:00.000",
        "witness": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr#0",
        "authority": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
        "content": null
      },
      "nonce": "uOGDljmXqzu5eMIHAhj6Ic88Ruquym0S2YsOxozYpXV22"
    }
  },
  "rejectionReason": null
}
```

</details>

### Approve Witness Request

Authority entities (such as a clerk) can approve a request here by creating a [signed witness statement](glossary?id=signed-witness-statement).

```http
POST /requests/:capabilityLink/approve
```

#### Example

```bash
curl -d '{"signature":{"publicKey":"pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6","bytes":"sezAg5HVCZVNvCbpqaQa1VdtnJuU4ezKTGCLSefqyTrje3QnUh2JCadi1E26NUF5PWbG4VSQjn9HLey5FNCwtDKhPZD"},"content":{"claim":{"subject":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr","content":{"address":"An Address","dateOfBirth":"22/03/1984","placeOfBirth":{"city":"Berlin","country":"Germany"}}},"processId":"cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg","constraints":{"after":"2020-03-17T10:58:31.143296","before":"2021-03-17T00:00:00.000","witness":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr#0","authority":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr","content":null},"nonce":"uDWnyDlJNtbOGlkPV52h37qT3aIo6EDHmAy1QCzSAMtbq"}}' -H "Content-Type: application/json" -X POST http://127.0.0.1/requests/uA6o7GI7UQ8ZNWZxkF5FjjRmkeEK6YBT7EkEuVpLxfY-8/approve
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| BODY | string | **Required**. A JSON object represents the [signed witness statement](glossary?id=signed-witness-statement). |

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "success": true,
}
```

</details>

### Reject Witness Request

Authority entities (such as a clerk) can reject a request here.

```http
POST /requests/:capabilityLink/reject
```

#### Example

```bash
curl -d '{"rejectionReason" : "I do not approve this"}' -H "Content-Type: application/json" -X POST http://127.0.0.1/requests/uA6o7GI7UQ8ZNWZxkF5FjjRmkeEK6YBT7EkEuVpLxfY-8/reject
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| BODY | string | **Required**. A JSON object containing the rejection reason. |

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "success": true,
}
```

</details>
