c++-features
============

This script prints the supported and announced features of the C++
compiler and library.  Macros with the prefix `__cpp` are defined appropriately.
The values can be used in `static_assert` statements to ensure
the compilation environment has the necessary support.

The script can be used with an optional argument indicating which
standard should be used.

    c++-features.sh

This invocation shows the features according to the default version of the
compiler.

    c++-features.sh gnu++2a

This invocation on the other hand shows the support for the (upcoming) C++20
standard along with the GNU extensions, if any.

It is possible to control the compiler that is used with the CXX environment
variable.

    CXX=clang++ c++-features.sh c++17

This command shows the support for C++17 in the Clang compiler


Author: Ulrich Drepper <drepper@gmail.com>
