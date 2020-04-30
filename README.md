c++-features
============

This script prints the supported and announced features of the C++
compiler and library, including experimental features.  It relies on the
required functionality of C++ compilers to define macros with
the prefix `__cpp` as appropriate.  The values of the macros indicate
the date of the specification of the features.  The value of the same macro
can have multiple dates, indicating multiple revisions of the feature definition.
Later definitions are backward-compatible with earlier versions which means
the values can be used in `static_assert` statements to ensure
the compilation environment has the necessary support.

    __static_assert(__cpp_lambdas >= 200907);

The script can be used with an optional argument indicating which
standard should be used.

    c++-features.sh

This invocation shows the features according to the default version of the
compiler.

    c++-features.sh gnu++2a

This invocation on the other hand shows the support for the (upcoming) C++20
standard along with the GNU extensions, if any.

By default, `g++` is used as the compiler.  It is possible to select a different
compiler using the CXX environment variable.

    CXX=clang++ c++-features.sh c++17

This command shows the support for C++17 in the Clang compiler


Author: Ulrich Drepper <drepper@gmail.com>
