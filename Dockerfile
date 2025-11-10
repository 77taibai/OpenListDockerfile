# 基础镜像
FROM ubuntu:22.04

# 定义压缩包下载链接
ENV DEBIAN_FRONTEND=noninteractive \
    D_OPENLIST_URL="https://github.com/OpenListTeam/OpenList/releases/latest/download/openlist-linux-amd64.tar.gz"

# 创建工作目录并切换
WORKDIR /app

# 下载→解压→授权→初始化（启动后立即停止，避免构建阻塞）→清理
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget tar && \
    wget -O openlist.tar.gz $D_OPENLIST_URL && \
    tar -zxvf openlist.tar.gz && \
    chmod +x ./openlist && \
    ./openlist start && \
    sleep 2 && \
    ./openlist admin && \
    ./openlist stop && \
    rm -rf openlist.tar.gz

EXPOSE 5244

# 容器启动时正式运行服务
CMD ["./openlist", "server"]
