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
Updates the Country Count field on the travel.md page
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

num_args 0 "$@"

cd "$srcdir/../.."

travel_md="travel.md"

if ! [ -f "$travel_md" ]; then
    die "FAILED to find file: $travel_md"
fi

if [[ "$USER" =~ hari|sekhon ]]; then
    if type -P curl_with_cookies.sh &>/dev/null &&
       type -P pycookiecheat &>/dev/null; then
        nomads_csv=~/Downloads/"$(date '+%F')-harisekhon-trips-on-nomad-list.csv"
        curl_with_cookies.sh https://nomads.com/@harisekhon.csv > "$nomads_csv"
        csv="$(tail -n +2 "$nomads_csv")"
        total_countries="$(
            awk -F, "{print \$5}" <<< "$csv" |
            sed 's/"//g' |
            sort -u
        )"
        total_cities="$(
            awk -F, "{print \$5\"-\"\$4}" <<< "$csv" |
            sed 's/"//g' |
            sort -u
        )"
        num_total_countries="$(
            sed '/^[[:space:]]*$/d' <<< "$total_countries" |
            wc -l |
            sed 's/[[:space:]]//g;'
        )"
        num_total_cities="$(
            sed '/^[[:space:]]*$/d' <<< "$total_cities" |
            wc -l |
            sed 's/[[:space:]]//g;'
        )"
        sed -i "
            s/\(Countries: \).*/\\1$num_total_countries/;
            s/\(Cities: \).*/\\1$num_total_cities/;
            s|\(Total%20Countries-\)[[:digit:]]*|\\1$num_total_countries|;
            s|\(Total%20Cities-\)[[:digit:]]*|\\1$num_total_cities|;
        " "$travel_md"
        for year in {2024..2099}; do
            countries="$(
                awk -F, "/\"$year/{print \$5}" <<< "$csv" |
                sed 's/"//g' |
                sort -u
            )"
            cities="$(
                awk -F, "/\"$year/{print \$5\"-\"\$4}" <<< "$csv" |
                sed 's/"//g' |
                sort -u
            )"
            num_countries="$(
                sed '/^[[:space:]]*$/d' <<< "$countries" |
                wc -l |
                sed 's/[[:space:]]//g;'
            )"
            num_cities="$(
                sed '/^[[:space:]]*$/d' <<< "$cities" |
                wc -l |
                sed 's/[[:space:]]//g;'
            )"
            if [ "$num_countries" = 0 ]; then
                break
            fi
            sed -i "
                s/\(Countries in $year: \).*/\\1$num_countries/;
                s/\(Cities in $year: \).*/\\1$num_cities/;
                s|\(Countries in $year](https://img.shields.io/badge/in%20$year-\)[[:digit:]]*|\\1$num_countries|;
                s|\(Cities in $year](https://img.shields.io/badge/in%20$year-\)[[:digit:]]*|\\1$num_cities|;
            " "$travel_md"
            countries_since_2024+="
$countries"
            cities_since_2024+="
$cities"
        done
        num_countries_since_2024="$(
            sed '/^[[:space:]]*$/d' <<< "$countries_since_2024" |
            sort -u |
            wc -l |
            sed 's/[[:space:]]//g;'
        )"
        num_cities_since_2024="$(
            sed '/^[[:space:]]*$/d' <<< "$cities_since_2024" |
            sort -u |
            wc -l |
            sed 's/[[:space:]]//g;'
        )"
        sed -i "
            s/\(Unique Countries since Emigrating from the UK in 2024: \).*/\\1$num_countries_since_2024/;
            s/\(Unique Cities since Emigrating from the UK in 2024: \).*/\\1$num_cities_since_2024/;
            s|\(Unique%20Countries%202024+-\)[[:digit:]]*|\\1$num_countries_since_2024|;
            s|\(Unique%20Cities%202024+-\)[[:digit:]]*|\\1$num_cities_since_2024|;
        " "$travel_md"
    fi
fi

countries="$(sed -n '/## Countries/,$p' travel.md | grep '^###[[:space:]]')"

num_countries="$(wc -l <<< "$countries" | sed 's/[[:space:]]*//g')"

timestamp "Parsing number of countries in $travel_md"
num_countries_in_markdown="$(awk '/^Countries:[[:space:]]*[[:digit:]]+$/ {print $2}' "$travel_md")"

if ! is_int "$num_countries_in_markdown"; then
    die "FAILED to parse country count from $travel_md"
fi

if [ "$num_countries_in_markdown" = "$num_countries" ]; then
    timestamp "Country count $num_countries is already up to date"
else
    timestamp "Updating country count from $num_countries_in_markdown to $num_countries"
    sed -i "
        s/^\(Countries:\)[[:space:]]*[[:digit:]][[:digit:]]*[[:space:]]*$/\\1 $num_countries/;
        s|\(Total%20Countries-\)[[:digit:]]*|\\1$num_countries|;
    " "$travel_md"
fi
