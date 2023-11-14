# Use the official Alpine Linux image
FROM node:latest

# Install necessary packages
RUN apk --no-cache add \
    bash \
    curl

# Set environment variables
ENV TELEGRAM_BOT_TOKEN="your_bot_token" \
    TELEGRAM_CHAT_ID="your_chat_id" \
    HEALTHCHECK_IO_URL="https://hc-ping.com/your_healthcheck_io_uuid" \
    VEGA_NETWORK="testnet1" \
    VEGA_VALIDATOR="validator" 
    

# Set the working directory
WORKDIR /app

# Copy the script to the container
COPY check_script.sh /app/check_script.sh

# Set execute permissions for the script
RUN chmod +x /app/check_script.sh

# Run the script when the container starts
CMD ["/app/check_script.sh"]
