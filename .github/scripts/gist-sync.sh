#!/usr/bin/env bash
#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: 2024-03-22 00:24:54 +0000 (Fri, 22 Mar 2024)
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

git_root="$srcdir/../.."

# shellcheck disable=SC1090,SC1091
. "$git_root/bash-tools/lib/utils.sh"

# shellcheck disable=SC2034,SC2154
usage_description="
Syncs all top level .md files except README.md to GitHub Gists
"

# used by usage() in lib/utils.sh
# shellcheck disable=SC2034
usage_args="arg [<options>]"

help_usage "$@"

num_args 0 "$@"

gist_list="$(gh gist list -L 2000 --public)"

for readme in *.md; do
    if awk '{print $2}' <<< "$gist_list" | grep -Fxq "$readme"; then
        id="$(awk "/^[[:alnum:]]{32}[[:space:]]+$readme / {print \$1; exit}" <<< "$gist_list" || :)"
        if [ -z "$id" ]; then
            echo "Failed to determine ID for gist of file '$readme'"
            exit 1
        fi
        gist_md5="$(gh gist view "$id" --filename "$readme" --raw | md5sum)"
        readme_md5="$(md5sum < "$readme")"
        if [ "$gist_md5" != "$readme_md5" ]; then
            echo "Updating Gist for '$readme'"
            gh gist edit "$id" --filename "$readme" --desc "$readme from HariSekhon/Knowledge-Base repo: https://github.com/HariSekhon/Knowledge-Base" "$readme"
        else
            echo "Gist for '$readme' already matches, not updating"
        fi
      else
          echo "Creating Gist for '$readme'"
          gh gist create --public --filename "$readme" --desc "$readme from HariSekhon/Knowledge-Base repo: https://github.com/HariSekhon/Knowledge-Base" "$readme"
    fi
done
