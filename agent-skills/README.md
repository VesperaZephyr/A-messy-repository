# agent-skills

工作区技能（agent / coding-agent skills）集合目录。

## 约定

- 每个技能放在**与技能名同名的子目录**下，例如 `mathtranslation/`、`latex-book-retypeset/`。
- 每个子目录本身就是一个独立的可发布技能：含 `SKILL.md`（`name`/`description` frontmatter）、`references/`、`scripts/`、`assets/` 等。
- 技能内的 `.gitattributes` / `.gitignore` 只作用于该子树，不影响仓库其他部分。
- 技能源文件同时保留在本地 `~/.workbuddy/skills/` 下供 IDE 直接加载；本目录是其可分享的镜像。

## 已收录

| 技能 | 用途 |
|---|---|
| `mathtranslation` | 数学书中文 LaTeX 翻译 / 审校（统一技能，整合四类流程：翻译、编译与可视化验证、硬编码引用转可点击交叉引用、旧模板迁移到 mathtranslation.cls v3.1） |
