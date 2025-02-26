#!/bin/bash
# Script: generate-compose.sh
# Purpose: Generate a docker-compose.yml with multiple cortensor & llm pairs.

docker build -t $cortensor_image .

# Prompt for the number of pairs
read -p "Enter the number of node: " count

# Remove existing docker-compose.yml if it exists
if [ -f docker-compose.yml ]; then
  rm docker-compose.yml
fi

# Starting port for the first pair
start_port=8091
cortensor_image="cortensor-image"

# Begin the docker-compose.yml file
cat > docker-compose.yml <<EOF
version: "3.8"
services:
EOF

# Loop to generate each pair
for ((i=1; i<=count; i++)); do
  # Calculate the port for this pair
  port=$((start_port + i - 1))
  
  cat >> docker-compose.yml <<EOF

  cortensor-$i:
    image: cortensor-image
    container_name: cortensor-$i
    restart: unless-stopped
    environment:
      RPC_URL: ""
      PUBLIC_KEY: ""
      PRIVATE_KEY: ""
      LLM_PORT: "$port"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    extra_hosts:
      - "host.docker.internal:host-gateway"

  llm-$i:
    image: cortensor/llm-engine-test-1
    container_name: cts-llm-$i
    restart: always
    working_dir: /app
    environment:
      PYTHONUNBUFFERED: "True"
      APP_HOME: /app
      PORT: "$port"
      HOST: "0.0.0.0"
    command: ["/app/llava-v1.5-7b-q4.llamafile --host \$\$HOST --port \$\$PORT --nobrowser --mlock"]
    extra_hosts:
      - "host.docker.internal:host-gateway"
EOF

done

echo "docker-compose.yml generated with $count cortensor node, please adjust the env configuration accordingly."