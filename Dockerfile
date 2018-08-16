FROM golang:alpine as builder
# Install git and certificates
RUN apk --no-cache add tzdata zip ca-certificates git
# Make repository path
RUN mkdir -p /go/src/github.com/daveamit/go-hello-world
WORKDIR /go/src/github.com/daveamit/go-hello-world
# Install deps
RUN go get -u -v github.com/ahmetb/govvv && \
	go get -u -v github.com/gorilla/mux
# Copy all project files
ADD . .
# Generate a binary
RUN env CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags "$(govvv -flags)" -o app

# Second (final) stage, base image is scratch
FROM scratch
# Copy statically linked binary
COPY --from=builder /go/src/github.com/daveamit/go-hello-world/app /app
# Copy SSL certificates, eventhough we don't need it for this example
# but if you decide to talk to HTTPS sites, you'll need this, you'll thank me later.
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
# Notice "CMD", we don't use "Entrypoint" because there is no OS
CMD [ "/app" ]
