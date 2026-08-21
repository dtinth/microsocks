FROM alpine:3.22 AS builder

RUN apk add --no-cache build-base

WORKDIR /src

COPY . .

RUN make clean \
 && make CFLAGS="-Wall -std=c99 -Os -static" LDFLAGS="-static -s" \
 && ldd /src/microsocks 2>&1 | grep -q "not a dynamic executable"

FROM scratch

COPY --from=builder /src/microsocks /microsocks

USER 65532:65532

EXPOSE 1080

ENTRYPOINT ["/microsocks"]
