#!/bin/bash

if [ -n "$RPC_URL" ]; then
  sed -i "s/^HOST=.*/HOST=$RPC_URL/" .env
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

if [ -n "$LLM_OPTION_GPU" ]; then
  sed -i "s/^LLM_OPTION_GPU=.*/LLM_OPTION_GPU=$LLM_OPTION_GPU/" .env
fi

if [ -n "$LLM_OPTION_GPU_THRESHOLD" ]; then
  sed -i "s/^LLM_OPTION_GPU_THRESHOLD=.*/LLM_OPTION_GPU_THRESHOLD=$LLM_OPTION_GPU_THRESHOLD/" .env
fi


/home/deploy/.cortensor/cortensord .env minerv2 1 docker
