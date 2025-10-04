# ⚡️ Smith Chart Tools (MATLAB)

Dense, colorful, fully-labeled **Smith charts** in plain MATLAB — **no toolboxes required**.

[![MATLAB](https://img.shields.io/badge/Matlab-R2019b%2B-orange.svg)](#requirements)
[![License](https://img.shields.io/badge/License-Choose%20one-blue.svg)](#license)
[![Status](https://img.shields.io/badge/Status-Active-brightgreen.svg)](#)

---

<p align="center">
  <img src="docs/preview-dual.png" alt="Dual Smith Chart preview" width="75%"/>
</p>

> **What’s inside**
> - `Smith.m` → renders a **dual Smith chart** (Z & Y families), **overlay** or **two panels**  
> - `SmithInteractive.m` → quick UI to input **Z₀**, **f₀**, and **loads ZL**; auto-plots loads & **L-match** solutions with readable on-chart labels

---

## ✨ Features

- **Beautiful, dense grid:** full **r/x** (impedance) and **g/b** (admittance) families
- **Overlay or Two-Panel:** `Smith()` (overlay) or `Smith('two')` (Z|Y side-by-side)
- **Interactive input:** prompts for Z₀, f₀, and a list of loads (e.g., `25+30j, 80-20j`)
- **Smart labeling:**
  - Loads as **`ZLk = jX + R`** (black, larger font)
  - (Two-panel) Admittances as **`YLk = jB + G`**
  - L-match options on-chart: **`MkA`** (series L, shunt C), **`MkB`** (series C, shunt L) with **SI-scaled values**
  - Leader lines & de-overlap logic keep labels readable
- **Axes-handle safe:** draw helpers respect the target axes (works with tiles/subplots)

---

## 🧰 Requirements

- MATLAB **R2019b+** (for `tiledlayout`).  
  _On older releases, replace `tiledlayout/nexttile` with `subplot`._
- No additional toolboxes.

---

## 🚀 Quick Start

1. Clone or download the repo; make sure **both** files are on the MATLAB path.
2. From the MATLAB Command Window:

```matlab
>> SmithInteractive


You’ll be prompted for:

Z0 (Ω), e.g. 50

f0 (Hz), e.g. 2.4e9

ZL list, e.g. 25+30j, 80-20j, 10, 100+50j
(comma/space-separated; i or j are both fine)

Choose Overlay (Z+Y) or Two panels (Z|Y) and enjoy the plot.

🖼️ Direct API
% One overlaid chart (Z + Y)
ax = Smith();

% Two panels (left = Z only, right = Y only)
ax = Smith('two');
Returned handles:

Overlay → ax.Overlay

Two-panel → ax.Z, ax.Y

You can add your own markers/annotations using standard plot/text(ax, ...).

🧪 Example Inputs
Z0: 50
f0: 2.4e9
ZL list: 25+30j, 80-20j, 10, 100+50j
Z-chart: each load labeled like ZL1 = j30 + 25 (black, larger font)

Y-chart (two-panel): YL1 = jB + G at the admittance mirror

Match callouts: M1A / M1B with values, e.g. Ls=3.2 nH, Cp=1.1 pF

⚙️ Customization (edit SmithInteractive.m)
Setting	Purpose	Default
labFS, labFSM	Font size for load & match labels	12, 12
mrkSzL, mrkSzM	Marker size for loads & matches	8, 7
rLblZ	Radius of load labels (outside unit circle)	1.18
rStepZ	Radial step for stacked labels per sector	0.08
nSec	Angular sectors for de-overlap (higher = fewer clashes)	24
rLblM	Radius of match labels (inner ring)	0.30
Y-labeling	Use unnormalized YL = 1/ZL (default) or normalized y = (1/ZL)/(1/Z0)	(code comment)

Want the chart title at the bottom?
Set the title and then:
t = title(axZ, 'Your title here');
set(t, 'Units','normalized');
t.Position(1) = 0.5;      % center
t.Position(2) = -0.12;    % move below axes
t.HorizontalAlignment = 'center';
t.VerticalAlignment   = 'top';
📐 How Matching Works (L-Match @ f₀)

For each load ZL:

Option A (Low-Pass): series L, shunt C

Option B (High-Pass): series C, shunt L

Both land at Γ = 0 (center) at the design frequency f₀. Component values are computed, SI-scaled (pF/nH), and shown on the chart. If a part collapses to ~0 or ∞ it’s omitted in the label.

🩺 Troubleshooting

“Unrecognized function or variable 'Smith'”
Ensure the file is Smith.m, on the path / current folder:
which Smith -all
clear functions; rehash
“Invalid data argument” in plot
Don’t pass the returned struct into helpers; pass axes handles (this repo already does).

Overlapping labels
Increase nSec or rStepZ for loads; adjust rLblM for match callouts; or use two-panel mode.

📁 Structure
.
├─ Smith.m               % Core renderer (overlay or two-panel)
└─ SmithInteractive.m    % UI: inputs, plotting, matching, labeling
Optional: add screenshots in docs/ and update image links.

🤝 Contributing

Issues and PRs welcome! Style guidelines: keep helpers axes-handle safe, prefer clear math, and avoid toolbox dependencies.

📜 License

Add your preferred license (e.g., MIT) in LICENSE.
