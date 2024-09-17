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
Checks all .md file references in README.md exist
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args=""

help_usage "$@"

num_args 0 "$@"

cd "$git_root"

exitcode=0

while read -r file_md; do
    # most files are present so the -f "$file_md" test is faster than forking for every file
    #if git grep -q "($file_md).*TODO"; then
    #    continue
    #fi
    if ! [ -f "$file_md" ]; then
        if git grep -q "($file_md).*TODO"; then
            continue
        fi
        echo "referenced but file not found: $file_md"
        git grep -F "($file_md)"
        echo
        exitcode=1
    elif ! git ls-files --error-unmatch "$file_md" >/dev/null; then
        if git grep -q "($file_md).*TODO"; then
            continue
        fi
        echo "referenced file found but not committed to git: $file_md"
        echo
        exitcode=1
    fi
done < <(
    git grep -Eoh --max-depth 1 '\([[:alnum:]_-]+\.md.*' |
    sed 's/^(//' |
    { grep -Fv 'TODO' || : ; } |
    sed 's/\.md.*/.md/' |
    sort -u
)

exit $exitcode
