#!/bin/sh

# IPFS startup
ipfs init
ipfs daemon &
./ipfs_waiter

# Pinning files
ipfs pin remote service add $REMOTE_SERVICE_NAME $REMOTE_SERVICE_ENDPOINT $REMOTE_SERVICE_KEY
CID=$(ipfs add -r -Q --cid-version=1 $UPLOAD_PATH)
ipfs pin remote add --service=$REMOTE_SERVICE_NAME --background=true $CID

# Import publish key
echo $PUBLISH_KEY_VALUE > $PUBLISH_KEY_NAME.pem
ipfs key import --format=pem-pkcs8-cleartext $PUBLISH_KEY_NAME $PUBLISH_KEY_NAME.pem

# Unpin previous hash from remote  
IPNS=$(ipfs key list -l | head -2 | tail -1 | awk '{printf $1}')
OLD_CID=$(ipfs name resolve $IPNS | sed 's/\/ipfs\///')
ipfs pin remote rm --service=$REMOTE_SERVICE_NAME --cid=$OLD_CID

# Publish new CID to IPNS
ipfs name publish --key=$PUBLISH_KEY_NAME $CID

echo "::set-output name=cid::$CID"
