# chainlink/contracts lib install

```bash
forge install smartcontractkit/chainlink --no-commit
```

# foundry-devops lib install

```bash
forge install Cyfrin/foundry-devops --no-commit
```

# intereaction

```bash
forge script ./script/Interactions.s.sol:FundFundMe --rpc-url [URL]
```

```bash
forge script ./script/Interactions.s.sol:WithdrawFundMe --rpc-url [URL]
```

# test

local test

```bash
forge test --mt [TESTFUNCTION] -vv
```

forked test

```bash
forge test --fork-url [URL]
```

test coverage report

```bash
forge coverage
```

# gas report

run and check .gas-snapshot file

```bash
forge snapshot --mt [FUNCTIONNAME]
```

# storage layout

```bash
forge inspect [CONTRACTNAME] storageLayout
```

inspect storage data

```bash
cast storage [CONTRACTADDRESS] [SLOTNUMBER]
```

# function sign

````bash
cast sig ["FUNCTIONANME()"]
```casr

# Makefile

shortcut command in Makefile

install GnuWin to use it

[GnuWin](https://gnuwin32.sourceforge.net/packages/make.htm)
````
