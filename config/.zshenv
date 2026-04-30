export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

. "$HOME/.cargo/env"

#export JAVA_HOME=$HOME/package/openjdk-8u432-b06
export JAVA_HOME=$HOME/package/openjdk-21.0.6
export PATH="$PATH:$JAVA_HOME/bin"

export GOROOT=$HOME/sdk/go1.26.0
export GOPATH=$HOME/go-path
export PATH="$PATH:$GOROOT/bin"
export PATH="$PATH:$GOPATH/bin"

export MAVEN_HOME=$HOME/package/maven
export PATH="$PATH:$MAVEN_HOME/bin"

export CC=/usr/bin/gcc
#export CC=/usr/lib/llvm-18/bin/clang
export LLVM_DIR=/usr/lib/llvm-18
#export PATH="$PATH:$LLVM_DIR/bin"
export CMAKE_HOME=$HOME/package/cmake
export PATH="$PATH:$CMAKE_HOME/bin"

export PATH=$HOME/.tiup/bin:$PATH
export PATH=$HOME/package/tools:$PATH

export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

#export PROTOC=$HOME/package/protoc-29/bin/protoc
export PROTOC=$HOME/package/protoc-3.20/bin/protoc

#export PATH="$PATH:$HOME/package/protoc-3.20/include"

export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"

. "$HOME/.local/bin/env"

export gflags_DIR=$HOME/c-projects/gflags/build
export GFLAGS_LIBRARIES=$HOME/c-projects/gflags/build/lib
export GFLAGS_INCLUDE_DIR=$HOME/c-projects/gflags/build/include

export ROCKSDB_INCLUDE_DIR=$HOME/c-projects/rocksdb/include

#export LD_LIBRARY_PATH=$GFLAGS_LIBRARIES

#export INCLUDE_PATH=$GFLAGS_INCLUDE_DIR:$ROCKSDB_INCLUDE_DIR
#export C_INCLUDE_PATH=$INCLUDE_PATH
#export CPLUS_INCLUDE_PATH=$INCLUDE_PATH
