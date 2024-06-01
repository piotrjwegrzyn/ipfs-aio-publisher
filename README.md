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
    - name: IPFS Publish
      id: IPFS
      uses: piotrjwegrzyn/ipfs-aio-publisher@v1.1.0
      with: # all params are required
        upload_path: 'your/path/'
        remote_service_name: ${{ secrets.REMOTE_SERVICE_NAME }}
        remote_service_endpoint: ${{ secrets.REMOTE_SERVICE_ENDPOINT }}
        remote_service_key: ${{ secrets.REMOTE_SERVICE_KEY }}
        publish_key_name: ${{ secrets.PUBLISH_KEY_NAME }}
        publish_key_value: ${{ secrets.PUBLISH_KEY_VALUE }}
```

## Outputs
### `cid`
Your content's IPFS content identifier e.g.

`bafkreicysg23kiwv34eg2d7qweipxwosdo2py4ldv42nbauguluen5v6am`

## Contribute
If you have ideas to improve this action or found a bug, feel free to submit a PR or open an issue.
