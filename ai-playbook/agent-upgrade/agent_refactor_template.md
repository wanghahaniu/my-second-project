你现在是我的 DevOps 工程师 + 架构分析师。

目标：
在 Windows 11 + VSCode + PowerShell 环境下，
把当前项目完整部署、跑通，并生成可重复执行的工程脚本。

工作步骤必须严格分层执行：

第一阶段：结构分析
1. 读取根目录文件结构
2. 判断项目类型（Python / Node / Docker / 混合）
3. 找到启动入口文件
4. 总结依赖来源（requirements.txt / package.json / docker-compose.yml）

第二阶段：环境自检
生成 doctor.ps1：
- 检查 git / python / pip / node / npm / docker 版本
- 检查端口占用
- 检查网络连通性
- 输出清晰结果说明

不要自动安装，只检测。

第三阶段：安全安装脚本
生成 install.ps1：
- 幂等设计（重复执行不会破坏）
- 禁止危险删除（禁止 rm -rf / del / 注册表修改）
- 如必须删除，必须先 echo 说明路径并暂停确认
- 创建 venv 或 node_modules
- 生成 .env.example
- 不要把任何 key 写死

第四阶段：运行与健康检查
生成：
run.ps1
healthcheck.ps1

并说明：
- 成功启动的日志特征
- 访问端口
- 常见报错排查路径

第五阶段：架构解释
用人话解释：
- 项目执行流程
- Agent 调用链
- Prompt 流转路径
- 哪部分可以二次开发

任何需要我手动输入的步骤必须单独提示。

现在开始第一阶段分析。