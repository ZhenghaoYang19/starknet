#!/bin/bash

# 设置镜像名称和容器名称
IMAGE_NAME="prove-test"
CONTAINER_NAME="prove-test-container"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 打印帮助信息
show_help() {
    echo -e "${GREEN}Prove Test Docker 运行脚本${NC}"
    echo ""
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  build     - 构建 Docker 镜像"
    echo "  run       - 运行容器（交互模式）"
    echo "  test      - 运行电路测试"
    echo "  prove     - 生成证明"
    echo "  devnet    - 启动 Starknet devnet"
    echo "  app       - 运行前端应用"
    echo "  clean     - 清理容器和镜像"
    echo "  help      - 显示此帮助信息"
    echo ""
}

# 构建镜像
build_image() {
    echo -e "${YELLOW}构建 Docker 镜像...${NC}"
    docker build -t $IMAGE_NAME .
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}镜像构建成功！${NC}"
    else
        echo -e "${RED}镜像构建失败！${NC}"
        exit 1
    fi
}

# 运行容器
run_container() {
    echo -e "${YELLOW}启动容器...${NC}"
    docker run -it --rm \
        --name $CONTAINER_NAME \
        -p 5173:5173 \
        -p 5050:5050 \
        -v $(pwd):/app \
        $IMAGE_NAME /bin/bash
}

# 运行电路测试
run_test() {
    echo -e "${YELLOW}运行电路测试...${NC}"
    docker run --rm \
        -v $(pwd):/app \
        $IMAGE_NAME bash -c "cd circuit && nargo test"
}

# 生成证明
generate_proof() {
    echo -e "${YELLOW}生成证明...${NC}"
    docker run --rm \
        -v $(pwd):/app \
        $IMAGE_NAME bash -c "cd circuit && nargo prove"
}

# 启动 devnet
start_devnet() {
    echo -e "${YELLOW}启动 Starknet devnet...${NC}"
    docker run -d --rm \
        --name devnet \
        -p 5050:5050 \
        $IMAGE_NAME bash -c "starknet-devnet --accounts=2 --seed=0 --initial-balance=100000000000000000000000"
    echo -e "${GREEN}Devnet 已启动在 http://localhost:5050${NC}"
}

# 运行前端应用
run_app() {
    echo -e "${YELLOW}启动前端应用...${NC}"
    docker run -d --rm \
        --name app \
        -p 5173:5173 \
        -v $(pwd):/app \
        $IMAGE_NAME bash -c "cd app && bun run dev --host 0.0.0.0"
    echo -e "${GREEN}前端应用已启动在 http://localhost:5173${NC}"
}

# 清理
clean() {
    echo -e "${YELLOW}清理容器和镜像...${NC}"
    docker stop $CONTAINER_NAME devnet app 2>/dev/null || true
    docker rm $CONTAINER_NAME devnet app 2>/dev/null || true
    docker rmi $IMAGE_NAME 2>/dev/null || true
    echo -e "${GREEN}清理完成！${NC}"
}

# 主逻辑
case "$1" in
    "build")
        build_image
        ;;
    "run")
        build_image
        run_container
        ;;
    "test")
        build_image
        run_test
        ;;
    "prove")
        build_image
        generate_proof
        ;;
    "devnet")
        build_image
        start_devnet
        ;;
    "app")
        build_image
        run_app
        ;;
    "clean")
        clean
        ;;
    "help"|"")
        show_help
        ;;
    *)
        echo -e "${RED}未知命令: $1${NC}"
        show_help
        exit 1
        ;;
esac 