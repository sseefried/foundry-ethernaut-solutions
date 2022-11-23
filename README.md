# Ethernaut Solutions

**WARNING**: These solutions only work with Goerli testnet


## Set up `.env`

Paste in your Infura URL for the Goerli testnet network into `.env`

See `dot-env-sample`

## Run `npm`

```
$ npm install
```

## Install Foundry

See the [docs](https://book.getfoundry.sh/getting-started/installation)

```
$ curl -L https://foundry.paradigm.xyz | bash
```

## Read the docs

- [Foundry Docs](https://book.getfoundry.sh/)
- [Cheatcodes](https://book.getfoundry.sh/cheatcodes/)

## Run the tests

```
$ ./run-tests.sh
```

## Running tests in only one file

```
$ ./run-tests.sh --match-path test/CoinFlip*
```

## More debugging information

```
$ ./run-tests.sh -vvvvv
```
