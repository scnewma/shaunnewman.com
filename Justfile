set shell := ["bash", "-euo", "pipefail", "-c"]

nixpkgs := "github:NixOS/nixpkgs/cc0fcdd5874deabbdb54fa54ad0df957f3f04c52"
hugo := "nix run " + nixpkgs + "#hugo --"
base_url := "https://shaunnewman.com/"
simple_rss := "github.com/scnewma/simple-rss@v0.2.0"
blogroll_config := "data/blogroll-feeds.json"
blogroll_output := "data/blogroll.json"

_default:
    @just --list

hugo-version:
    {{hugo}} version

build site_url=base_url: hugo-version generate-blogroll
    {{hugo}} --minify --baseURL "{{site_url}}"

run: generate-blogroll
    {{hugo}} server --disableFastRender

generate-blogroll:
    mkdir -p "$(dirname '{{blogroll_output}}')"
    if [[ -f '{{blogroll_output}}' && "$(date -r '{{blogroll_output}}' +%F)" == "$(date +%F)" ]]; then \
        echo "{{blogroll_output}} already generated today; skipping"; \
    else \
        go run {{simple_rss}} -config "$(pwd)/{{blogroll_config}}" -format json -max-age 2160h > "$(pwd)/{{blogroll_output}}"; \
    fi
