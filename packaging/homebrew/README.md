# Homebrew tap

The tap is the repository **`denisotree/homebrew-qrow`**; it holds `Formula/qrow.rb`, a copy
of `qrow.rb` from this directory. tuitab, which qrow continues, keeps its own tap
(`denisotree/homebrew-tuitab`) at 0.11.1, so the two install side by side.

## User installation

```sh
brew install denisotree/qrow/qrow
```

## Updating the formula for a release

`/release` sets the version and URLs and resets every `sha256`; once the GitHub Release
is built, the hashes come from its `SHA256SUMS`. Copy the formula to `Formula/qrow.rb`
in the tap and push to `main`.

## Testing the formula locally

In a clone of the tap:

```sh
brew install denisotree/qrow/qrow
brew test qrow
brew audit --strict denisotree/qrow/qrow
```
