#!/bin/bash

BASTION_USER="$1"
BASTION_DOMAIN="$2"
REMOTE_LOCATION="$3"
AWS_CERT_FILE="$HOME/.ssh/$4.pem"
SSH_PRIVATE_KEY_FILE="$HOME/.ssh/id_rsa"

if [[ -z "$BASTION_USER" || -z "$BASTION_DOMAIN" || -z "$REMOTE_LOCATION" ]]; then
        echo "Usage: jump_via_bastion.sh <BASTION_USER> <BASTION_DOMAIN>  <REMOTE_LOCATION> <AWS_CERT>"
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

ssh -i "$AWS_CERT_FILE" "$REMOTE_LOCATION" -o "proxycommand ssh -W %h:%p -i $SSH_PRIVATE_KEY_FILE $BASTION_USER@$BASTION_DOMAIN"
