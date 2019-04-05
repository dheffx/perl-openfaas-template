FROM alpine:3.9

ARG PERL_VERSION=5.26.3-r0
ARG ADDITIONAL_PACKAGE

RUN addgroup -S app && adduser app -S -G app

RUN apk --no-cache add gcc g++ make patch curl wget perl=${PERL_VERSION} perl-dev=${PERL_VERSION} ${ADDITIONAL_PACKAGE}  \
    && curl -sSLf https://github.com/openfaas-incubator/of-watchdog/releases/download/0.5.0/of-watchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && curl -sL https://cpanmin.us | perl - App::cpanminus \
    && apk del curl --no-cache \
    && mkdir -p /home/app

WORKDIR /home/app

# This ordering means the cpan installation is cached for the outer function handler.
COPY cpanfile .
RUN cpanm --installdeps .
COPY index.pl .

WORKDIR /home/app/function

# Cpanfile + installation to cache dependencies without function code
COPY function/cpanfile .
RUN cpanm --installdeps .

COPY --chown=app:app function/ .

RUN apk del gcc g++ make patch curl wget --no-cache

WORKDIR /home/app/

RUN chmod +rx -R ./function \
    && chown app:app -R /home/app

USER app

ENV cgi_headers="true" \
    fprocess="perl index.pl daemon" \
    mode="http" \
    upstream_url="http://127.0.0.1:3000" \
    exec_timeout="10s" \
    write_timeout="15s" \
    read_timeout="15s" \
    PERL5LIB=/usr/local/lib/perl5:/home/app/ \
    PATH=/usr/local/bin:$PATH

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
