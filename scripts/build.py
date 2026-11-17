#!/usr/bin/env python3
"""将 src/theme.css 安全压缩并校验打包为 rex.json。"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC_CSS = ROOT / "src" / "theme.css"
OUT_JSON = ROOT / "rex.json"
MAX_CSS_CHARS = 50_000


def minify_css(src: str) -> str:
    """安全移除 CSS 注释与多余空白，保留引号字符串与 calc() 运算空格。"""
    # 1. 移除引号外的 /* ... */ 注释
    out: list[str] = []
    i, n = 0, len(src)
    in_str: str | None = None
    while i < n:
        ch = src[i]
        if in_str:
            out.append(ch)
            if ch == "\\" and i + 1 < n:
                out.append(src[i + 1])
                i += 2
                continue
            if ch == in_str:
                in_str = None
            i += 1
        elif ch in ('"', "'"):
            in_str = ch
            out.append(ch)
            i += 1
        elif ch == "/" and i + 1 < n and src[i + 1] == "*":
            end = src.find("*/", i + 2)
            if end == -1:
                break
            i = end + 2
        else:
            out.append(ch)
            i += 1
    no_comments = "".join(out)

    # 2. 按引号切分，仅在引号外压缩空白
    parts: list[tuple[bool, str]] = []
    i, n = 0, len(no_comments)
    in_str = None
    buf: list[str] = []
    while i < n:
        ch = no_comments[i]
        if in_str:
            buf.append(ch)
            if ch == "\\" and i + 1 < n:
                buf.append(no_comments[i + 1])
                i += 2
                continue
            if ch == in_str:
                parts.append((True, "".join(buf)))
                buf = []
                in_str = None
            i += 1
        elif ch in ('"', "'"):
            if buf:
                parts.append((False, "".join(buf)))
                buf = []
            in_str = ch
            buf.append(ch)
            i += 1
        else:
            buf.append(ch)
            i += 1
    if buf:
        parts.append((bool(in_str), "".join(buf)))

    res: list[str] = []
    for is_quoted, chunk in parts:
        if is_quoted:
            res.append(chunk)
            continue
        c = re.sub(r"\s+", " ", chunk)
        c = re.sub(r"\s*\{\s*", "{", c)
        c = re.sub(r"\s*\}\s*", "}\n", c)
        c = re.sub(r"\s*;\s*", ";", c)
        c = re.sub(r";\}", "}", c)
        c = re.sub(r",\s+", ",", c)
        res.append(c)

    joined = "".join(res).strip()

    # 3. 去除声明冒号后的多余空格（仅限引号外）
    out2: list[str] = []
    i, n = 0, len(joined)
    in_str = None
    while i < n:
        ch = joined[i]
        if in_str:
            out2.append(ch)
            if ch == "\\" and i + 1 < n:
                out2.append(joined[i + 1])
                i += 2
                continue
            if ch == in_str:
                in_str = None
            i += 1
        elif ch in ('"', "'"):
            in_str = ch
            out2.append(ch)
            i += 1
        elif ch == ":" and i + 1 < n and joined[i + 1] == " ":
            out2.append(":")
            i += 2
        else:
            out2.append(ch)
            i += 1
    return "".join(out2).strip()


def main() -> int:
    parser = argparse.ArgumentParser(description="Build or validate rex.json")
    parser.add_argument("--check", action="store_true", help="Only validate without writing")
    args = parser.parse_args()

    raw_css = SRC_CSS.read_text(encoding="utf-8")
    compact_css = minify_css(raw_css)

    brace_diff = compact_css.count("{") - compact_css.count("}")
    if brace_diff != 0:
        raise SystemExit(f"CSS brace mismatch: diff={brace_diff}")
    if len(compact_css) > MAX_CSS_CHARS:
        raise SystemExit(f"CSS exceeds T3 Code {MAX_CSS_CHARS} char limit: {len(compact_css)}")

    theme = json.loads(OUT_JSON.read_text(encoding="utf-8"))
    if args.check:
        if theme.get("css") != compact_css:
            raise SystemExit("rex.json css is out of sync with src/theme.css")
        print(f"OK: {len(compact_css)} chars (limit {MAX_CSS_CHARS}), braces balanced.")
        return 0

    theme["css"] = compact_css
    OUT_JSON.write_text(json.dumps(theme, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Built {OUT_JSON.name}: css={len(compact_css)}/{MAX_CSS_CHARS} chars, braces balanced.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
