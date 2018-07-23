FROM alpine

RUN mkdir -p /home/app

RUN apk update && apk add gcc g++ make patch perl perl-dev curl wget ${ADDITIONAL_PACKAGE} 
RUN curl -L http://xrl.us/cpanm > /bin/cpanm && chmod +x /bin/cpanm

RUN echo "Pulling watchdog binary from Github." \
    && curl -sSL https://github.com/openfaas/faas/releases/download/0.8.0/fwatchdog > /usr/bin/fwatchdog \
    && chmod +x /usr/bin/fwatchdog \
    && cp /usr/bin/fwatchdog /home/app
    
RUN addgroup -S app && adduser app -S -G app
RUN chown app /home/app

WORKDIR /home/app

USER app

COPY index.pl .

RUN mkdir -p function
WORKDIR /home/app/function/
COPY function/cpanfile .
USER root
RUN cpanm --installdeps .
RUN apk del gcc g++ make patch curl wget --no-cache

WORKDIR /home/app/
COPY function           function
RUN chown -R app:app ./
USER app

ENV fprocess="perl index.pl"
ENV PERL5LIB=/usr/local/lib/perl5:/home/app/
ENV PATH=/usr/local/bin:$PATH

HEALTHCHECK --interval=1s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
