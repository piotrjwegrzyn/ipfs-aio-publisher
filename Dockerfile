FROM golang:alpine AS build

WORKDIR /
COPY wait_for_ipfs.go wait_for_ipfs.go
RUN CGO_ENABLED=0 go build wait_for_ipfs.go -o ipfs_waiter

FROM ipfs/go-ipfs

USER root

COPY --from=build ipfs_waiter /bin/ipfs_waiter
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/bin/sh" ]
CMD [ "/entrypoint.sh" ]