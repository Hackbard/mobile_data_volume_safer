# Mobile Data Volume Safer (MDVS)
Safe your Mobile Data Volume with this Special Squid Proxy 

## WARNING
This Project has a alpha state!

## Introduction
Dockerfile to create a Docker container image for Squid proxy server.

Squid is a caching proxy for the Web supporting HTTP, HTTPS, FTP, and more. It reduces bandwidth and improves response times by caching and reusing frequently-requested web pages. Squid has extensive access controls and makes a great server accelerator.

## Installaton

### Start
```
# docker-compose up 
```
### Generate new User
Go to project root dir and try the follow:
```
# htpasswd -cb config/squid/squid.passwd USERNAME PASSWORD
```
if you don't know how to use htpasswd or it's not installed use google!

## TODO

* NGINX + mod_pagespeed
* Documentation
