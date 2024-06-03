sourced () {
  [[ ${FUNCNAME[1]} == source ]]
}

strict_mode () {
  case $1 in
    on )
      set -o errexit
      set -o nounset
      set -o pipefail
      ;;
    off )
      set +o errexit
      set +o nounset
      set +o pipefail
      ;;
  esac
}
