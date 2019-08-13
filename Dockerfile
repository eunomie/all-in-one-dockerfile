FROM golang:1.12 as src
WORKDIR /usr/src/app
COPY . .

FROM src as builder
RUN go build -o hello_world

FROM src as golint
RUN go get -u golang.org/x/lint/golint
ENTRYPOINT [ "golint" ]
CMD [ "./..." ]

FROM src as govet
ENTRYPOINT [ "go", "vet" ]
CMD []

FROM src as gofmt
ENTRYPOINT [ "gofmt" ]
CMD [ "-d", "-e", "." ]

FROM hadolint/hadolint as hadolint
COPY Dockerfile .
ENTRYPOINT [ "hadolint", "Dockerfile" ]
CMD []

FROM gcr.io/distroless/base:debug as debug
COPY --from=builder /usr/src/app/hello_world /bin/hello_world
ENTRYPOINT [ "/bin/hello_world" ]
# Can use "sh" as entrypoint if needed

FROM gcr.io/distroless/base
COPY --from=builder /usr/src/app/hello_world /bin/hello_world
ENTRYPOINT [ "/bin/hello_world" ]