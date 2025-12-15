#!/usr/bin/env ruby
#  vim:ts=4:sts=4:sw=4:et:filetype=ruby
#
#  Author: Hari Sekhon
#  Date: 2024-08-22 01:58:12 +0200 (Thu, 22 Aug 2024)
#
#  https///github.com/HariSekhon/Knowledge-Base
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback to help steer this or other code I publish
#
#  https://www.linkedin.com/in/HariSekhon
#

all
#exclude_rule 'MD001'
#exclude_rule 'MD003'
exclude_rule 'MD005'  # aws.md hits a false positive on nested sub-list and mdl does not support inline ignores
exclude_rule 'MD007'  # leave 2 space indentation for lists, 3 space is ugly af
#exclude_rule 'MD012'
exclude_rule 'MD013'  # long lines cannot be split if they are URLs
#exclude_rule 'MD022'
#exclude_rule 'MD025'
exclude_rule 'MD026'  # Trailing punctuation in header - sometimes I want to do etc. or ... at the end of a heading
# MD029 ordered list item prefix is necessary if injecting code blocks
# otherwise start counting from 1 again afterwards
exclude_rule 'MD029'
exclude_rule 'MD031'  # hitting false positive in markdown.md
#exclude_rule 'MD032'
exclude_rule 'MD033'  # inline HTML is important for formatting
exclude_rule 'MD034'  # hitting false positive in couchbase.md for <> urls
exclude_rule 'MD036'  # emphasis used instead of header for footer Ported from lines
#exclude_rule 'MD039'
exclude_rule 'MD056'  # inconsistent number of columns is a false positive in couchbase.md and vim.md
