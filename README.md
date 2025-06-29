# Prove Test - Zero Knowledge Proof for x != y²

这个项目实现了零知识证明来验证 `x != y²`，仿照 scaffold-garaga 项目的架构。

## 项目结构

```
prove_test/
├── circuit/                 # Noir 电路
│   ├── src/main.nr         # 主电路逻辑
│   ├── src/test.nr         # 测试用例
│   ├── Nargo.toml          # Noir 配置
│   └── Prover.toml         # 测试输入 (x=5, y=2)
├── verifier/               # Cairo 验证器合约
│   ├── src/                # 验证器源代码
│   └── Scarb.toml
├── src/
│   ├── lib.cairo
│   └── prove_square.cairo  # 主合约
├── Dockerfile              # Docker 环境配置
├── docker-run.sh           # Docker 运行脚本
└── Scarb.toml
```

## 电路逻辑

在 `circuit/src/main.nr` 中：

```noir
fn main(x: Field, y: pub Field) {
    assert(x != y * y);
}
```

这个简单的断言实现了：
- **零知识性**：证明者知道秘密值 `x`，验证者只知道公开值 `y`
- **算术化**：`x != y²` 被转换为数学约束
- **证明生成**：使用 HONK 协议生成零知识证明

## 快速开始

### 使用 Docker（推荐）

1. **构建并运行容器**：
   ```bash
   ./docker-run.sh build
   ./docker-run.sh run
   ```

2. **运行电路测试**：
   ```bash
   ./docker-run.sh test
   ```

3. **生成证明**：
   ```bash
   ./docker-run.sh prove
   ```

4. **启动 Starknet devnet**：
   ```bash
   ./docker-run.sh devnet
   ```

5. **运行前端应用**：
   ```bash
   ./docker-run.sh app
   ```

6. **查看所有可用命令**：
   ```bash
   ./docker-run.sh help
   ```

### 手动安装

如果你不想使用 Docker，可以手动安装依赖：

1. **安装 Noir**：
   ```bash
   curl -L https://raw.githubusercontent.com/noir-lang/noirup/refs/heads/main/install | bash
   noirup --version 1.0.0-beta.6
   ```

2. **安装 Barretenberg**：
   ```bash
   curl -L https://raw.githubusercontent.com/AztecProtocol/aztec-packages/refs/heads/master/barretenberg/bbup/install | bash
   bbup --version 0.86.0-starknet.1
   ```

3. **安装其他工具**：
   ```bash
   make install-bun
   make install-starknet
   make install-garaga
   ```

## 使用步骤

### 1. 编译电路
```bash
cd circuit
nargo build
```

### 2. 运行测试
```bash
cd circuit
nargo test
```

### 3. 生成证明
```bash
cd circuit
nargo prove
```

### 4. 生成验证密钥
```bash
cd circuit
nargo write_vk
```

### 5. 编译 Cairo 合约
```bash
scarb build
```

## 零知识证明原理

### 算术化转换
- **原始约束**：`x != y²`
- **等价约束**：`(x - y²) != 0`
- **算术化约束**：`(x - y²) * inverse(x - y²) = 1`

### 证明流程
1. **Witness 生成**：计算满足约束的变量赋值
2. **证明生成**：使用 HONK 协议生成零知识证明
3. **验证**：在链上验证证明的有效性

### 零知识性
- 证明者知道秘密值 `x`
- 验证者只知道公开值 `y`
- 验证者无法从证明中学习到 `x` 的具体值

## 技术栈

- **Noir**：零知识证明电路语言
- **Cairo**：Starknet 智能合约语言
- **HONK**：零知识证明协议
- **Garaga**：Noir 到 Cairo 的转换工具
- **Barretenberg**：证明系统后端

## 故障排除

### Docker 相关问题

1. **构建失败**：
   ```bash
   docker system prune -a
   ./docker-run.sh build
   ```

2. **端口冲突**：
   ```bash
   # 停止占用端口的进程
   sudo lsof -ti:5173 | xargs kill -9
   sudo lsof -ti:5050 | xargs kill -9
   ```

3. **权限问题**：
   ```bash
   sudo chown -R $USER:$USER .
   chmod +x docker-run.sh
   ```

### 电路相关问题

1. **编译错误**：检查 Noir 版本是否正确
2. **证明生成失败**：确保输入值满足约束条件
3. **验证失败**：检查验证密钥是否正确生成

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License 