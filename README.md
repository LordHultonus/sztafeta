# Sztafeta

A minimal on-chain relay baton, deployed on Base mainnet.

Anyone can create a baton. Only whoever currently holds it can pass it on. Every
handoff is stamped onchain — who, to whom, when — and the resulting chain of
custody cannot be edited or deleted by anyone, including me.

**Contract:** [`0x69dc2e4c75Da11E79DABADAB569C8cfea522063D`](https://basescan.org/address/0x69dc2e4c75Da11E79DABADAB569C8cfea522063D) (Base mainnet, chain id 8453)

## What this is, honestly

This is a small, deliberately minimal contract — my first deployment on Base.
It is not a product and does not pretend to be one. It exists because I wanted
to go through the whole pipeline once, end to end: write the contract, test it,
deploy it to mainnet, verify the source, publish it.

If you are looking for a production system, this is not it. If you are looking
for a readable 70-line example of an append-only chain of custody, it might be
useful.

## What it does

The contract holds no funds. There is no `payable` function anywhere in it — it
cannot receive or send a single wei. It only records facts.

| Function | What it does |
| --- | --- |
| `createBaton(string name)` | Creates a baton. The caller becomes its first holder. Returns the baton id. |
| `pass(uint256 batonId, address to)` | Passes a baton you currently hold to someone else. |
| `totalBatons()` | How many batons exist. |
| `chainLength(uint256 batonId)` | How many times a baton has changed hands. |
| `getChain(uint256 batonId)` | The full chain of custody, oldest handoff first. |
| `batons(uint256 batonId)` | A baton's name, creator, current holder and creation time. |

Two events, `BatonCreated` and `BatonPassed`, make the history easy to read from
outside without scanning storage.

### The only rule that matters

```solidity
require(msg.sender == baton.holder, "you do not hold this baton");
```

You cannot pass what you do not hold. Not the creator, not the deployer, not
anyone. There is no admin, no owner, no upgrade path and no back door — once
deployed, this code is the final word.

## What it does not do

It records that an address claimed a handoff. It does not — and cannot — prove
that anything happened in the physical world. A blockchain guarantees that a
record was not altered *after* it was written; it guarantees nothing about
whether the record was true *when* it was written. Any design that needs a human
to type in a real-world fact inherits that weakness, and no amount of
cryptography fixes it.

That limitation is the interesting part, and it is why this stays a demo.

## Build

Written in Solidity `^0.8.20`. Compiled and deployed with
[Remix](https://remix.ethereum.org) — no build system required. Source is
verified on [Sourcify](https://sourcify.dev).

## License

MIT
