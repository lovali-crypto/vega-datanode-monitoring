#!/bin/bash

# Set your Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN="${TELEGRAM_BOT_TOKEN:-your_bot_token}"
TELEGRAM_CHAT_ID="${TELEGRAM_CHAT_ID:-your_chat_id}"

# Set the healthcheck.io URL (set to an empty string if not needed)
HEALTHCHECK_IO_URL="${HEALTHCHECK_IO_URL:-https://hc-ping.com/your_healthcheck_io_uuid}"

# Vega config
VEGA_NETWORK="${VEGA_NETWORK:-testnet1}"
VEGA_VALIDATOR="${VEGA_VALIDATOR:-vega}"

# Store the previous output in a file
PREVIOUS_OUTPUT_FILE="/previous_output.txt"

# Set the command to execute
COMMAND="npx github:vegaprotocol/vaguer $VEGA_NETWORK | grep $VEGA_VALIDATOR | grep 🥇"

# Check if the previous output file exists
if [ -e "$PREVIOUS_OUTPUT_FILE" ]; then
    # File exists, compare the output
    CURRENT_OUTPUT=$(eval "$COMMAND")
    PREVIOUS_OUTPUT=$(cat "$PREVIOUS_OUTPUT_FILE")

    if { [ "$PREVIOUS_OUTPUT" = "ok" ] && [ -z "$CURRENT_OUTPUT" ]; } || { [ "$PREVIOUS_OUTPUT" = "nok" ] && [ -n "$CURRENT_OUTPUT" ]; }; then
        # Output has changed, send a Telegram message
        # If $CURRENT_OUTPUT is empty raise an error
        if [ -z "$CURRENT_OUTPUT" ]; then
            MESSAGE="[Vega Datanode - $VEGA_NETWORK] [🔴 Down] $VEGA_VALIDATOR is offline! Vaguer monitoring"
        else
            MESSAGE="[Vega Datanode - $VEGA_NETWORK] [✅ Up] $VEGA_VALIDATOR is online! Vaguer monitoring"
        fi
        URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
        DATA="chat_id=$TELEGRAM_CHAT_ID&text=$MESSAGE"
        curl -s -X POST $URL -d "$DATA"
    fi
    
    STATUS=""
    if [ -n "$CURRENT_OUTPUT" ]; then
        STATUS="ok"
    else
        STATUS="nok"
    fi
    echo "$STATUS" > "$PREVIOUS_OUTPUT_FILE"
else
    # File doesn't exist, create it with the current output
    CURRENT_OUTPUT=$(eval "$COMMAND")
    STATUS=""
    if [ -n "$CURRENT_OUTPUT" ]; then
        STATUS="ok"
    else
        STATUS="nok"
    fi
    echo "$STATUS" > "$PREVIOUS_OUTPUT_FILE"
fi

if [ -n "$HEALTHCHECK_IO_URL" ]; then
    curl -sSf $HEALTHCHECK_IO_URL && echo "Healthcheck.io Status: success" || echo "Healthcheck.io Status: failure"
fi
