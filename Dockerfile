FROM ubuntu:22.04

# 设置非交互模式并定义环境变量
ENV DEBIAN_FRONTEND=noninteractive \
    D_OPENLIST_URL="https://github.com/OpenListTeam/OpenList/releases/latest/download/openlist-linux-amd64.tar.gz"

WORKDIR /app

# 安装必要工具（包含 CA 证书）并执行操作
RUN apt-get update && \
    # 关键：安装 ca-certificates 解决 SSL 证书验证问题
    apt-get install -y --no-install-recommends wget tar ca-certificates && \
    wget -O openlist.tar.gz "$D_OPENLIST_URL" && \
    tar -zxvf openlist.tar.gz && \
    chmod +x ./openlist && \
    ./openlist start && \
    sleep 5 && \
    ./openlist admin && \
    ./openlist stop && \
    # 清理冗余文件和工具
    rm -rf openlist.tar.gz && \
    apt-get purge -y --auto-remove wget tar ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 5244

CMD ["./openlist", "server"]
