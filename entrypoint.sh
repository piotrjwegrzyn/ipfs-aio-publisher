#!/bin/sh

echo "IPFS startup"
ipfs init
ipfs daemon &
/ipfs_waiter

echo "Adding remote service ($REMOTE_SERVICE_NAME)"
ipfs pin remote service add $REMOTE_SERVICE_NAME $REMOTE_SERVICE_ENDPOINT $REMOTE_SERVICE_KEY

echo "Adding files from $UPLOAD_PATH to IPFS"
CID=$(ipfs add -r -Q --cid-version=1 $UPLOAD_PATH)

echo "Pinning files with CID: $CID"
ipfs pin remote add --service=$REMOTE_SERVICE_NAME --background=true $CID

echo "Importing key for publishing"
echo $PUBLISH_KEY_VALUE | sed 's/\ /\n/g' | sed -e '1i-----BEGIN PRIVATE KEY-----' -e '$a-----END PRIVATE KEY-----' > $PUBLISH_KEY_NAME.pem
ipfs key import --format=pem-pkcs8-cleartext $PUBLISH_KEY_NAME $PUBLISH_KEY_NAME.pem

echo "Unpinning previous hash from remote"  
IPNS=$(ipfs key list -l | head -2 | tail -1 | awk '{printf $1}')
OLD_CID=$(ipfs name resolve $IPNS | sed 's/\/ipfs\///')
ipfs pin remote rm --service=$REMOTE_SERVICE_NAME --cid=$OLD_CID

echo "Publishing new CID to IPNS"
ipfs name publish --key=$PUBLISH_KEY_NAME $CID

echo "cid=$CID" >> $GITHUB_OUTPUT