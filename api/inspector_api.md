# Inspector API

To understand what's an inspector, please read our glossary [here](glossary?id=inspector).

## Endpoints

### List Scenarios

Returns all inspection [scenarios](glossary?id=scenario) available at this [inspector](glossary?id=inspector).

Note: It's possible that `scenarios` will not be objects but only a [content id](glossary?id=content-id). In that case, use the [blob storage endpoint](#Download-Public-Blob) to download the process itself.

```http
GET /scenarios
```

#### Example

```bash
curl http://127.0.0.1:8080/scenarios
```

#### Response

<details>
<summary>
Click here to expand
</summary>

```json
{
  "scenarios": [
    "cjuFURvWkcd-82J83erY_dEUhlRf9Yn8OiWWl7SxVpBvf4"
  ]
}
```

</details>

### Download Public Blob

Any public content hosted on this service can be downloaded by their ContentId.

```http
GET /blob/:id
```

#### Example

```bash
curl http://127.0.0.1:8080/blob/cjuFURvWkcd-82J83erY_dEUhlRf9Yn8OiWWl7SxVpBvf4
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
  "name": "Swimming discount",
  "version": 1,
  "description": "Reduced prices based on your resident address",
  "prerequisites": [
    {
      "process": "cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg",
      "claimFields": [
        ".address"
      ]
    }
  ],
  "requiredLicenses": [
    {
      "issuedTo": "did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr",
      "purpose": "Inspection by gate-keeper",
      "expiry": "P5M"
    }
  ],
  "resultSchema": "cjuX-RNFIObr1rj1N54SHvkvmY9o4v9CzWgcd3gBlk9xp8"
}
```

</details>

### Upload Presentation

Users can share a claim [presentation](glossary?id=claim-presentation) with the inspector service anytime before they want to get an inspection. They could host it anywhere and present a URL on their servers, but most users will not have the self-hosted infrastructure.

```http
POST /presentation
```

#### Example

```bash
curl -d '{"signature":{"publicKey":"pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6","bytes":"sezAQERSSaxoF4Vhop6GdHNtzVnrhe6s21549jrc1rgJrveBevkENQf6uVMaJC9QKBd9J4sgZA34rgS3SbmFF3ELvJt"},"content":{"provenClaims":[{"claim":{"content":{"address":"Strasse","dateOfBirth":"16/02/2002","placeOfBirth":{"city":"Berlin","country":"Germany"}},"subject":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr"},"statements":[{"signature":{"publicKey":"pez7aYuvoDPM5i7xedjwjsWaFVzL3qRKPv4sBLv3E3pAGi6","bytes":"sez7wdTBDCUdAPuRLifRC3TRxctDcdbABM25iMmz4xiVsdbgFf84fyUDhoPrrWmNbqLYmfCqtM8tAtycW9Dq7yjY3bK"},"content":{"claim":{"content":{"address":"Strasse","dateOfBirth":"16/02/2002","placeOfBirth":{"city":"Berlin","country":"Germany"}},"subject":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr"},"constraints":{"after":"2020-02-13T14:02:25.959532","authority":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr","before":"2021-02-13T00:00:00.000","content":null,"witness":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr#0"},"nonce":"uI6/zmtfF37W9ZzbZAj6trQJoUtTNnJyKCkhPox+wC7DO","processId":"cjunI8lB1BEtampkcvotOpF-zr1XmsCRNvntciGl3puOkg"}}]}],"licenses":[{"issuedTo":"did:morpheus:ezbeWGSY2dqcUBqT8K7R14xr","purpose":"Inspection by gate-keeper","validFrom":"2020-03-14T15:26:27.0","validUntil":"2020-03-14T15:45:0.0"}]}}' -H "Content-Type: application/json" -X POST http://127.0.0.1/presentation
```

#### Parameters

| Name | Type | Description |
|---|---|---|
| BODY | string | **Required**. A JSON object containing the the [claim presentation](glossary?id=claim-presentation). |

#### Response

```json
{
  "contentId": "cjuzqZB44pPQWetXUBiEbWRUV_E59OSSotga5_Qx94hxRY"
}
```
