FROM thevlang/vlang:alpine-dev AS builder

RUN apk update && apk upgrade
RUN apk --no-cache add upx git

WORKDIR /opt
RUN git clone https://github.com/vlang/v.git

WORKDIR /opt/v
COPY lib/sqlite.v vlib/db/sqlite/sqlite.v
RUN git clone https://github.com/filipvrba/json-parser-v.git vlib/jp
RUN git clone https://github.com/filipvrba/option-parser-v.git vlib/op
RUN git clone https://github.com/filipvrba/ruby-v.git vlib/rb
RUN make

WORKDIR /app
RUN mkdir dist
COPY . .
RUN /opt/v/v -prod -o dist/bef .

FROM alpine AS runtime

RUN apk update && apk upgrade \
    && apk add --no-cache openssl sqlite-dev vim

WORKDIR /app
COPY --from=builder /app/dist/ .

EXPOSE 8080
CMD ["./bef", "server", "64"]