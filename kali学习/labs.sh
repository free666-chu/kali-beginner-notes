#!/usr/bin/env bash
# Kali 学堂 · 靶场一键部署脚本
# 用法：sudo bash labs.sh        首次会拉取镜像，约 2-3 GB
# 说明：所有端口只绑定 127.0.0.1，不暴露到局域网；只启动容器类靶场
set -u

command -v docker >/dev/null 2>&1 || { echo "未安装 Docker：sudo apt install -y docker.io"; exit 1; }
docker info >/dev/null 2>&1 || { echo "Docker 未运行：sudo systemctl start docker"; exit 1; }

# ---------- 1. DVWA ----------
# 最经典的 PHP 靶场，四档难度。SQL 注入、XSS、文件上传、命令注入、CSRF 全覆盖，每关都能调难度。
# 访问：http://127.0.0.1:8080    账号：admin / password
docker run -d --name dvwa -p 127.0.0.1:8080:80 vulnerables/web-dvwa

# ---------- 2. OWASP Juice Shop ----------
# 现代前后端技术栈（Angular + Node）的综合靶场，100+ 挑战，覆盖 OWASP Top 10 与真实业务逻辑漏洞。
# 访问：http://127.0.0.1:3000    账号：注册即可，无需预设账号
docker run -d --name juice -p 127.0.0.1:3000:3000 bkimminich/juice-shop

# ---------- 3. bWAPP ----------
# 100 多个漏洞关卡，覆盖面比 DVWA 更广，含 LDAP 注入、XML 注入、SSRF、反序列化等。
# 访问：http://127.0.0.1:8081/install.php    账号：bee / bug
docker run -d --name bwapp -p 127.0.0.1:8081:80 raesene/bwapp

# ---------- 4. WebGoat ----------
# OWASP 官方教学靶场，每关配讲解与提示，适合边学边打，覆盖 JWT、XXE、越权、密码重置。
# 访问：http://127.0.0.1:8888/WebGoat    账号：注册本地账号
docker run -d --name webgoat -p 127.0.0.1:8888:8888 -p 127.0.0.1:9090:9090 webgoat/webgoat

# ---------- 5. Kubernetes Goat / Killercoda ----------
# K8s Goat 是故意配置错误的集群场景，练 ServiceAccount 滥用、RBAC 越权、容器逃逸；Killercoda 有免费在线集群。
# 访问：http://127.0.0.1:1234    账号：见项目 README
docker run -d --name k8s-goat -p 127.0.0.1:1234:1234 -p 127.0.0.1:1236:1236 madhuakula/k8s-goat-all-in-one

echo
echo "===== 已启动的靶场 ====="
docker ps --format "table {{.Names}}\t{{.Ports}}\t{{.Status}}"
echo "重置某个靶场：docker rm -f <名字>"
# 虚拟机类靶场（Metasploitable / VulnHub / GOAD）请按靶场中心里的说明单独搭建
