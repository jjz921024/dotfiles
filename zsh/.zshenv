. "$HOME/.cargo/env"

if [ -z "${JAVA_HOME}" ]; then
    export JAVA_HOME=$HOME/package/openjdk-8u432-b06
    export PATH="$JAVA_HOME/bin:$PATH"
fi

if [ -z "${GOROOT}" ]; then
    export GOROOT=$HOME/package/go
    export GOPATH=$HOME/go-path
    export PATH="$PATH:$GOROOT/bin:$GOPATH/bin"
fi

if [ -z "${MAVEN_HOME}" ]; then
    export MAVEN_HOME=$HOME/package/maven
    export PATH="$PATH:$MAVEN_HOME/bin"
fi

#export CC=/usr/bin/gcc
export CC=/usr/lib/llvm-18/bin/clang
if [ -z "${LLVM_DIR}" ]; then
    export LLVM_DIR=/usr/lib/llvm-18
    export CMAKE_HOME=$HOME/package/cmake
    export PATH="$PATH:$LLVM_DIR/bin:$CMAKE_HOME/bin"
fi

export PATH=/home/skyjiang/.tiup/bin:$PATH
export PATH=/home/skyjiang/package/tools:$PATH


