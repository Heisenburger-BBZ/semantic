#!/usr/bin/env bash
set -euo pipefail

# Creates the next SemVer tag from the latest commit message.

current_tag=$(git describe --tags --match 'v[0-9]*.[0-9]*.[0-9]*' --abbrev=0 2>/dev/null || printf 'v0.0.0')
if [[ ! "$current_tag" =~ ^v([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
  printf 'Error: latest tag is not valid SemVer: %s\n' "$current_tag" >&2
  exit 1
fi

major=${BASH_REMATCH[1]}
minor=${BASH_REMATCH[2]}
patch=${BASH_REMATCH[3]}
message=$(git log -1 --pretty=%B)
subject=$(git log -1 --pretty=%s)

# A non-conventional commit must not silently create a release tag.
if [[ ! "$subject" =~ ^([a-z]+)(\([^)]*\))?(!)?:[[:space:]] ]]; then
  printf 'No tag: commit is not a Conventional Commit: %s\n' "$subject"
  exit 0
fi

type=${BASH_REMATCH[1]}
breaking=false
[[ "$subject" == *'!: '* || "$subject" == *'!:'* || "$message" == *'BREAKING CHANGE:'* ]] && breaking=true

if [[ "$breaking" == true ]]; then
  ((major += 1))
  minor=0
  patch=0
elif [[ "$type" == feat ]]; then
  ((minor += 1))
  patch=0
elif [[ "$type" == fix || "$type" == perf ]]; then
  ((patch += 1))
else
  printf 'No tag: commit type "%s" does not change the release version.\n' "$type"
  exit 0
fi

new_tag="v${major}.${minor}.${patch}"
if git rev-parse "$new_tag" >/dev/null 2>&1; then
  printf 'No tag: %s already exists.\n' "$new_tag"
  exit 0
fi

if [[ "${DRY_RUN:-0}" == 1 ]]; then
  printf 'Would create tag %s from %s\n' "$new_tag" "$subject"
else
  git tag -a "$new_tag" -m "$subject"
  printf 'Created tag %s\n' "$new_tag"
fi
