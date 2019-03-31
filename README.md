# openfaas template for perl running alpine linux

```shell
faas-cli template pull https://github.com/dheffx/perl-openfaas-template
```

two variants:

- perl
- perl-mojo

Both use 5.26.3 by default but can be changed via `PERL_VERSION` argument

## perl

Simply slurps up STDIN and makes it available to the function, then encodes the result

```shell
faas-cli new my-function-in-perl --lang perl-mojo
```

## perl-mojo

Uses Mojo::Lite to allow handling of HTTP request

A function receives the Mojo::Message::Request and a function::context object

```shell
faas-cli new my-function-in-perl --lang perl-mojo
```

Mojo logs to STDERR by default, and OpenFaaS combines STDOUT and STDERR by default.
You can set `combine_output: false` in your function.yaml's environment section, and Mojo's logging will instead show up in `docker service logs -f my_func`
