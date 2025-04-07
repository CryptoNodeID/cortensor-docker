#!/bin/bash

if [ -n "$RPC_URL" ]; then
  sed -i "s|^HOST=.*|HOST=${RPC_URL//&/\\&}|" .env
fi

if [ -n "$PUBLIC_KEY" ]; then
  sed -i "s/^NODE_PUBLIC_KEY=.*/NODE_PUBLIC_KEY=$PUBLIC_KEY/" .env
fi

if [ -n "$PRIVATE_KEY" ]; then
  sed -i "s/^NODE_PRIVATE_KEY=.*/NODE_PRIVATE_KEY=$PRIVATE_KEY/" .env
fi

if [ -n "$LLM_HOST" ]; then
  sed -i "s/^LLM_HOST=.*/LLM_HOST=$LLM_HOST/" .env
fi

if [ -n "$LLM_PORT" ]; then
  sed -i "s/^LLM_PORT=.*/LLM_PORT=$LLM_PORT/" .env
fi

# Devnet 4 Runtime Address
CONTRACT_ADDRESS_RUNTIME=0x7bDF2244a3Cc65335176d7e546Cc99B9316a912a
sed -i "s/^CONTRACT_ADDRESS_RUNTIME=.*/CONTRACT_ADDRESS_RUNTIME=$CONTRACT_ADDRESS_RUNTIME/" .env

echo "CONTRACT ADDRESS RUNTIME : $CONTRACT_ADDRESS_RUNTIME"

/home/deploy/.cortensor/cortensord .env tool register
/home/deploy/.cortensor/cortensord .env tool verify
/home/deploy/.cortensor/cortensord .env minerv2 1 docker
