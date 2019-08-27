#!/bin/bash

BASTION_USER="$1"
BASTION_DOMAIN="$2"
REMOTE_LOCATION="$3"
AWS_CERT_FILE="$HOME/.ssh/$4.pem"
LOCAL_PORT="$5"

if [[ -z "$BASTION_USER" || -z "$BASTION_DOMAIN" || -z "$REMOTE_LOCATION" || -z "$LOCAL_PORT" ]]; then
        echo "Usage: tunnel.sh <BASTION_USER> <BASTION_DOMAIN> <REMOTE_LOCATION> <AWS_CERT> <LOCAL_PORT>"
        exit 1
fi

if [[ ! -f "$AWS_CERT_FILE" ]]; then
        echo "AWS certificate file not found at $AWS_CERT_FILE"
        exit 1
fi

echo ""
echo "Setting up SSH tunnel via $BASTION_USER@$BASTION_DOMAIN to $REMOTE_LOCATION on port $LOCAL_PORT..."
echo ""

ssh -ND "$LOCAL_PORT" -i "$AWS_CERT_FILE" -J "$BASTION_USER@$BASTION_DOMAIN" "$REMOTE_LOCATION"
