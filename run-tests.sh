#!/bin/bash
if [ -f .env ]; then
  source .env
fi

if [ "$INFURA_URL" = "" -o "$BLOCK_NUMBER" = "" ]; then
  echo "Define INFURA_URL and BLOCK_NUMBER in .env or just 'export INFURA_URL=<url>' and 'export BLOCK_NUMBER=<num>'"
  exit 1
fi

if [ "$BLOCK_NUMBER" = "" ]; then
  echo "Define INFURA_URL in .env or just 'export INFURA_URL=<url>'"
  exit 1
fi

## Use extra v's e.g. -vvvv to see more detailed logs
forge test --fork-url "$INFURA_URL" --fork-block-number "$BLOCK_NUMBER" --revert-strings debug -vv $@
