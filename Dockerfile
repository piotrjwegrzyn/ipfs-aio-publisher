FROM golang:alpine AS build

WORKDIR /
COPY wait_for_ipfs.go wait_for_ipfs.go
RUN CGO_ENABLED=0 go build -o ipfs_waiter wait_for_ipfs.go

FROM ipfs/go-ipfs

USER root

COPY --from=build ipfs_waiter /ipfs_waiter
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/bin/sh" ]
CMD [ "/entrypoint.sh" ]