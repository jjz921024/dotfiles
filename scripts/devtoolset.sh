# 安装 GCC 12 工具链（含 g++-12）
sudo dnf install gcc-toolset-12-gcc-c++

# 启用（不会修改系统默认 gcc）
scl enable gcc-toolset-12 bash
# 或者每次构建时临时启用
scl enable gcc-toolset-12 'gcc --version'


# 注册到 update-alternatives 查找实际路径
ls /opt/rh/gcc-toolset-12/root/usr/bin/g++
# 注册
sudo update-alternatives --install /usr/bin/g++ g++ /opt/rh/gcc-toolset-12/root/usr/bin/g++ 120
sudo update-alternatives --install /usr/bin/gcc gcc /opt/rh/gcc-toolset-12/root/usr/bin/gcc 120

sudo update-alternatives --config gcc
sudo update-alternatives --config g++
