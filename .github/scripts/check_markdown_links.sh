#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2025-12-17 23:00:59 -0600 (Wed, 17 Dec 2025)
#
#  https///github.com/HariSekhon/Knowledge-Base
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn
#  and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

set -euo pipefail
[ -n "${DEBUG:-}" ] && set -x
srcdir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1090,SC1091
. "$srcdir/../../bash-tools/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Finds bad markdown links not containing URL references
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

num_args 0 "$@"

exitcode=0

while IFS= read -r filename; do
    log "Checking file: $filename"
    links="$(grep -nE '\[[^]]+\]\([^)]* [^)]*\)' "$filename" || :)"
    #broken_links="$(grep -vE '\[[^]]+\]\((https?|ftp)://' <<< "$links" || :)"
    broken_links="$(grep -vE '\[[^]]+\]\(https?://' <<< "$links" || :)"
    if [ -n "$broken_links" ]; then
         echo "BROKEN LINKS in: $filename"
         echo "$broken_links"
         echo
         exitcode=1
    fi
done < <( find . -type f \( -name '*.md' -o -name '*.markdown' \) )

exit "$exitcode"
