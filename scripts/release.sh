#!/usr/bin/env sh
# Build a release zip locally using the BigWigs packager.
#
# By default this runs in "dist only" mode (-d): it builds the zip into
# .release/ and uploads nothing. That is the right mode until CurseForge /
# Wago projects exist.
#
# For automated publishing, prefer the GitHub Actions workflow
# (.github/workflows/release.yml) — push a vX.Y.Z tag and it runs this same
# packager in CI. Use this script for local no-upload dry-runs, or to publish
# by hand:
#
# To publish by hand:
#   1. Create the CurseForge / Wago projects and fill X-Curse-Project-ID /
#      X-Wago-ID in QuestUIReorder.toc (at the repo root — flat layout).
#   2. Export the tokens:
#         export CF_API_KEY=...        # CurseForge
#         export WAGO_API_TOKEN=...    # Wago
#         export GITHUB_OAUTH=...      # GitHub personal access token (for the Release)
#   3. Run this script with no args to upload, e.g.  sh scripts/release.sh
#      (drop the implicit -d by passing your own flags, e.g. `sh scripts/release.sh -p 0000`).
#
# The packager reads the latest git tag for the version, so tag first:
#   git tag v0.5.0 && git push --tags
set -e

cd "$(dirname "$0")/.."

# Default to a no-upload build unless the caller passes their own flags.
if [ "$#" -eq 0 ]; then
	set -- -d
fi

curl -s https://raw.githubusercontent.com/BigWigsMods/packager/master/release.sh | bash -s -- "$@"
