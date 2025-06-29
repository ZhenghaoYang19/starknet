FROM ubuntu:24.04

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.cargo/bin:$PATH"

# 安装基础工具
RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    make \
    unzip \
    nodejs \
    npm \
    python3.10 \
    python3-pip \
    jq \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 安装 GCC 13
RUN apt update && apt install -y g++-13 gcc-13
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-13 100
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-13 100

# 安装 Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN . ~/.cargo/env

# 安装 Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"

# 安装 Noir
RUN curl -L https://raw.githubusercontent.com/noir-lang/noirup/refs/heads/main/install | bash
ENV PATH="/root/.nargo/bin:$PATH"
RUN noirup --version 1.0.0-beta.6

# 安装 Barretenberg
RUN curl -L https://raw.githubusercontent.com/AztecProtocol/aztec-packages/refs/heads/master/barretenberg/bbup/install | bash
ENV PATH="/root/.bbup/bin:$PATH"
RUN bbup --version 0.86.0-starknet.1

# 安装 Starknet CLI
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.starkup.dev | sh
ENV PATH="/root/.starkup/bin:$PATH"

# 安装 Garaga
RUN pip3 install garaga==0.18.1

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . /app

# 安装项目依赖
RUN cd app && bun install

# 构建电路
RUN cd circuit && nargo build

# 编译 Cairo 合约
RUN scarb build

# 暴露端口（如果需要运行前端应用）
EXPOSE 5173

# 设置默认命令
CMD ["make", "help"]
