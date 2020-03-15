#!/bin/sh -e

if [ -n "$@" ]; then
  exec "$@"
fi

NGROK_CMD="ngrok"

# Set the protocol. Default HTTP
if [ "$NGROK_PROTOCOL" = "TCP" ]; then
  NGROK_CMD="$NGROK_CMD tcp"
else
  NGROK_CMD="$NGROK_CMD http"
  NGROK_PORT="${NGROK_PORT:-80}"
fi

# Set the port.
if [ -z "$NGROK_PORT" ]; then
  echo "You must specify a NGROK_PORT to expose."
  exit 1
fi

# Set the TLS binding flag
if [ -n "$NGROK_BINDTLS" ]; then
  NGROK_CMD="$NGROK_CMD -bind-tls=$NGROK_BINDTLS "
fi

# Set the authorization token.
if [ -n "$NGROK_AUTH" ]; then
  echo "authtoken: $NGROK_AUTH" >> ~/.ngrok2/ngrok.yml
fi

# Set the subdomain or hostname, depending on which is set
if [ -n "$NGROK_HOSTNAME" ] && [ -n "$NGROK_AUTH" ]; then
  NGROK_CMD="$NGROK_CMD -hostname=$NGROK_HOSTNAME "
elif [ -n "$NGROK_SUBDOMAIN" ] && [ -n "$NGROK_AUTH" ]; then
  NGROK_CMD="$NGROK_CMD -subdomain=$NGROK_SUBDOMAIN "
elif [ -n "$NGROK_HOSTNAME" ] || [ -n "$NGROK_SUBDOMAIN" ]; then
  if [ -z "$NGROK_AUTH" ]; then
    echo "You must specify an authentication token after registering at https://ngrok.com to use custom domains."
    exit 1
  fi
fi

# Set the remote-addr if specified
if [ -n "$NGROK_REMOTE_ADDR" ]; then
  if [ -z "$NGROK_AUTH" ]; then
    echo "You must specify an authentication token after registering at https://ngrok.com to use reserved ip addresses."
    exit 1
  fi
  NGROK_CMD="$NGROK_CMD -remote-addr=$NGROK_REMOTE_ADDR "
fi

# Set a custom region
if [ -n "$NGROK_REGION" ]; then
  NGROK_CMD="$NGROK_CMD -region=$NGROK_REGION "
fi

if [ -n "$NGROK_HEADER" ]; then
  NGROK_CMD="$NGROK_CMD -host-header=$NGROK_HEADER "
fi

if [ -n "$NGROK_USERNAME" ] && [ -n "$NGROK_PASSWORD" ] && [ -n "$NGROK_AUTH" ]; then
  NGROK_CMD="$NGROK_CMD -auth=$NGROK_USERNAME:$NGROK_PASSWORD "
elif [ -n "$NGROK_USERNAME" ] || [ -n "$NGROK_PASSWORD" ]; then
  if [ -z "$NGROK_AUTH" ]; then
    echo "You must specify a username, password, and Ngrok authentication token to use the custom HTTP authentication."
    echo "Sign up for an authentication token at https://ngrok.com"
    exit 1
  fi
fi

if [ -n "$NGROK_DEBUG" ]; then
    NGROK_CMD="$NGROK_CMD -log stdout"
fi

if [ -n "$NGROK_LOOK_DOMAIN" ]; then
  NGROK_CMD="$NGROK_CMD `echo $NGROK_LOOK_DOMAIN:$NGROK_PORT | sed 's|^tcp://||'`"
else
  NGROK_CMD="$NGROK_CMD `echo $NGROK_PORT | sed 's|^tcp://||'`"
fi

set -x
exec $NGROK_CMD