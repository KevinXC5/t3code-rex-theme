<div align="center">

# Rex Theme for T3 Code

**A crisp, terminal-native [Rex](https://rex.superlogical.com)-inspired theme for [T3 Code](https://t3.codes) — featuring a two-tier obsidian shell, an inset `12px` rounded workspace pane with subtle glass borders, `Merino Dark` & `Merino Light` palettes, frosted active tab pills, `Maple Mono NF CN` terminal code blocks, and a 6-tier comet-laser effort selector.**

[English](README.md) · [简体中文](README_zh.md)

<p>
  <img alt="T3 Code Theme" src="https://img.shields.io/badge/T3_Code-Custom_Theme-2F81F7?style=flat-square">
  <img alt="Appearance" src="https://img.shields.io/badge/Appearance-Dark_%26_Light-0F1114?style=flat-square">
  <img alt="CSS Budget" src="https://img.shields.io/badge/CSS-49.6k_%2F_50k_chars-3FB950?style=flat-square">
  <img alt="License" src="https://img.shields.io/badge/License-MIT-58A6FF?style=flat-square">
</p>

<img src="assets/hero-preview.svg" alt="Rex Theme Showcase" width="100%">

</div>

---

## Quick Install

### macOS / Linux (One-Liner)

```bash
# Install into ~/.t3/userdata/themes/rex.json
curl -fsSL https://raw.githubusercontent.com/KevinXC5/t3code-rex-theme/main/install.sh | bash

# Or install and automatically activate as defaultTheme
curl -fsSL https://raw.githubusercontent.com/KevinXC5/t3code-rex-theme/main/install.sh | bash -s -- --activate
```

### Windows (PowerShell)

```powershell
# Install into %USERPROFILE%\.t3\userdata\themes\rex.json
irm https://raw.githubusercontent.com/KevinXC5/t3code-rex-theme/main/install.ps1 | iex

# Or install and activate automatically
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/KevinXC5/t3code-rex-theme/main/install.ps1))) -Activate
```

### Manual Import (T3 Code UI)

1. Download [`rex.json`](rex.json) (or copy it to `~/.t3/userdata/themes/rex.json`).
2. Open **T3 Code → Settings → Appearance**.
3. Import or select **Rex** (supports **Dark**, **Light**, and **System** appearance modes).

---

## Design Details

### 1. Two-Tier Obsidian Shell & Inset Rounded Workspace Pane

Faithfully translates Rex Terminal's `BlendTheme` + `Merino Dark` / `Merino Light` depth hierarchy into T3 Code:

| Role | Dark Mode (`Merino Dark`) | Light Mode (`Merino Light`) | Purpose |
| :--- | :---: | :---: | :--- |
| **Window Shell & Sidebar** | `#0F1114` | `#EEF1F5` | Outer obsidian-slate frame & thread navigation |
| **Right Workspace Pane** | `#1B1F23` | `#FFFFFF` | Inset `12px` rounded card with `1px` crisp rim & inner specular edge |
| **Terminal & Code Blocks** | `#0D1117` | `#F6F8FA` | Embedded terminal-grade code blocks & integrated terminal drawer |
| **Composer Card** | `#22272E` | `#FFFFFF` | Elevated glass-slate input card with sapphire focus halo |
| **Primary Accent** | `#2F81F7` | `#0969DA` | Rex cursor blue — send squircle, links, focus rings, trees & diffs |
| **Pin Indicator** | `#FF7B72` | `#CF222E` | Merino ANSI coral-red pin icon |

### 2. Frosted Tab Pills & Framed Right Panel

- **Inset `12px` Right Workspace Panel**: On desktop layouts, `main[data-slot="sidebar-inset"]` floats inside the `#0F1114` window shell with `7px` outer gutters, `12px` rounded corners, a `1px` translucent glass border (`rgba(255,255,255,0.09)` in dark mode), and a whisper-subtle top inner specular edge.
- **Frosted Active Sidebar Pill**: Selected threads adopt Rex's capsule-style active tab treatment (`linear-gradient` frosted fill + subtle top highlight + hairline stroke).
- **Clean Typography & Embedded Terminal Code**: Pairs crisp `SF Pro Text` / `Inter` technical UI typography with `Maple Mono NF CN` (`JetBrains Mono` / `SF Mono` fallback) for code blocks and integrated terminals.

### 3. Unified Sapphire Accent & UI Polish

- **`T3 [Code]` Brand Pill**: Restyles the top-left home link into `T3` + an electric sapphire `Code` pill badge.
- **Unified Selection, Trees & Diffs**: Unifies text `::selection`, `@pierre/trees` active rows, `@pierre/diffs` modified markers/carets, citation chips, and `New thread` button into Rex's `#2F81F7` / `#58A6FF` spectrum.
- **Full-Color Sidebar Icons & Clean Inputs**: Preserves full-color provider/model badges in the sidebar and strips double inner outlines from sidebar search and dropdown combobox inputs.

### 4. Redesigned Model Picker & 6-Tier Comet-Laser Effort System

<img src="assets/effort-tiers.svg" alt="6-Tier Thinking Level Spectrum" width="100%">

- **Horizontal Segmented Effort Bar**: Moves the reasoning selector to a wrapped bottom bar (`632px` popover, `360px` model list height) so 6-tier models (`Low` through `Ultra TURBO`) never clip horizontally.
- **Merino ANSI Spectrum + Comet Laser Rims**: Syncs `14px`/`15px` glyphs and dual-layer `background-clip: padding-box, border-box` flowing borders across the picker and bottom composer pill:
  - **Low / Minimal**: Merino Green (`#3FB950` / `#1A7F37`) + Feather glyph
  - **Medium**: Rex Sapphire (`#58A6FF` / `#0969DA`) + Dual-Sparkle glyph
  - **High**: Merino Coral Red (`#FF7B72` / `#CF222E`) + Flame glyph
  - **Extra High**: Merino Amber (`#E3B341` / `#9D5C00`) + Bolt glyph
  - **Max**: Merino Violet (`#BC8CFF` / `#8250DF`) + Crown glyph
  - **Extra / Ultra / Ultrathink**: Comet spectrum bolt + italic `TURBO` badge + full-spectrum flowing laser border

---

## Customize & Build from Source

The repository keeps a cleanly commented CSS source in [`src/theme.css`](src/theme.css) along with a zero-dependency build script [`scripts/build.py`](scripts/build.py) that safely minifies comments/whitespace and validates T3 Code's **50,000-character CSS budget**.

```bash
git clone https://github.com/KevinXC5/t3code-rex-theme.git
cd t3code-rex-theme

# Edit src/theme.css, then rebuild and validate rex.json
python3 scripts/build.py

# Verify rex.json matches src/theme.css
python3 scripts/build.py --check
```

---

## License

[MIT](LICENSE)
