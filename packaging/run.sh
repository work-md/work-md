#!/bin/bash
set -e

# Figure out where this script is located.
SELFDIR="`dirname \"$0\"`"
SELFDIR="`cd \"$SELFDIR\" && pwd`"

export BUNDLE_GEMFILE="$SELFDIR/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG

# Run the actual app using the bundled Ruby interpreter.
exec "$SELFDIR/ruby/bin/ruby" -r bundler/setup "$SELFDIR/gem/work_md.rb" "$@"
