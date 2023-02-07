FROM composer:2.3 AS composer

FROM php:8.1.14-fpm-alpine

ENV PROTOC_VERSION=3.19.4

# install pecl libraries
RUN set -eux && \
    apk add --update --no-cache --virtual=.build-dependencies \
    tzdata \
    autoconf \
    gcc \
    g++ \
    make \
    libtool \
    linux-headers \
    php-bcmath \
    zlib-dev && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    echo Asia/Tokyo > /etc/timezone && \
    pecl install xdebug > /dev/null && \
    pecl install grpc > /dev/null && \
    pecl install protobuf-${PROTOC_VERSION} > /dev/null && \
    apk del .build-dependencies


# enable extensions
RUN apk add --update --no-cache libstdc++
RUN docker-php-ext-install pdo_mysql && \
    docker-php-ext-enable xdebug && \
    docker-php-ext-enable grpc && \
    docker-php-ext-enable protobuf


# install composer dependencies
COPY --from=composer /usr/bin/composer /usr/bin/composer
