#! /bin/bash
# Print supported and announced C++ features of compiler and library
# Written by Ulrich Drepper <drepper@gmail.com>
ver=""
if [ $# -eq 1 ]; then
  ver="-std=$1"
fi

# All C++ standard headers
headers=(algorithm
any
array
atomic
barrier
bit
bitset
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
fenv.h
filesystem
forward_list
fstream
functional
future
initializer_list
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
netfwd
new
numbers
numeric
optional
ostream
queue
random
ranges
ratio
regex
scoped_allocator
set
shared_mutex
source_location
span
sstream
stack
stdexcept
stop_token
streambuf
string
string_view
system_error
syncstream
system_error
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
  ${CXX:-g++} $ver -dM -E -x c++ - |
  egrep '^[[:space:]]*#[[:space:]]*define *__cpp'
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
