# Vaguer Health Check

This project provides a simple Dockerized solution for monitoring and health checking using the `vaguer` command and healthcheck.io.

## Usage

### 1. Build the Docker Image

Build the Docker image using the following command:

```bash
docker build -t vaguer-health-check .
```

### 2. Run the Docker Container
Run the Docker container:


```bash
docker run -d --env TELEGRAM_BOT_TOKEN="your_bot_token" \
              --env TELEGRAM_CHAT_ID="your_chat_id" \
              --env HEALTHCHECK_IO_URL="https://hc-ping.com/your_healthcheck_io_uuid" \
              vaguer-health-check
```

Replace "your_bot_token", "your_chat_id", and "your_healthcheck_io_uuid" with your actual values.

### 3. Customize the Script
If needed, customize the check_script.sh file to adapt the monitoring commands or integrate additional functionality.

### 4. Adjust Timing or Scheduling
Depending on your requirements, you may want to adjust the timing or scheduling of the script execution. You can modify the Dockerfile or use external tools like cron for this purpose.

## Dependencies
The Docker image is based on Alpine Linux and includes the following packages:

- bash
- curl
## License
This project is licensed under the MIT License - see the LICENSE file for details.