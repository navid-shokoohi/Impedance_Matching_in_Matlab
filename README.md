Smith Chart Tools (MATLAB)

Dense, colorful, fully-labeled Smith charts in plain MATLAB — no toolboxes required.

This repo contains:

Smith.m — draws a dual Smith chart (Z and Y families) either overlaid or in two side-by-side panels. All helpers are axes-handle safe.

SmithInteractive.m — a small UI that asks for Z₀, f₀, and a list of loads ZL; then:

plots each load as ZLk = jX + R on the Z-chart,

(two-panel only) plots YLk = jB + G on the Y-chart,

computes two L-match options per load (A: series L + shunt C; B: series C + shunt L),

places readable on-chart match labels (MkA/MkB) with component values (SI units),

uses leader lines and de-overlap logic to keep labels legible.

Requirements

MATLAB R2019b+ (uses tiledlayout).
If you’re on an older release, replace tiledlayout/nexttile with subplot.

No additional toolboxes.

Quick Start

Put both files on your MATLAB path (or in the current folder).

From the MATLAB command window:

>> SmithInteractive


You’ll be prompted for:

Z0 (Ω), e.g. 50

f0 (Hz), e.g. 2.4e9

ZL list, e.g. 25+30j, 80-20j, 10, 100+50j
(comma/space-separated; i or j both work)

Choose Overlay (Z+Y) or Two panels (Z|Y).

Direct Usage (without UI)
% One overlaid chart (Z + Y)
ax = Smith();

% Two panels: left = Z only, right = Y only
ax = Smith('two');


Smith returns axes handles:

overlay mode → ax.Overlay

two-panel mode → ax.Z and ax.Y

You can plot on the returned axes with standard MATLAB plot/text calls.

What You’ll See

Z chart: load markers + labels like ZL1 = j30 + 25 (black, larger font).

Y chart (two-panel): admittance markers + labels like YL1 = jB + G (black).

Match callouts:

MkA (low-pass L-match: series L, shunt C)

MkB (high-pass L-match: series C, shunt L)
Each shows compact values, e.g. Ls=3.2 nH, Cp=1.1 pF, placed on an inner ring with leader lines.

Input Format Tips

Complex loads use normal MATLAB syntax: 25+30j, 80-20j, 10, …

Scientific notation OK for f0: 2.45e9, 915e6, etc.

Customize (edit SmithInteractive.m)

Label sizes & markers

labFS / labFSM — font sizes for load and match labels

mrkSzL / mrkSzM — marker sizes

ZL label placement (outside the circle)

rLblZ — base radius (e.g., 1.18)

rStepZ — radial step when stacking labels within a sector

nSec — number of angular sectors (increase to reduce overlap)

Match label placement (inner ring)

rLblM — radius for MkA/MkB callouts (e.g., 0.30)

Y-panel admittance label

Currently unnormalized: YL = 1/ZL

For normalized admittance, use: YL = (1/ZL)/(1/Z0)

Optional: Put the title at the bottom
t = title(axZ, sprintf('Dual Smith Chart (Z0=%g\\Omega) — %d load(s)', Z0, N));
set(t,'Units','normalized');
t.Position(1) = 0.5;            % center
t.Position(2) = -0.12;          % below axes; tweak as needed
t.HorizontalAlignment = 'center';
t.VerticalAlignment   = 'top';


For a figure-wide caption across both tiles, use annotation('textbox', ...).

How Matching Is Computed

For each ZL at f0 we compute the classic single-frequency L-match:

Option A (LP): series L, shunt C

Option B (HP): series C, shunt L

Both bring the network to Γ = 0 (center) at f0. If a component value collapses to ~0 or ∞, it’s omitted in the label.

Troubleshooting

“Unrecognized function or variable 'Smith'”
Ensure the file is named Smith.m and is on the path/current folder:

which Smith -all
clear functions; rehash


Empty left panel / everything draws on one axes
Use the provided files — all draw calls are axes-handle based.

“Invalid data argument” in plot
Pass a real axes handle to draw helpers; don’t pass the returned struct itself.

Folder Layout
.
├── Smith.m               % Chart renderer (overlay or two-panel)
└── SmithInteractive.m    % UI: inputs, plotting, matching, labeling

License
