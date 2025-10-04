# ⚡️ Smith Chart Tools (MATLAB)

Dense, colorful, fully‑labeled **Smith charts** in plain MATLAB — **no toolboxes required**.

[![MATLAB](https://img.shields.io/badge/MATLAB-R2019b%2B-orange.svg)](#requirements)
[![License](https://img.shields.io/badge/License-Apache--2.0-blue.svg)](#license)
[![Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)](#)

---

## ✨ Features

- **Beautiful, dense grid** — full **r/x** (impedance) and **g/b** (admittance) families.
- **Overlay or Two‑Panel** — `Smith()` (overlay) or `Smith('two')` (Z|Y side‑by‑side).
- **Interactive UI** — `SmithInteractive` prompts for **Z₀**, **f₀**, and **loads ZL**.
- **Smart labeling**
  - Loads on Z chart as **`ZLk = jX + R`** (black, larger font).
  - (Two‑panel) Admittances on Y chart as **`YLk = jB + G`**.
  - Two **L‑match** options per load (**A:** series L + shunt C; **B:** series C + shunt L)
    with **SI‑scaled component values** placed on the chart with leader lines.
- **Axes‑handle safe** — all draw helpers take an axes handle (plays nicely with tiles/subplots).

---

## 🧰 Requirements

- MATLAB **R2019b+** (uses `tiledlayout`).  
  _On older releases, replace `tiledlayout/nexttile` with `subplot`._
- **No additional toolboxes**.

---

## 🚀 Quick Start

1. Ensure **`Smith.m`** and **`SmithInteractive.m`** are on the MATLAB path (or current folder).
2. From the MATLAB Command Window, run:

```matlab
>> SmithInteractive
```

You’ll be prompted for:

- **Z0** (Ω), e.g. `50`
- **f0** (Hz), e.g. `2.4e9`
- **ZL list**, e.g. `25+30j, 80-20j, 10, 100+50j`  
  (comma/space‑separated; `i` or `j` are both fine)

Choose **Overlay (Z+Y)** or **Two panels (Z|Y)** and enjoy the plot.

---

## 🖼️ Direct API (no UI)

```matlab
% One overlaid chart (Z + Y)
ax = Smith();

% Two panels (left = Z only, right = Y only)
ax = Smith('two');
```

**Returned handles**  
- Overlay → `ax.Overlay`  
- Two‑panel → `ax.Z`, `ax.Y`

Add your own markers/annotations with standard calls, e.g. `plot(ax.Z, ...)`, `text(ax.Overlay, ...)`.

---

## 🧪 Example Inputs

```text
Z0: 50
f0: 2.4e9
ZL list: 25+30j, 80-20j, 10, 100+50j
```

What you’ll see:

- **Z chart:** each load labeled as **`ZLk = jX + R`** (black, readable).
- **Y chart (two‑panel):** **`YLk = jB + G`** at the admittance mirror (−Γ).
- **Match callouts:** `MkA` (LP: series L, shunt C) and `MkB` (HP: series C, shunt L) with values like
  `Ls = 3.2 nH, Cp = 1.1 pF`, placed with leader lines to avoid clutter.

---

## ⚙️ Customization (edit `SmithInteractive.m`)

| Setting      | Purpose                                          | Default |
|--------------|---------------------------------------------------|---------|
| `labFS`      | Font size for load labels                         | `12`    |
| `labFSM`     | Font size for match labels                        | `12`    |
| `mrkSzL`     | Marker size (loads)                               | `8`     |
| `mrkSzM`     | Marker size (matches)                             | `7`     |
| `rLblZ`      | Radius of **load** labels (outside unit circle)   | `1.18`  |
| `rStepZ`     | Radial step for stacked labels in a sector        | `0.08`  |
| `nSec`       | Angular sectors for de‑overlap                    | `24`    |
| `rLblM`      | Radius of **match** labels (inner ring)           | `0.30`  |
| Y label mode | Unnormalized `YL = 1/ZL` (default) or normalized `y = (1/ZL)/(1/Z0)` | — |

> **Tip:** Want the title at the bottom?  
> ```matlab
> t = title(axZ, sprintf('Dual Smith Chart (Z0=%g\Omega) — %d load(s)', Z0, N));
> set(t,'Units','normalized'); t.Position(1)=0.5; t.Position(2)=-0.12;
> t.HorizontalAlignment='center'; t.VerticalAlignment='top';
> ```

---

## 📐 How Matching Works

For each load `ZL` at frequency `f0`, we compute classic single‑frequency **L‑matches**:

- **Option A (Low‑Pass)** — **series L**, **shunt C**  
- **Option B (High‑Pass)** — **series C**, **shunt L**

Both synthesize **Γ = 0** (center) at **`f0`**. Component values are SI‑scaled (pF, nH). If a part collapses to ~0 or ∞, it’s omitted from the label.

---

## 🩺 Troubleshooting

- **“Unrecognized function or variable 'Smith'”**  
  Make sure the file is **`Smith.m`**, on the path/current folder:  
  ```matlab
  which Smith -all
  clear functions; rehash
  ```
- **Empty left panel / everything draws on one axes**  
  Use the provided files — all drawing is **axes‑handle based**.
- **“Invalid data argument” in `plot`**  
  Pass a real **axes handle** to helpers. Don’t pass the returned struct itself.

---

## 📁 Structure

```
.
├─ Smith.m               % Core renderer (overlay or two‑panel)
└─ SmithInteractive.m    % UI: inputs, plotting, matching, labeling
```

---

## 📜 License

This project is licensed under the **Apache License 2.0** — see the [`LICENSE`](./LICENSE) file for details.
