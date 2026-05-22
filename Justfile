set shell := ["bash", "-euo", "pipefail", "-c"]

nixpkgs := "github:NixOS/nixpkgs/cc0fcdd5874deabbdb54fa54ad0df957f3f04c52"
hugo := "nix run " + nixpkgs + "#hugo --"
base_url := "https://shaunnewman.com/"

_default:
    @just --list

hugo-version:
    {{hugo}} version

build site_url=base_url: hugo-version
    {{hugo}} --minify --baseURL "{{site_url}}"
