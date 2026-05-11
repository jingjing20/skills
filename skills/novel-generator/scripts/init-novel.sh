#!/bin/bash
# 女频短中篇小说初始化脚本
# 用法: ./init-novel.sh <小说名称> [--clean]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

usage() {
    cat << EOF
用法: $(basename "$0") <小说名称> [选项]

为一部女频短中篇小说初始化独立工作区。

参数:
  小说名称     小说的名称

选项:
  --clean      清除该小说工作区内已有输出并重新初始化
  -h, --help   显示此帮助信息

示例:
  $(basename "$0") 春风不渡
  $(basename "$0") 春风不渡 --clean

EOF
}

log_info() { echo -e "${GREEN}[信息]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[警告]${NC} $1"; }
log_step() { echo -e "${CYAN}[步骤]${NC} $1"; }

NOVEL_NAME=""
CLEAN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean) CLEAN=true; shift ;;
        -h|--help) usage; exit 0 ;;
        -*) echo -e "${RED}[错误]${NC} 未知选项: $1"; usage; exit 1 ;;
        *)
            if [ -z "$NOVEL_NAME" ]; then
                NOVEL_NAME="$1"
            else
                echo -e "${RED}[错误]${NC} 意外参数: $1"; usage; exit 1
            fi
            shift ;;
    esac
done

if [ -z "$NOVEL_NAME" ]; then
    echo -e "${RED}[错误]${NC} 请提供小说名称"
    usage
    exit 1
fi

OUTPUT_DIR="$SKILL_DIR/output/$NOVEL_NAME"

echo ""
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${CYAN}  女频短中篇小说生成器 - 初始化工作区${NC}"
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo ""
echo -e "  小说名称: ${GREEN}《${NOVEL_NAME}》${NC}"
echo -e "  工作目录: ${GREEN}${OUTPUT_DIR}${NC}"
echo -e "  清除旧数据: $([ "$CLEAN" = true ] && echo "${YELLOW}是${NC}" || echo "否")"
echo ""

if [ -d "$OUTPUT_DIR" ] && [ "$CLEAN" = false ]; then
    log_warn "工作区已存在。继续使用现有文件。需要重置时加 --clean。"
else
    if [ "$CLEAN" = true ]; then
        log_step "清除该小说旧工作区..."
        rm -rf "$OUTPUT_DIR"
    fi

    log_step "创建小说工作区..."
    mkdir -p "$OUTPUT_DIR"

    cat > "$OUTPUT_DIR/STATE.md" << HEREDOC
# 创作状态

## 当前进度
- 当前章节：未开始
- 已完成字数：0
- 目标总字数：20000-50000
- 预计总章节：8-25
- 单章字数：2000-3000（用户明确要求短章时 1200-1600）
- 免费章数：待大纲确认（默认前 3-5 章）
- 第一付费节点：第 X 章末（待大纲确认）
- 剩余章节：待大纲确认

## 上一章结尾
暂无

## 下一章目标
- 核心事件：待大纲确认
- 第一句信息缺口：待大纲确认
- 前300字任务：待大纲确认
- 本章爽点（引用 PUNCHES.md 编号）：待大纲确认
- 本章锤点：待大纲确认
- 章末卡点（引用 HOOKS.md 编号或新增）：待大纲确认
- 可切片名场面：待大纲确认
- 情绪推进：待大纲确认
- 关系变化：待大纲确认
- 必须避免：长篇化、关系跳步、女主失能、章末降温、开篇无信息缺口、连续只虐不反抗

## 待处理事项
- 未回收伏笔：暂无
- 未解决误会：暂无
- 未消费爽点（剩余编号）：暂无
- 必须出场角色：待设定
HEREDOC

    cat > "$OUTPUT_DIR/CHARACTERS.md" << 'HEREDOC'
# 角色档案

记录角色状态、动机、位置和关系阶段。

每个核心角色必须填齐三锚点（视觉 / 语言 / 情绪）。未填齐的角色不允许参与章节生成。

## 模板

```markdown
## 角色名

**首次出场**:
**身份**:
**阵营/功能**:
**当前状态**:
**当前位置**:
**当前目标**:
**内在伤口**:
**与女主关系**:
**关系阶段**:

### 三锚点（必填）

**视觉锚点**（至少 2 条，可重复触发）：
-
-

**语言锚点**（至少 2 条，可文字化复用）：
-
-

**情绪锚点**（至少 2 条，特定场景触发特定反应）：
-
-

### 经历摘要
- 第XX章：
```
HEREDOC

    cat > "$OUTPUT_DIR/PLOT_POINTS.md" << 'HEREDOC'
# 情节与伏笔档案

记录关键事件、情感转折、伏笔埋设与回收。

## 伏笔追踪

| 编号 | 类型 | 埋设章节 | 回收章节 | 状态 | 描述 |
| --- | --- | --- | --- | --- | --- |

## 关键转折

| 章节 | 类型 | 影响 |
| --- | --- | --- |
HEREDOC

    cat > "$OUTPUT_DIR/STORY_BIBLE.md" << 'HEREDOC'
# 故事圣经

记录背景设定、关系规则、禁改设定和结局承诺。

## 背景设定

## 关系规则

## 禁改设定

## 结局承诺
HEREDOC

    cat > "$OUTPUT_DIR/PUNCHES.md" << 'HEREDOC'
# 爽点池

记录全篇所有爽点的设计、消费状态和读者代偿点。

