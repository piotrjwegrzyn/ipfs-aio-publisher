#!/bin/sh

echo "IPFS startup"
ipfs init
ipfs daemon &
/ipfs_waiter

echo "Adding files from $UPLOAD_PATH to IPFS"
CID=$(ipfs add -r -Q --cid-version=1 $UPLOAD_PATH)
echo "Done. CID: $CID"

if [ -n "$REMOTE_SERVICE_NAME" ]; then
  echo "Adding remote service ($REMOTE_SERVICE_NAME)..."
  ipfs pin remote service add $REMOTE_SERVICE_NAME $REMOTE_SERVICE_ENDPOINT $REMOTE_SERVICE_KEY
  echo "Done."

  echo "Pinning files..."
  ipfs pin remote add --service=$REMOTE_SERVICE_NAME --background=$REMOTE_BACKGROUND $CID
  echo "Done."
fi

if [ -n "$PUBLISH_KEY_NAME" ]; then
  echo "Importing key for publishing"
  echo $PUBLISH_KEY_VALUE | sed 's/\ /\n/g' | sed -e '1i-----BEGIN PRIVATE KEY-----' -e '$a-----END PRIVATE KEY-----' > $PUBLISH_KEY_NAME.pem
  ipfs key import --format=pem-pkcs8-cleartext $PUBLISH_KEY_NAME $PUBLISH_KEY_NAME.pem
  echo "Done."

  if [ "$REMOTE_UNPIN_OLD_CID" == "true" ]; then
    echo "Getting old CID for given key"
    IPNS=$(ipfs key list -l | head -2 | tail -1 | awk '{printf $1}')
    OLD_CID=$(ipfs name resolve $IPNS | sed 's/\/ipfs\///')
    echo "Done. Old CID: $OLD_CID"
  fi

  echo "Publishing new CID to IPNS"
  ipfs name publish --key=$PUBLISH_KEY_NAME $CID
  echo "Done."

  if [[ -n "$REMOTE_SERVICE_NAME" && "$REMOTE_UNPIN_OLD_CID" == "true" ]]; then
    echo "Unpinning previous CID from remote"
    ipfs pin remote rm --service=$REMOTE_SERVICE_NAME --cid=$OLD_CID
    echo "Done."
  fi
fi

echo "Additional sleep for $PROPAGATE_TIME secs (propagate time)"
sleep $PROPAGATE_TIME
echo "Done."

echo "cid=$CID" >> $GITHUB_OUTPUT