#!/usr/bin/env bash
set -euo pipefail
set -x

BRANCH="${1:-main}"
SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
COMMIT="$(git rev-parse --short HEAD)"
SUFFIX="$(date -u +%Y-%m-%dT%H-%M-%S.000Z)-${BRANCH}-${COMMIT}"

# Transform distribution-accounts.yaml to aws_ami_regions format: region:account1:account2,...
# Example: us-east-1:069372914117:060314908809,us-east-2:498192039992:337112168856,...
aws_ami_regions=$(yq -r 'to_entries | map(.key + ":" + (.value | join(":"))) | join(",")' "$SCRIPT_DIR/distribution-accounts.yaml")

jq --arg suffix "$SUFFIX" \
   --arg regions "$aws_ami_regions" \
   '.image_suffix=$suffix | .aws_ami_regions=$regions' \
   "$SCRIPT_DIR/vm-images-inputs.json" | \
   gh workflow run postgres-vm-image.yml --ref "$BRANCH" --json -
