# openfaas template for perl running alpine linux

```shell
faas template pull https://github.com/dheffx/perl-openfaas-template
```

two variants:

- perl
- perl-mojo

Both use 5.26.3 by default but can be changed via `PERL_VERSION` argument

## perl

Simply slurps up STDIN and makes it available to the function, then encodes the result

```shell
faas new my-function-in-perl --lang perl
```

## perl-mojo

Uses Mojo::Lite to allow handling of HTTP request

```shell
faas new my-mojo-in-perl --lang perl-mojo
```
The perl-mojo template uses the of-watchdog in openfaas-incubator
