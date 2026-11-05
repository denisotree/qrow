# Arch Linux AUR packaging

Two AUR packages are built from this directory:

| AUR package | Files here | Builds |
|---|---|---|
| [`qrow`](https://aur.archlinux.org/packages/qrow) | `PKGBUILD`, `.SRCINFO` | from the tag tarball |
| [`qrow-bin`](https://aur.archlinux.org/packages/qrow-bin) | `PKGBUILD-bin`, `.SRCINFO-bin` | from the release archive |

AUR reads `.SRCINFO`, not `PKGBUILD`, so both are copied together. `-bin` files
go in as plain `PKGBUILD` and `.SRCINFO`.

## Next to tuitab

tuitab, which qrow continues, stays on the AUR at 0.11.1 (`tuitab`, `tuitab-bin`). The
binaries differ (`tuitab`, `ttab`, `ttb` against `qrow`, `qrw`), so the packages do not
conflict and install side by side.

## Publishing a release

```sh
git clone ssh://aur@aur.archlinux.org/qrow.git tmp/aur-qrow
cp packaging/aur/PKGBUILD packaging/aur/.SRCINFO tmp/aur-qrow/
cd tmp/aur-qrow && git add PKGBUILD .SRCINFO && git commit -m "Update to <version>" && git push
```

The source package's `sha256sums` is the hash of the GitHub tag tarball
(`archive/refs/tags/v<version>.tar.gz`); the `-bin` hashes come from the
release's `SHA256SUMS`.

## Checking the files

```sh
cd packaging/aur
makepkg --printsrcinfo | diff - .SRCINFO
makepkg -si   # build and install locally
```
