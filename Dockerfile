FROM maven:3.9-amazoncorretto-17 AS builder

WORKDIR /app

# 复制pom文件
COPY ./pom.xml ./pom.xml
COPY ./chai-admin-common/pom.xml ./chai-admin-common/pom.xml
COPY ./chai-admin-system/pom.xml ./chai-admin-system/pom.xml
COPY ./chai-admin-launcher/pom.xml ./chai-admin-launcher/pom.xml

# 预下载依赖（利用Docker缓存机制）
RUN mvn dependency:go-offline -B

# 复制源代码
COPY ./chai-admin-common/src ./chai-admin-common/src
COPY ./chai-admin-system/src ./chai-admin-system/src
COPY ./chai-admin-launcher/src ./chai-admin-launcher/src

# 编译打包
RUN mvn clean package -DskipTests

# 运行阶段使用较小的基础镜像
FROM amazoncorretto:17-alpine

WORKDIR /app

# 创建非root用户
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# 复制编译好的jar包
COPY --from=builder /app/chai-admin-launcher/target/chai-admin-launcher.jar /app/app.jar

# 设置时区
RUN apk add --no-cache tzdata && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apk del tzdata

# 设置环境变量
ENV SPRING_PROFILES_ACTIVE=prod
ENV TZ=Asia/Shanghai

# 切换到非root用户
USER appuser

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/api/actuator/health || exit 1

# 启动命令
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/app/app.jar"]