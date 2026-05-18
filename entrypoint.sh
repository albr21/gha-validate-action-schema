#!/bin/sh
set -eu

target="$(printenv 'INPUT_ACTION-PATH' || echo '')"

if [ -z "$target" ]; then
  if [ -f "action.yml" ]; then
    target="action.yml"
  elif [ -f "action.yaml" ]; then
    target="action.yaml"
  else
    echo "::error::No action.yml or action.yaml found at repository root"
    exit 1
  fi
fi

schema_file="/schemas/github-action.json"

echo "Validating ${target} against GitHub Actions JSON Schema…"

if check-jsonschema --schemafile "$schema_file" "$target"; then
  {
    echo "## Action Schema Validation: :white_check_mark:"
    echo ""
    echo "\`${target}\` conforms to the [GitHub Actions schema](${schema_file})."
  } >> "$GITHUB_STEP_SUMMARY"
else
  {
    echo "## Action Schema Validation: :x:"
    echo ""
    echo "\`${target}\` does **not** conform to the [GitHub Actions schema](${schema_file})."
  } >> "$GITHUB_STEP_SUMMARY"
  exit 1
fi