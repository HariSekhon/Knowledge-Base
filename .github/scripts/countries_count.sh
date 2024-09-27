#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2024-09-27 18:28:55 +0100 (Fri, 27 Sep 2024)
#
#  https///github.com/HariSekhon/Knowledge-Base
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
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
Updates the Countries Count field on the travel.md page
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

num_args 0 "$@"

cd "$srcdir/../.."

countries="$(sed -n '/## Countries/,$p' travel.md | grep ^###[[:space:]])"

num_countries="$(wc -l <<< "$countries" | sed 's/[[:space:]]*//g')"

travel_md="travel.md"

timestamp "Parsing number of countries in $travel_md"
num_countries_in_markdown="$(awk '/^Number of Countries:[[:space:]]*[[:digit:]]+$/ {print $4}' "$travel_md")"

if ! is_int "$num_countries_in_markdown"; then
    die "FAILED to parse country count from $travel_md"
fi

if [ "$num_countries_in_markdown" = "$num_countries" ]; then
    timestamp "Country count $num_countries is already up to date"
else
    timestamp "Updating country count from $num_countries_in_markdown to $num_countries"
    sed -i "s/^\(Number of Countries:\)[[:space:]]*[[:digit:]][[:digit:]]*[[:space:]]*$/\\1 $num_countries/" "$travel_md"
fi
