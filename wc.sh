#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2026-02-15 14:10:14 -0300 (Sun, 15 Feb 2026)
#
#  https///github.com/HariSekhon/Knowledge-Base
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#
#  https://www.linkedin.com/in/HariSekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/bash-tools/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Calculate the number of files and lines in this repo's Markdown files so we can badge it
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

no_more_args "$@"

num_files="$(git ls | grep -c '\.md$')"

linecounts="$(git ls | grep '\.md$' | xargs wc -l)"

num_lines="$(awk '/[[:space:]]total$/{print $1}' <<< "$linecounts")"

echo "$linecounts"
echo
echo "Number of Lines: $num_lines"
echo "Number of Files: $num_files"
