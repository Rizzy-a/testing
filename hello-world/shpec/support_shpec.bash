set -o nounset
shopt -s expand_aliases
alias it='(_shpec_failures=0; alias setup &>/dev/null && { setup; unalias setup; alias teardown &>/dev/null && trap teardown EXIT ;}; it'
alias ti='return "$_shpec_failures"); (( _shpec_failures += $?, _shpec_examples++ ))'
alias end_describe='end; unalias setup teardown 2>/dev/null'

support_lib=$(dirname "$(readlink -f "$BASH_SOURCE")")/../lib/support.bash

source "$support_lib"

export TMPDIR=${TMPDIR:-$HOME/tmp}
mkdir -p "$TMPDIR"
describe sourced
  it "returns true when in a file being sourced"
    file=$(mktemp) || return
    printf 'source "%s"\nsourced' "$support_lib"  >"$file"
    (source "$file")
    assert equal 0 $?
    rm "$file"
  end

  it "returns false when that file is run"
    file=$(mktemp) || return
    printf 'source "%s"\nsourced' "$support_lib" >"$file"
    chmod 775 "$file"
    "$file"
    assert unequal 0 $?
    rm "$file"
  end
end

describe strict_mode
  it "sets errexit"
    strict_mode on
    [[ $- == *e* ]]
    assert equal 0 $?
  ti

  it "unsets errexit"
    set -o errexit
    strict_mode off
    [[ $- == *e* ]]
    assert unequal 0 $?
  ti

  it "sets nounset"
    set +o nounset    # unset it first because set at top of file
    strict_mode on
    set +o errexit    # so test won't exit if it fails
    [[ $- == *u* ]]
    assert equal 0 $?
  ti
  
   it "sets pipefail"
    strict_mode on
    set +o errexit
    [[ :$SHELLOPTS: == *:pipefail:* ]]
    assert equal 0 $?
  ti
end_describe
