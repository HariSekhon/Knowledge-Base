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
Checks all .md file references in markdown files exist relative to the path of the original markdown file
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

num_args 0 "$@"

cd "$git_root"

exitcode=0

while read -r file_md; do
    expected_markdowns="$(
        git grep -Eo --color=never --max-depth 1 '\([[:alnum:]/_-]+\.md.*' "$file_md" |
        sed 's/[^(]*(//' |
        { grep -Fv 'TODO' || : ; } |
        sed 's/\.md.*/.md/' |
        sort -u ||
        :  # there might be no markdowns
    )"
    while read -r expected_md; do
        if is_blank "$expected_md"; then
            continue
        fi
        # change to dir of markdown file because paths are often relative
        pushd "$(dirname "$file_md")" &>/dev/null
        if ! [ -f "$expected_md" ]; then
            if git grep -q "($expected_md).*TODO"; then
                popd &>/dev/null
                continue
            fi
            echo "referenced but file not found: $expected_md"
            git grep -F "($expected_md)"
            echo
            exitcode=1
        elif ! git ls-files --error-unmatch "$expected_md" &>/dev/null; then
            if git grep -q "($expected_md).*TODO"; then
                popd &>/dev/null
                continue
            fi
            echo "referenced file found but not committed to git: $expected_md"
            echo
            exitcode=1
        fi
        popd &>/dev/null
    done <<< "$expected_markdowns"
done < <(
    git ls-files |
    grep '\.md$'
)

if [ "$exitcode" = 0 ]; then
    echo "OK - no missing markdown references found"
fi
exit $exitcode
