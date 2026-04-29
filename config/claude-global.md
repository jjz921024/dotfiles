# 全局编码规范

## 底线规则 (Always)

1. **注释 Why 不写 What** — 代码本身说明做了什么，注释解释为什么这么做
2. **测试覆盖** — 每个 pub 函数至少一个 happy path + 每个错误变体
3. **简洁 > 抽象** — 三个类似行 > 一次过早抽象；不添加 speculative 工具/辅助函数

---

## Rust 规范

### 命名
| 类别 | 风格 | 示例 |
|------|------|------|
| 类型/枚举/trait | `PascalCase` | `UserProfile`, `HttpStatus` |
| 函数/变量/模块 | `snake_case` | `parse_request`, `max_retries` |
| 常量 | `SCREAMING_SNAKE_CASE` | `MAX_CONNECTIONS` |
| 生命周期 | `'a`, `'ctx` | — |

### 代码组织
- 公共 API 在 crate 根 `pub use` 统一重导出
- `unwrap`/`expect` 仅允许在测试或可证明的不可变场景

### use 语句导入规则
- 类型直接导入 — `use crate::config::Config`，而非 `use crate::config` 然后 `config::Config`
- 函数导入模块 — 导入模块（到具体子模块）而非裸函数，调用处写作 `module::function`。例外：Prelude 常用函数（如 `std::io::stdout`）可直接导入
- 同名类型 — 使用一级模块路径或 `as` 别名消除歧义，如 `use std::io` 后 `io::Error`，或 `use std::io::Error as IoError`
- 导入顺序 — `std → 外部crate → 本地`，组间空行分隔
- 禁止通配导入 — 避免 `use ...::*`（测试模块除外）

---

## Go 规范

### 命名
| 类别 | 风格 | 示例 |
|------|------|------|
| 导出 (public) | `PascalCase` | `ParseRequest`, `User` |
| 非导出 (private) | `camelCase` | `parseRequest`, `maxRetries` |
| 包名 | 简短小写，单数 | `parser`, `config` |
| 接口 | 方法名 + `er` | `Parser`, `Reader`, `Handler` |
| 文件命名 | `snake_case` | `user_profile.go` |

### 代码组织
- 按职责分包，避免 `utils/`、`common/`、`helpers/`
- 包级变量用 `var`，常量用 `const`
- 返回 `(result, error)`，绝不 panic（仅 main/init 可 `log.Fatal`）

---

## 通用 (跨语言)

- **每次修改代码后，使用对应语言的 formatter 格式化代码**（Rust: `cargo fmt`，Go: `go fmt`）
- 不在已提交的代码中用 `todo!()` / `FIXME`
- 测试不依赖顺序，不 mock 真实数据库/网络（除非集成测试）

# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
