# IPFS All-in-One Publisher

This GitHub Action helps you to pin your website/assets to IPFS Pinning Services (e.g. [Pinata](https://pinata.cloud/documentation#PinningServicesAPI) or [Filebase](https://docs.filebase.com/api-documentation/ipfs-pinning-service-api) using the official [IPFS Remote Pinning API](https://ipfs.github.io/pinning-services-api-spec/). After that, it publishes the new CID to IPNS with key specified and unpin previous CID.

Forked from [alexanderschau/ipfs-pinning-action](https://github.com/alexanderschau/ipfs-pinning-action).

## Usage
You can use this Action directly from your GitHub workflow. You can find the required credentials on your Pinning Services Website.

```yaml
#/.github/workflows/main.yml
on: [push]

jobs:
  push_to_ipfs:
    runs-on: ubuntu-latest
    name: Pin and publish
    steps:
    - uses: actions/checkout@v4
    - name: IPFS Publish
      id: IPFS
      uses: piotrjwegrzyn/ipfs-aio-publisher@v1.2.3
      with:
        # required params:
        upload_path: 'your/path/'
        # optional:
        remote_service_name: ${{ env.REMOTE_SERVICE_NAME }}
        remote_service_endpoint: ${{ secrets.REMOTE_SERVICE_ENDPOINT }}
        remote_service_key: ${{ secrets.REMOTE_SERVICE_KEY }}
        remote_background: ${{ env.REMOTE_BACKGROUND }}
        remote_unpin_old_cid: ${{ env.REMOTE_UNPIN_OLD_CID }}
        publish_key_name: ${{ secrets.PUBLISH_KEY_NAME }}
        publish_key_value: ${{ secrets.PUBLISH_KEY_VALUE }}
        propagate_time: ${{ env.PROPAGATE_TIME }}
```

### Required/optional

To use pinning service you shall use all of those: `remote_service_name`, `remote_service_endpoint` and `remote_service_key`.

To publish to IPNS you shall define both `publish_key_name` and `publish_key_value`.

To unpin old CID you shall define `remote_unpin_old_cid` and also have to publish.

### Secrets

`publish_key_value` is a content of `key.pem` got by running the command:

```
ipfs key export --format=pem-pkcs8-cleartext <KEY-NAME>
```

Default key name is `self`.

NOTE: During setting the secret, remember to remove header and footer (`----BEGIN PRIVATE KEY----` and `----END PRIVATE KEY----`).

## Outputs
### `cid`
Your content's IPFS content identifier e.g.

`bafkreicysg23kiwv34eg2d7qweipxwosdo2py4ldv42nbauguluen5v6am`

## Contribute
If you have ideas to improve this action or found a bug, feel free to submit a PR or open an issue.
