#!/bin/bash

start_port=8091
cortensor_image="cortensor-image"

# Default flag values
KEEP_CONFIG=false

# Parse command-line arguments
for arg in "$@"; do
    case $arg in
        --keep-config)
            KEEP_CONFIG=true
            shift
            ;;
        *)
            # Unknown option, can add error handling if needed
            ;;
    esac
done


# Only generate docker-compose.yml if --keep-config is not set.
if [ "$KEEP_CONFIG" = false ]; then
    # Prompt for the number of nodes
    read -p "Enter the number of node: " count

    # Remove existing docker-compose.yml if it exists
    if [ -f docker-compose.yml ]; then
      rm docker-compose.yml
    fi

    # Begin the docker-compose.yml file
    cat > docker-compose.yml <<EOF
version: "3.8"
services:
EOF

    # Loop to generate each pair
    for ((i=1; i<=count; i++)); do
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
      LLM_HOST: "llm-$i"
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
      CPU_THREADS: "4"
    command: ["/app/llava-v1.5-7b-q4.llamafile --host \$\$HOST --port \$\$PORT --nobrowser --mlock -t \$\$CPU_THREADS"]
    extra_hosts:
      - "host.docker.internal:host-gateway"

EOF
    done

    echo -e "\e[32m docker-compose.yml generated with $count cortensor node, please adjust the env configuration accordingly. \e[0m"
else
    echo "Keeping existing docker-compose.yml as --keep-config flag is set."
fi

# Build the docker image regardless of config generation.
docker build -t $cortensor_image .
