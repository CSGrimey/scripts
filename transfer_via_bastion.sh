#!/bin/bash

BASTION_USER="$1"
BASTION_DOMAIN="$2"
SOURCE="$3"
TARGET="$4"
AWS_CERT_FILE="$HOME/.ssh/$5.pem"
SSH_PRIVATE_KEY_FILE="$HOME/.ssh/id_rsa"

if [[ -z "$BASTION_USER" || -z "$BASTION_DOMAIN" || -z "$TARGET" || -z "$SOURCE" ]]; then
        echo "Usage: transfer_via_bastion.sh <BASTION_USER> <BASTION_DOMAIN> <SOURCE> <TARGET> <AWS_CERT>"
        exit 1
fi

if [[ ! -f "$AWS_CERT_FILE" ]]; then
        echo "AWS certificate file not found at $AWS_CERT_FILE"
        exit 1
fi

if [[ ! -f "$SSH_PRIVATE_KEY_FILE" ]]; then
        echo "No ssh private key found"
        exit 1
fi

scp -i "$AWS_CERT_FILE" -o "proxycommand ssh $BASTION_USER@$BASTION_DOMAIN -W %h:%p" "$SOURCE" "$TARGET"
