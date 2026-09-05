FROM cgr.dev/chainguard/go:latest-dev as builder
WORKDIR /work
COPY . /work/
RUN CGO_ENABLED=0 go build -o lambactl ./main.go

FROM cgr.dev/chainguard/static
COPY --from=builder /work/lambactl /lambactl
ENTRYPOINT ["/lambactl"]```
