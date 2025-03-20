#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2024-02-27 18:45:11 +0000 (Tue, 27 Feb 2024)
#
#  https://github.com/HariSekhon/Knowledge-Base
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#
#  https://www.linkedin.com/in/HariSekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git_root="$srcdir/../.."

# shellcheck disable=SC1090,SC1091
. "$git_root/bash-tools/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Checks all images/* are referenced in some markdown file
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

num_args 0 "$@"

cd "$git_root"

exitcode=0

while read -r image; do
  if ! grep -q "$image" ./*.md; then
    echo "Image not referenced in markdown files: $image"
    exitcode=1
  fi
done < <(git ls-files | grep '^images/')

exit $exitcode
