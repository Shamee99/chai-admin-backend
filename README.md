# Chai Admin Service

基于 Spring Boot 3 + Spring Security + JWT 的现代化后台管理系统服务端

## 🚀 项目简介

Chai Admin Service 是一个现代化的后台管理系统服务端，采用最新的技术栈构建，提供完整的用户认证、权限管理、系统管理等功能。

## ✨ 技术特性

### 核心技术栈
- **Spring Boot 3.4.2** - 最新的Spring Boot框架
- **Spring Security 6.4.2** - 安全认证框架
- **JWT (JJWT 0.12.6)** - JSON Web Token认证
- **MyBatis Plus 3.5.12** - 持久层框架
- **PostgreSQL** - 关系型数据库
- **Redis** - 缓存和会话存储
- **Druid** - 数据库连接池
- **Hutool** - Java工具类库

### 安全特性
- ✅ JWT Token 认证
- ✅ 分布式会话管理（Redis）
- ✅ 密码加密存储（BCrypt）
- ✅ 登录失败锁定机制
- ✅ 权限细粒度控制
- ✅ 数据权限范围控制
- ✅ 操作日志记录

### 系统功能
- 👤 用户管理：用户增删改查、密码重置、状态管理
- 🔐 角色管理：角色权限分配、数据范围控制
- 📋 菜单管理：动态菜单、权限控制
- 🏢 部门管理：组织架构管理
- 📊 日志管理：操作日志、登录日志
- 🔧 系统监控：Druid监控、健康检查

## 📁 项目结构

```
chai-admin-service/
├── chai-admin-common/          # 公共模块
│   ├── src/main/java/org/shamee/common/
│   │   ├── config/            # 配置类
│   │   ├── constant/          # 常量定义
│   │   ├── entity/            # 基础实体
│   │   ├── request/           # 请求对象
│   │   ├── result/            # 响应对象
│   │   └── util/              # 工具类
│   └── pom.xml
├── chai-admin-dependency/      # 依赖管理
│   └── pom.xml
├── chai-admin-system/          # 系统核心模块
│   ├── src/main/java/org/shamee/system/
│   │   ├── config/            # 配置类
│   │   ├── controller/        # 控制器
│   │   ├── entity/            # 实体类
│   │   ├── exception/         # 异常处理
│   │   ├── mapper/            # 数据访问层
│   │   ├── request/           # 请求对象
│   │   ├── result/            # 响应对象
│   │   ├── security/          # 安全相关
│   │   └── service/           # 业务逻辑层
│   └── pom.xml
├── chai-admin-launcher/        # 启动模块
│   ├── src/main/java/org/shamee/
│   │   └── Application.java   # 启动类
│   ├── src/main/resources/
│   │   ├── application.yml    # 主配置文件
│   │   ├── application-dev.yml # 开发环境配置
│   │   ├── application-prod.yml # 生产环境配置
│   │   └── db/migration/      # 数据库脚本
│   └── pom.xml
└── pom.xml                     # 父级POM
```

## 🛠️ 快速开始

### 环境要求
- JDK 21+
- PostgreSQL 12+
- Redis 6+
- Maven 3.6+

### 1. 克隆项目
```bash
git clone https://github.com/Shamee99/chai-admin-backend.git
cd chai-admin-backend
```

### 2. 数据库配置
1. 创建PostgreSQL数据库：
```sql
CREATE DATABASE chai_admin;
```

2. 执行初始化脚本：
```bash
psql -U postgres -d chai_admin -f chai-admin-launcher/src/main/resources/db/migration/V1__init_database.sql
```

### 3. 配置文件
修改 `chai-admin-launcher/src/main/resources/application-dev.yml`：
```yaml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5432/chai_admin
    username: your_username
    password: your_password
  data:
    redis:
      host: localhost
      port: 6379
      password: your_redis_password
```

### 4. 启动应用
```bash
mvn clean install
cd chai-admin-launcher
mvn spring-boot:run
```

### 5. 访问应用
- 应用地址：http://localhost:8080/api
- Druid监控：http://localhost:8080/api/druid（用户名：admin，密码：admin）
- 健康检查：http://localhost:8080/api/actuator/health

## 🔑 默认账户

| 用户名 | 密码 | 角色 | 说明 |
|--------|------|------|------|
| admin | 123456 | 超级管理员 | 拥有所有权限 |
| test | 123456 | 普通用户 | 基础查询权限 |

## 📚 API 文档

### 认证接口
- `POST /api/auth/login` - 用户登录
- `POST /api/auth/logout` - 用户登出
- `POST /api/auth/refresh` - 刷新令牌
- `GET /api/auth/me` - 获取当前用户信息
- `GET /api/auth/validate` - 验证令牌

### 请求示例
```bash
# 登录
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"123456"}'

# 获取用户信息（需要在Header中携带Token）
curl -X GET http://localhost:8080/api/auth/me \
  -H "Authorization: Bearer <your-token>"
```

## 🔧 配置说明

### JWT 配置
```yaml
chai:
  jwt:
    secret: your-jwt-secret-key
    access-token-expire-time: 120  # 访问令牌过期时间（分钟）
    refresh-token-expire-time: 7   # 刷新令牌过期时间（天）
```

### 安全配置
```yaml
chai:
  security:
    max-login-fail-count: 5      # 最大登录失败次数
    account-lock-time: 30         # 账户锁定时间（分钟）
    password-strength: 10         # 密码加密强度
```

## 🚀 部署指南

### Docker 部署
```bash
# 构建镜像
docker build -t chai-admin-service .

# 运行容器
docker run -d \
  --name chai-admin \
  -p 8080:8080 \
  -e DB_HOST=your-db-host \
  -e DB_USERNAME=your-db-username \
  -e DB_PASSWORD=your-db-password \
  -e REDIS_HOST=your-redis-host \
  chai-admin-service
```

### 生产环境配置
1. 修改 `application-prod.yml` 中的数据库和Redis连接信息
2. 设置环境变量：
```bash
export SPRING_PROFILES_ACTIVE=prod
export JWT_SECRET=your-production-jwt-secret
export DB_PASSWORD=your-production-db-password
```

## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 👨‍💻 作者

**shamee** - *Initial work*

## 🙏 致谢

感谢以下开源项目：
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Spring Security](https://spring.io/projects/spring-security)
- [MyBatis Plus](https://baomidou.com/)
- [Hutool](https://hutool.cn/)
- [Druid](https://github.com/alibaba/druid)