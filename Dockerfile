FROM gliderlabs/alpine:3.3
MAINTAINER Opsee dan@opsee.com

RUN apk --update add openjdk7-jre bash ca-certificates

EXPOSE 8080
EXPOSE 4242

# kairosdb 1.1.1
ADD kairosdb/ /opt/kairosdb

CMD [ "/opt/kairosdb/bin/kairosdb.sh", "run" ]
