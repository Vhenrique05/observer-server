#!/bin/bash

if [ -z "$1" ]; then
  $1 = 1
fi

echo -e "Generating credentials for $1 user(s)\n"

function generate_CA {
  openssl genrsa -out certs/ca.key 2048 && openssl req -subj "/C=US/ST=NY/L=Flavortown/O=Guy Fieri/OU=Development CA" -config /usr/lib/ssl/openssl.cnf -new -key certs/ca.key -x509 -days 1825 -out certs/ca.crt
}

function generate_creds {
  if [ ! -f auth/htpasswd ]; then
    for ((n=0;n<$1;n++)); do echo "imgadm-$n " "`date +%s | sha256sum | base64 | head -c 32 ; echo`" >> registry_auth && sleep 1; done
  else
    echo "auth/htpasswd exists; no new credentials being created."
  fi
}

if [ -s "registry_auth" ]
then
  echo "File not empty; backing up to registry_auth.old" && \
  mv registry_auth registry_auth.old.`date +%s | sha256sum | base64 | head -c 6 ; echo` && \
  generate_creds $1

else
  generate_creds $1
fi

if [ ! -f ca.key ]; then

  type openssl >/dev/null 2>&1 || { echo >&2 "OpenSSL is required on your local machine to generate the CA."; exit 1; }

  if [ ! -f registry_auth ]; then
      echo "registry_auth could not be found. Creating..."; exit 1 && \
      generate_creds && \
      generate_CA
  else
    echo "Generating CA certificate in `pwd`/ca.crt..." && \
    generate_CA
  fi

else
    echo "CA key and cert already exist. Skipping..."
fi
