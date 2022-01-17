#!/bin/bash
_cpp_features_completion()
{
  if [ ${#COMP_WORDS[@]} -gt 3 ]; then
    return
  fi
  all=$(${CXX:-g++} --help -v|& sed -n 's/^  -std=\(\(c\|gnu\)++[^ ]*\).*/\1/p')
  if [ ${#COMP_WORDS[@]} -eq 1 ]; then
    COMPREPLY=($all)
  elif [[ " ${all[*]} " =~ " ${COMP_WORDS[1]} " ]]; then
    COMPREPLY=($all)
  else
    COMPREPLY=($(compgen -W "$all" -- "${COMP_WORDS[$((${#COMP_WORDS[@]} - 1))]}"))
  fi
}
complete -F _cpp_features_completion c++-features.sh
