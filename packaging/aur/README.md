# Arch Linux AUR packaging

Two AUR packages are built from this directory:

| AUR package | Files here | Builds |
|---|---|---|
| [`qrow`](https://aur.archlinux.org/packages/qrow) | `PKGBUILD`, `.SRCINFO` | from the tag tarball |
| [`qrow-bin`](https://aur.archlinux.org/packages/qrow-bin) | `PKGBUILD-bin`, `.SRCINFO-bin` | from the release archive |

AUR reads `.SRCINFO`, not `PKGBUILD`, so both are copied together. `-bin` files
go in as plain `PKGBUILD` and `.SRCINFO`.

## Coming from tuitab

`qrow` and `qrow-bin` carry `replaces`/`conflicts` for `tuitab` and
`tuitab-bin`, the same program under its former name: pacman offers to replace
the old package. The old AUR packages are merged into the new ones with a merge
request (https://aur.archlinux.org/pkgbase/tuitab/request → Merge into `qrow`,
and the same for `tuitab-bin` → `qrow-bin`).

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
