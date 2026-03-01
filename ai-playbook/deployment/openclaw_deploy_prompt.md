# OpenClaw 工程级部署控制模板（Windows 11 + VSCode + PowerShell）

你现在是我的 DevOps 工程师 + 架构分析师。

目标：
在 Windows 11 + VSCode + PowerShell 环境下，
把当前 OpenClaw 项目完整部署、跑通，
并生成可重复执行（幂等）的工程脚本。

⚠️ 必须分阶段执行，每一阶段完成后停下来等我确认。

---

# 第一阶段：项目结构识别（只分析，不安装）

你必须：

1. 读取仓库根目录文件结构
2. 判断项目类型：
   - Python
   - Node.js
   - Docker
   - 混合架构
3. 找到启动入口文件（例如 main.py / server.js / docker-compose.yml）
4. 找到依赖来源文件：
   - requirements.txt
   - pyproject.toml
   - package.json
   - docker-compose.yml
5. 明确说明你判断依据（必须指出文件名作为证据）

输出：

- 项目类型判断
- 启动方式说明
- 依赖安装方式说明
- 是否需要 .env
- 是否需要数据库或外部服务

完成后暂停，等待我确认。

---

# 第二阶段：生成安装脚本（仅生成，不执行）

在项目根目录生成：

ops/install.ps1

要求：

- 创建 ops/ 和 ops/logs/ 目录
- 创建或校验 .gitignore，确保：
  - .env
  - secrets*
  - *.key
  不会被提交
- 如果是 Python：
  - 创建 venv
  - 激活 venv
  - 安装依赖
- 如果是 Node：
  - 安装依赖
  - 锁定版本
- 如果是 Docker：
  - 构建或拉取镜像
- 所有输出写入：
  ops/logs/install.log

禁止危险操作：
- 禁止删除根目录
- 禁止注册表修改
- 如需删除缓存，必须先打印路径并让我输入 YES 才执行

完成后列出生成文件清单，暂停等待我执行脚本。

---

# 第三阶段：生成运行脚本

生成：

ops/run.ps1

要求：

- 从 .env 读取配置
- 如果 .env 不存在，提示复制 .env.example
- 启动服务
- 输出日志到：
  ops/logs/runtime.log
- 如果支持端口参数，允许：
  .\ops\run.ps1 -Port 3000

完成后说明成功启动判断标准：
- 访问哪个 URL
- 返回什么状态
- 日志出现什么关键字

暂停等待我运行。

---

# 第四阶段：健康检查脚本

生成：

ops/healthcheck.ps1

要求：

- 检查进程是否存在
- 检查端口是否监听
- 检查 HTTP 响应（如适用）
- 输出 PASS 或 FAIL
- 写入：
  ops/logs/healthcheck.log

完成后给出最短故障排查说明。

---

# 协作方式

每个阶段必须：

1. 列出生成或修改的文件
2. 给出我下一步要复制执行的命令
3. 等待我把终端输出贴回

不得一次性跳过阶段。

现在开始第一阶段分析。
