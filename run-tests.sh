#!/bin/bash
if [ -f .env ]; then
  source .env
fi

if [ "$INFURA_URL" = "" ]; then
  echo "Define INFURA_URL in .env or just 'export INFURA_URL=<url>'"
  exit 1
fi


## Use extra v's e.g. -vvvv to see more detailed logs
forge test --fork-url "$INFURA_URL" --fork-block-number 11468000 --revert-strings debug -vv $@