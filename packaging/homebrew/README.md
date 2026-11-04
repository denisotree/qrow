# Homebrew tap

The tap is the repository **`denisotree/homebrew-qrow`** (formerly
`homebrew-tuitab`). It holds two files from this directory:

- `Formula/qrow.rb` — a copy of `qrow.rb`;
- `formula_renames.json` at the root — `{"tuitab": "qrow"}`. It tells
  `brew update` that the formula `tuitab` is now `qrow`, so an existing tuitab
  install moves to qrow on the next `brew upgrade` with nothing to do by hand.
  Keep the file in the tap for good: a machine that has not run `brew update`
  since the rename still needs it.

## User installation

```sh
brew tap denisotree/qrow
brew install qrow
```

## Updating the formula for a release

`/release` sets the version and URLs and resets every `sha256`; once the
GitHub Release is built, the hashes come from its `SHA256SUMS`. Copy the
formula to `Formula/qrow.rb` in the tap and push to `main`.

## Testing the formula locally

```sh
brew install --build-from-source Formula/qrow.rb
brew test qrow
brew audit --new qrow
```
