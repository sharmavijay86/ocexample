FROM alpine:3.14.0
RUN apk update && apk add vim curl wget bind-tools busybox-extras nmap git && wget  https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64
RUN mv hey_linux_amd64 /usr/local/bin/hey &&  chmod +x /usr/local/bin/hey