## 爽点全表

| 编号 | 类型 | 触发场景 | 属于哪一锤 | 谁打谁脸 / 谁付出 / 谁意识到 | 读者代偿点 | 章节位置 | 状态 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| P-001 |  |  | 受虐 / 小反抗 / 打脸 / 升级反击 |  |  |  | pending |

## 爽点类型参考

- 打脸 / 反转 / 占有欲外显 / 跪舔追妻 / 装柔实强 / 旧账清算 / 公开偏爱 / 身份反转

## 密度要求（按 20 章为例）

- 小爽点：12-15 个（几乎每章 1 个）
- 中爽点：4-6 个（每 3-4 章 1 个）
- 大爽点：2-3 个（第 1 付费节点 / 中段反转 / 结局前）
- 前 3 章必须至少有 1 个小反抗、留证、退路或旁人替读者发声

## 消费规则

- 状态：pending（未消费）/ used（已消费）/ dropped（已废弃）
- 写完一章后，把本章消费的爽点状态改为 used，并在状态后写明出现在哪章。
HEREDOC

    cat > "$OUTPUT_DIR/HOOKS.md" << 'HEREDOC'
# 卡点池（章末钩子库）

记录全篇章末卡点的类型、落点和使用情况。

## 卡点全表

| 编号 | 类型 | 落点画面 | 强度 | 读者不看下一章会缺什么 | 章节位置 | 状态 |
| --- | --- | --- | --- | --- | --- | --- |
| H-001 |  |  |  |  |  | pending |

## 卡点类型参考

- 人物登场 / 称呼变化 / 信息炸弹 / 动作未完 / 反转预告 / 误会触发 / 旧物出现 / 决定瞬间

## 强度要求

| 章节位置 | 卡点强度要求 |
| --- | --- |
| 第 1 章 | 极强 |
| 免费章末（含第一付费节点） | 极强 |
| 关系升温段 | 中-强 |
| 大爽点章、火葬场段 | 强 |
| 结局前一章 | 极强 |
| 结局章 | 不卡，做落点和回收 |

## 铁律

- 前 6 章每章卡点必须达到"极强"或"强"。
- 不允许章末降温。
- 第一付费节点的卡点必须制造"不付费就受不了"的信息缺口。
- 第一付费节点必须卡在高潮前一秒，不能放在真相完全揭晓之后。
HEREDOC

    cat > "$OUTPUT_DIR/GOLDEN-LINES.md" << 'HEREDOC'
# 金句池

记录全篇可截图传播的金句。金句直接作为短视频物料和落地页文案。

## 金句风格示范（提示词阶段填入 3 句）

1.
2.
3.

## 金句全表

| 编号 | 章节 | 内容 | 类型（章末 / 对白 / 内心） | 是否计划在结局回收 |
| --- | --- | --- | --- | --- |
| G-001 |  |  |  |  |

## 产出规则

- 每章至少产出 1 句金句候选。
- 金句必须有人物名 / 称呼 / 关系信息嵌入，可独立传播。
- 至少 1/3 的金句出现在章末（与卡点结合）。
- 至少 1 句金句在结局回收（与第 1 章呼应）。
HEREDOC

    cat > "$OUTPUT_DIR/ERRORS.md" << 'HEREDOC'
# 生成错误日志

记录连续性、情绪线、关系推进、爽点 / 卡点 / 金句、篇幅控制问题。

## 第 1 章回写日志

短中篇的第 1 章必须重写 3 次：大纲完成后 / 第 10 章完成后 / 结局完成后。每次回写在此记录。

| 触发点 | 时间 | 改了什么 | 为什么改 |
| --- | --- | --- | --- |

## 失败记录模板

```markdown
## [NOVEL-ERR-YYYYMMDD-XXX] 问题类型

**记录时间**:
**章节**:
**严重程度**: low | medium | high | critical
**状态**: pending | resolved

### 问题

### 影响

### 修正

### 避免再次发生
```
HEREDOC

    touch "$OUTPUT_DIR/.gitkeep"
fi

echo ""
log_info "《${NOVEL_NAME}》工作区初始化完成。"
echo ""
echo "后续步骤:"
echo "  1. 描述小说方向、题材、钩子手法、核心关系和结局倾向"
echo "  2. 生成创作提示词到 output/${NOVEL_NAME}/创作提示词.md"
echo "     （提示词阶段必须给出爽点池首批 8 条 + 卡点池首批 6 条 + 金句风格示范 3 句）"
echo "  3. 生成大纲到 output/${NOVEL_NAME}/大纲.md"
echo "     （大纲必须含每章爽点 / 章末卡点 / 付费节点）"
echo "  4. 逐章生成，每章 2000-3000 字"
echo "     （每章必须落地爽点、必须章末卡点、必须产出金句）"
echo ""
echo "状态文件:"
echo "  $OUTPUT_DIR/STATE.md"
echo "  $OUTPUT_DIR/CHARACTERS.md"
echo "  $OUTPUT_DIR/PLOT_POINTS.md"
echo "  $OUTPUT_DIR/STORY_BIBLE.md"
echo "  $OUTPUT_DIR/PUNCHES.md       爽点池"
echo "  $OUTPUT_DIR/HOOKS.md         卡点池"
echo "  $OUTPUT_DIR/GOLDEN-LINES.md  金句池"
echo "  $OUTPUT_DIR/ERRORS.md"
echo ""
