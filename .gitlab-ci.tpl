image: docker/compose:latest

services:
    - docker:dind

stages:
    - build
    - test
    - deploy

build:
    stage: build
    cache:
        paths:
            - vendor/
    before_script:
        - cd docker/
        - mkdir postgres
        - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
        - docker network create nginx-proxy
        - echo "symfony" > ./postgres/password.secret
    script:
        - docker build -f ./php/Dockerfile -t $CI_REGISTRY_IMAGE/php:prod ..
        - docker push $CI_REGISTRY_IMAGE/php
    only:
        - master
