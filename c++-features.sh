#! /bin/bash
# Print supported and announced C++ features of compiler and library
# Written by Ulrich Drepper <drepper@gmail.com>
if [ $# -eq 0 ]; then
  ver=$(${CXX:-g++} -v --help 2>/dev/null |sed -n 's/^  -std=\(gnu[+][+][0-8][^ ]*\).*/\1/p'|sort|tail -n1)
  printf 'using version %s\n' $ver
else
  ver="$1"
fi
if [ $# -eq 2 ]; then
  ver2="$2"
fi

# All C++ standard headers
headers=(algorithm
any
array
atomic
barrier
bit
bitset
buffer
cassert
ccomplex
cctype
cerrno
cfenv
cfloat
charconv
chrono
cinttypes
ciso646
climits
clocale
cmath
codecvt
compare
complex
concepts
condition_variable
coroutine
csetjmp
csignal
cstdalign
cstdarg
cstdbool
cstddef
cstdint
cstdio
cstdlib
cstring
ctgmath
ctime
cuchar
cwchar
cwctype
deque
exception
execution
executor
expected
fenv.h
filesystem
format
forward_list
fstream
functional
future
initializer_list
internet
io_context
iomanip
ios
iosfwd
iostream
istream
iterator
latch
limits
list
locale
map
memory
memory_resource
mutex
net
netfwd
new
numbers
numeric
optional
ostream
print
propagate_const
queue
random
ranges
ratio
regex
scoped_allocator
semaphore
set
shared_mutex
socket
source_location
span
spanstream
sstream
stack
stacktrace
stdexcept
stdfloat
stop_token
streambuf
string
string_view
syncstream
system_error
text_encoding
thread
tuple
typeindex
typeinfo
type_traits
unordered_map
unordered_set
utility
valarray
variant
vector
version)

has_include() {
  fname="<$1/$2>"
  printf '#if __has_include(%s)\n#include %s\n#endif\n' "$fname" "$fname"
}

compile() {
  (printf '#include <version>\n#ifdef __has_include\n'; for h in "${headers[@]}"; do has_include experimental "$h"; done; printf '#endif\n') |
  ${CXX:-g++} -std=$1 -dM -E -x c++ - |
  grep -E '^[[:space:]]*#[[:space:]]*define *__cpp'
}

if [ -z "$ver2" ]; then
  paste <(compile $ver | sort -n -k3) <(compile $ver | sort -k2) |
  (printf '.TS\n|lb| lb| lb| lb|\n|l| l| l| l|.\n_\nMacro\tValue\tMacro\tValue\n_\n';
   while read d m v d2 m2 v2; do
     printf "%s\t%s\t%s\t%s\n" "$m" "$v" "$m2" "$v2";
   done;
   printf "_\n.TE\n") |
  groff -mandoc -t -E -Tutf8 2>/dev/null |
  sed '/^[[:space:]]*$/d' |
  less -RF
else
  diff -u0 <(compile $ver | sort -n -k2) <(compile $ver2 | sort -n -k2) | tail -n+3 | sed '/^@/d' |
  awk '{ if ($1 == "-#define") { rem[$2]=$3 } else { if($2 in rem) { printf("%s %s %s\n", $2, rem[$2], $3); delete rem[$2] } else { printf("%s N/A %s\n", $2, $3) } } } END { for (k in rem) { printf("%s %s N/A\n", k, rem[k]) } }' |
  sort -k1 |
  (printf ".TS\n|lb| lb| lb|\n|l| l| l|.\n_\nMacro\t$ver Value\t$ver2 Value\n_\n";
   while read m v1 v2; do
     printf "%s\t" "$m";
     if [ "$v1" == "N/A" ]; then printf "\t"; else printf "%s\t" "$v1"; fi;
     if [ "$v2" == "N/A" ]; then printf "\n"; else printf "%s\n" "$v2"; fi;
   done;
   printf "_\n.TE\n") |
  groff -mandoc -t -E -Tutf8 2>/dev/null |
  sed '/^[[:space:]]*$/d' |
  less -RF
fi
