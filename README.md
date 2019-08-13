# All in one Dockerfile

This is an example of a `Dockerfile` with all included:

- build
- debug image
- Dockerfile linter
- go lint/vet/fmt

All needed targets are included in one single `Dockerfile` (thanks to multistage builds) so you need nothing but `Docker` on your local machine. It also ensures that all checks are ran the same way locally and on a CI server for instance.

It's also a way to avoid one question: which "build" tool to use and install everywhere? And the answer is often `make`.

## Targets

In this example you will have different targets:

- `src`: the base image, based on `golang` for the example, where the sources are copied and containing most of the tools to build the software
- `build`: an image based on `src` to build the application
- `golint`: based on `src` and that will run `go lint`
- `govet`: based on `src` and that will run `go vet`
- `gofmt`: based on `src` and that will run `gofmt`
- `hadolint`: run `hadolint` against the `Dockerfile`
- `debug`: a `distroless/base:debug` image that contains the built application and a busybox shell
- the default image based on `distroless/base` that contains the built application, this is the final target and the one to run

## Run targets

It's very easy and always using the same way:

1. Build the image:

    ```shell
    docker build --target <target> -t hello_world:<target> .
    ```

2. Run the image:

    ```shell
    docker run --rm hello_world:<target>
    ```

That's all!

If you want to run the application:

```shell
docker build -t hello_world .
docker run --rm hello_world
```

    Hello World!

And by example if you want to run `gofmt` (as an example the code contains errors):

```shell
docker build --target gofmt -t hello_world:gofmt .
docker run --rm hello_world:gofmt
```

and the output will looks like

    diff -u main.go.orig main.go
    --- main.go.orig	2019-08-13 16:26:37.232800000 +0000
    +++ main.go	2019-08-13 16:26:37.232800000 +0000
    @@ -5,5 +5,5 @@
     )
    
     func main() {
    -	 fmt.Println("Hello World!")
    -}
    \ No newline at end of file
    +	fmt.Println("Hello World!")
    +}

## BuildKit

It's way better to use `BuildKit` to run this kind of `Dockerfile`.
