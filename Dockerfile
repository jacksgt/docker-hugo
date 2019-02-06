FROM golang:1.11 AS builder

# "extended" version requires libsass, not supported in minimal image
ARG HUGO_BUILD_TAGS=""
ARG VERSION="v0.54.0"

ENV CGO_ENABLED=0 \
    GODEBUG=netdns=go

RUN go get github.com/magefile/mage && \
    go get -d github.com/gohugoio/hugo && \
    cd ${GOPATH}/src/github.com/gohugoio/hugo && \
    git checkout "$VERSION" && \
    mage hugo && \
    mage install

FROM scratch

COPY --from=builder /go/bin/hugo /bin/hugo

ENTRYPOINT ["/bin/hugo"]

WORKDIR /opt/blog
VOLUME /opt/blog
