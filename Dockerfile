# 基础镜像
FROM alpine:latest

# 定义压缩包下载链接
ENV OPENLIST_URL="https://github.com/OpenListTeam/OpenList/releases/latest/download/openlist-android-amd64.tar.gz"

# 创建工作目录并切换
WORKDIR /app

# 下载→解压→授权→初始化（启动后立即停止，避免构建阻塞）→清理
RUN wget -O openlist.tar.gz $OPENLIST_URL && \
    tar -zxvf openlist.tar.gz && \
    chmod +x openlist && \
    ./openlist start && \
    sleep 2 && \
    ./openlist admin && \
    ./openlist stop && \
    rm -rf openlist.tar.gz

# 容器启动时正式运行服务
CMD ["./openlist", "server"]