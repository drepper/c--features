#! /bin/bash
# Print supported and announced C++ features of compiler and library
# Written by Ulrich Drepper <drepper@gmail.com>
ver=""
if [ $# -eq 1 ]; then
  ver="-std=$1"
fi

compile() {
  printf '#include <version>\n' |
  ${CXX:-g++} $ver -dM -E -x c++ - |
  grep '#define *__cpp'
}

paste <(compile | sort -n -k3) <(compile | sort -k2) |
(printf '.TS\n|lb| lb| lb| lb|\n|l| l| l| l|.\n_\nMacro\tValue\tMacro\tValue\n_\n';
 while read d m v d2 m2 v2; do
   printf "%s\t%s\t%s\t%s\n" "$m" "$v" "$m2" "$v2";
 done;
 printf "_\n.TE\n") |
groff -mandoc -t -E -Tutf8 2>/dev/null |
sed '/^[[:space:]]*$/d' |
less -RF
