# Sztafeta

A minimal on-chain relay baton, deployed on Base mainnet.

Anyone can create a baton. Only whoever currently holds it can pass it on. Every
handoff is stamped onchain - who, to whom and when. The resulting chain of
custody cannot be edited or deleted by anyone. The Basics.

**Contract:** [`0x69dc2e4c75Da11E79DABADAB569C8cfea522063D`](https://basescan.org/address/0x69dc2e4c75Da11E79DABADAB569C8cfea522063D)

## What this is

A small, deliberately minimal contract and my first deployment on Base.
It is not a product and does not pretend to be one. It exists because I wanted
to go through the whole pipeline once: write the contract, test it,
deploy to mainnet.

If you are looking for a production system, this is not it. If you are looking
for a readable 70-line example of an append-only chain of custody, it might be
useful.

## What it does

The contract holds no funds. There is no `payable` function anywhere in it, it only records events.

| Functions | What they do |
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

You cannot pass what you do not hold.

## What it does not do

It records that an address claimed a handoff. It does not and cannot prove
that anything happened in the physical world. It guarantees nothing about
whether the record was true *when* it was written. Any design that needs a human
to type in a real-world fact inherits that weakness.

That limitation is the interesting part and why it's a demo.

## Build

Written in Solidity `^0.8.20`. Compiled and deployed with
[Remix](https://remix.ethereum.org) - no build system required. Source is
verified on [Sourcify](https://sourcify.dev).

## License

MIT
