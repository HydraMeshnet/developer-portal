# Verifier API

To understand what's a verifier, please read our glossary [here](glossary?id=verifier).

## Endpoints

### Getting After Proof

Whenever a user wants to wrap their presentation in an [AfterEnvelop](https://iop-stack.iop.rocks/dids-and-claims/specification/#/glossary?id=after-envelope), they can query the latest block height and id from this endpoint.

```http
GET /after-proof
```

#### Example

```bash
curl http://127.0.0.1:8080/after-proof
```

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "blockHeight": 1861199,
  "blockHash": "6c98d03a06ac9089bd4aa44f7aee78591d7c667a1ca66df3e3164b09e96d3576"
}
```

</details>

### Validate Signature with Before-After Proof

This endpoint is for verifying the validity of a signature by looking up DID documents and comparing access rights.

**The verifier does not see any private information contained in the claim, only cryptographical hashes, signatures and other information relevant to validate the signatures and the timeline of events.**

```http
POST /validate
```

#### Example

```bash
curl -d '{"publicKey":"pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6","contentId":"cjuwtAZcIdlSzKS8i8qvg5Ux-N0-s5MOKkE1qyzsmlGw5A","signature":"sezAhsRgfDMRvSTFmLjDDkbFcxjPMxBrbo8ikJ1j8sba2oxoe5cLGc8J5FsMx8czVVRVKurwTJUkCRktC177ZGJp5Md","onBehalfOf":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr","afterProof":{"blockHeight":180,"blockHash":"youAintKnowThisBeforeBlock180"}}' -H "Content-Type: application/json" -X POST http://127.0.0.1/validate
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| BODY | string | **Required**. A JSON object, see in the example. |

#### Response

```json
{
  "errors": [],
  "warnings": []
}
```
