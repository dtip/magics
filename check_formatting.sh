#!/bin/bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     isLinux=true;;
    *)          isLinux=false
esac

if  [[ "$isLinux" = false ]] ; then
    echo "Skipping format check on $unameOut platform"
    exit 0
fi

# Auto-formatting script that checks whether the CWD and child directories have
# formatted source code.
find -E ./src -regex '.*\.(cc|cpp|hpp|cxx|h)' | while read path; do
    ORIG=$(cat "$path")
    # The `--style=file` argument will automatically find the .clang-format and
    # it doesn't take a file path but just the string `file`.
    # If .clang-format is missing the script will exit.
    # The `--style=llvm` will use the llvm standard style.
    AUTO=$(clang-format --style=llvm --fallback-style=none "$path")
    diff <(echo "$ORIG") <(echo "$AUTO") > /dev/null ||{ echo "$path is not formatted"; exit 1; }
done
