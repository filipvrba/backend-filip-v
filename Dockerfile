FROM alpine AS runtime

RUN apk update && apk upgrade \
    && apk add --no-cache openssl sqlite-dev vim

WORKDIR /app
RUN mkdir bin shared
COPY /dist/bef /bin/bef

EXPOSE 8080
CMD [ "bin/bef", "server" ]