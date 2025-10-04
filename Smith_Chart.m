%function Smith(mode)
function ax = Smith(mode)
% Smith.m — Dense, colorful, fully-labeled Smith chart(s) with handle-safe helpers.
% No toolboxes required. Works on older MATLAB.
%
% Usage:
%   Smith()         % one overlaid chart (Z + Y)
%   Smith('two')    % two panels side-by-side (Z-only | Y-only)

if nargin<1, mode = 'overlay'; end

% -------- Appearance controls --------
fs      = 8;        % base font size for labels
lwMaj   = 0.9;      % line width major
lwMin   = 0.4;      % line width minor

% Normalized families (density controls)
rMaj = [0 0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 50 100];
rMin = [0.01 0.02 0.03 0.04 0.06 0.08 0.12 0.15 0.25 0.4 0.6 0.8 1.5 2.5 4 7 15 30 70];
xMaj = [0.05 0.1 0.2 0.3 0.5 1 2 3 5 10 20 50 100];  xMin = rMin;
gMaj = rMaj;  gMin = rMin;   % Y mirrors Z families
bMaj = xMaj;  bMin = xMin;

% Colors
col_rMaj = [0.15 0.35 0.95];  col_rMin = [0.70 0.80 1.00];
col_xpMaj= [0.90 0.20 0.20];  col_xpMin= [1.00 0.75 0.75];
col_xnMaj= [0.10 0.65 0.10];  col_xnMin= [0.70 0.95 0.70];

col_gMaj = [0.60 0.20 0.80];  col_gMin = [0.85 0.70 0.95];
col_bpMaj= [0.95 0.55 0.15];  col_bpMin= [0.99 0.84 0.64];
col_bnMaj= [0.05 0.60 0.60];  col_bnMin= [0.65 0.90 0.90];

col_axis = [0 0 0];

% Figure
figure('Color','w','Name','Smith Chart');
if strcmpi(mode,'two')
    tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

    % ---- Left: Z-only ----
    ax1 = nexttile; hold(ax1,'on'); axis(ax1,'equal'); axis(ax1,'off');
    baseCircle(ax1, col_axis);
    set(ax1,'XLim',[-1.65 1.65],'YLim',[-1.15 1.05]);   % room for legends at ±1.5
    draw_const_r(ax1, rMaj, col_rMaj, lwMaj); draw_const_r(ax1, rMin, col_rMin, lwMin);
    draw_const_x(ax1, xMaj, +1, col_xpMaj, lwMaj); draw_const_x(ax1, xMin, +1, col_xpMin, lwMin);
    draw_const_x(ax1, xMaj, -1, col_xnMaj, lwMaj); draw_const_x(ax1, xMin, -1, col_xnMin, lwMin);
    add_labels_r(ax1, rMaj, col_rMaj, fs);
    add_labels_x(ax1, +1, xMaj, col_xpMaj, fs);
    add_labels_x(ax1, -1, xMaj, col_xnMaj, fs);
    corner_and_legend(ax1, fs, ...
        col_rMaj, col_xpMaj, col_xnMaj, ...
        col_gMaj, col_bpMaj, col_bnMaj, 'z');
    title(ax1,'Z-Smith (r,x)');

    % ---- Right: Y-only ----
    ax2 = nexttile; hold(ax2,'on'); axis(ax2,'equal'); axis(ax2,'off');
    baseCircle(ax2, col_axis);
    set(ax2,'XLim',[-1.65 1.65],'YLim',[-1.15 1.05]);
    draw_const_g(ax2, gMaj, col_gMaj, lwMaj); draw_const_g(ax2, gMin, col_gMin, lwMin);
    draw_const_b(ax2, bMaj, +1, col_bpMaj, lwMaj); draw_const_b(ax2, bMin, +1, col_bpMin, lwMin);
    draw_const_b(ax2, bMaj, -1, col_bnMaj, lwMaj); draw_const_b(ax2, bMin, -1, col_bnMin, lwMin);
    add_labels_g(ax2, gMaj, col_gMaj, fs);
    add_labels_b(ax2, +1, bMaj, col_bpMaj, fs);
    add_labels_b(ax2, -1, bMaj, col_bnMaj, fs);
    corner_and_legend(ax2, fs, ...
        col_rMaj, col_xpMaj, col_xnMaj, ...
        col_gMaj, col_bpMaj, col_bnMaj, 'y');
    title(ax2,'Y-Smith (g,b)');
    ax = struct('Z', ax1, 'Y', ax2);

else
    % ---- Single overlaid chart (Z + Y) ----
    axh = axes; hold(axh,'on'); axis(axh,'equal'); axis(axh,'off');
    baseCircle(axh, col_axis);
    set(axh,'XLim',[-1.65 1.65],'YLim',[-1.15 1.05]);

    % Z-grid
    draw_const_r(axh, rMaj, col_rMaj, lwMaj); draw_const_r(axh, rMin, col_rMin, lwMin);
    draw_const_x(axh, xMaj, +1, col_xpMaj, lwMaj); draw_const_x(axh, xMin, +1, col_xpMin, lwMin);
    draw_const_x(axh, xMaj, -1, col_xnMaj, lwMaj); draw_const_x(axh, xMin, -1, col_xnMin, lwMin);
    add_labels_r(axh, rMaj, col_rMaj, fs);
    add_labels_x(axh, +1, xMaj, col_xpMaj, fs);
    add_labels_x(axh, -1, xMaj, col_xnMaj, fs);

    % Y-grid
    draw_const_g(axh, gMaj, col_gMaj, lwMaj); draw_const_g(axh, gMin, col_gMin, lwMin);
    draw_const_b(axh, bMaj, +1, col_bpMaj, lwMaj); draw_const_b(axh, bMin, +1, col_bpMin, lwMin);
    draw_const_b(axh, bMaj, -1, col_bnMaj, lwMaj); draw_const_b(axh, bMin, -1, col_bnMin, lwMin);
    add_labels_g(axh, gMaj, col_gMaj, fs);
    add_labels_b(axh, +1, bMaj, col_bpMaj, fs);
    add_labels_b(axh, -1, bMaj, col_bnMaj, fs);

    corner_and_legend(axh, fs, ...
        col_rMaj, col_xpMaj, col_xnMaj, ...
        col_gMaj, col_bpMaj, col_bnMaj, 'both');
    title(axh,'Dual Smith Chart: Z (r,x) + Y (g,b)','FontSize',fs+2);

    % return handle struct (DO THIS LAST)
    ax = struct('Overlay', axh);
end
end

% ==================== Drawing primitives (handle-safe) ====================

function baseCircle(ax, col_axis)
    th = linspace(0,2*pi,1536);
    uc = exp(1j*th);
    plot(ax, real(uc), imag(uc), 'k-', 'LineWidth', 1.25);
    plot(ax, [-1 1],[0 0],':','Color',col_axis,'LineWidth',0.8);
    plot(ax, [0 0],[-1 1],':','Color',col_axis,'LineWidth',0.8);
end

function draw_const_r(ax, rvals, col, lw)
% Constant resistance circles (normalized r >= 0):
% Center c = r/(1+r), radius R = 1/(1+r)
    th = linspace(0,2*pi,721);
    for r = rvals
        if r < 0, continue; end
        c = r/(1+r);
        R = 1/(1+r);
        z = c + R*exp(1j*th);
        m = abs(z) <= 1 + 1e-6;
        plot(ax, real(z(m)), imag(z(m)), '-', 'LineWidth', lw, 'Color', col);
    end
end

function draw_const_x(ax, xvals, sgn, col, lw)
% Constant reactance circles (normalized x):
% Center (1, 1/x), radius 1/|x|
    th = linspace(0,2*pi,721);
    for x = xvals
        yc = 1/(sgn*x);
        Rc = 1/abs(x);
        z = (1 + Rc*cos(th)) + 1j*(yc + Rc*sin(th));
        m = abs(z) <= 1 + 1e-6;
        plot(ax, real(z(m)), imag(z(m)), '-', 'LineWidth', lw, 'Color', col);
    end
end

function draw_const_g(ax, gvals, col, lw)
% Constant conductance circles (normalized g >= 0):
% Center c = -g/(1+g), radius R = 1/(1+g)  (mirrored left)
    th = linspace(0,2*pi,721);
    for g = gvals
        if g < 0, continue; end
        c = -g/(1+g);
        R = 1/(1+g);
        z = c + R*exp(1j*th);
        m = abs(z) <= 1 + 1e-6;
        plot(ax, real(z(m)), imag(z(m)), '-', 'LineWidth', lw, 'Color', col);
    end
end

function draw_const_b(ax, bvals, sgn, col, lw)
% Constant susceptance circles (normalized b):
% Center (-1, 1/b), radius 1/|b|
    th = linspace(0,2*pi,721);
    for b = bvals
        yc = 1/(sgn*b);
        Rc = 1/abs(b);
        z = (-1 + Rc*cos(th)) + 1j*(yc + Rc*sin(th));
        m = abs(z) <= 1 + 1e-6;
        plot(ax, real(z(m)), imag(z(m)), '-', 'LineWidth', lw, 'Color', col);
    end
end

% ==================== Label helpers (handle-safe) ====================

function add_labels_r(ax, rvals, col, fs)
% Place r labels near the top of each constant-r circle (on +j side)
    for r = rvals
        if r < 0, continue; end
        c = r/(1+r);
        R = 1/(1+r);
        ang = pi/2;  % 90°
        p = c + R*exp(1j*ang);
        if abs(p) <= 1.02
            text(ax, real(p), imag(p), sprintf('r=%.2g',r), ...
                'FontSize', fs, 'Color', col, ...
                'HorizontalAlignment','center', 'VerticalAlignment','bottom');
        end
    end
end

function add_labels_x(ax, sgn, xvals, col, fs)
% Place x labels along each constant-x arc (right side, ~±60°)
    for x = xvals
        yc = 1/(sgn*x); Rc = 1/abs(x);
        ang = sgn * pi/3;    % +60° for +x, -60° for -x
        p = (1 + Rc*cos(ang)) + 1j*(yc + Rc*sin(ang));
        if abs(p) <= 1.02
            if sgn > 0
                s = sprintf('x=+%.2g',x);
                va = 'bottom';
            else
                s = sprintf('x=-%.2g',x);
                va = 'top';
            end
            text(ax, real(p), imag(p), s, ...
                'FontSize', fs, 'Color', col, ...
                'HorizontalAlignment','left', 'VerticalAlignment', va);
        end
    end
end

function add_labels_g(ax, gvals, col, fs)
% Place g labels near the top of each constant-g circle (left side)
    for g = gvals
        if g < 0, continue; end
        c = -g/(1+g);
        R = 1/(1+g);
        ang = pi/2;
        p = c + R*exp(1j*ang);
        if abs(p) <= 1.02
            text(ax, real(p), imag(p), sprintf('g=%.2g',g), ...
                'FontSize', fs, 'Color', col, ...
                'HorizontalAlignment','center', 'VerticalAlignment','bottom');
        end
    end
end

function add_labels_b(ax, sgn, bvals, col, fs)
% Place b labels along each constant-b arc (left side, ~±60°)
    for b = bvals
        yc = 1/(sgn*b); Rc = 1/abs(b);
        ang = sgn * pi/3;
        p = (-1 + Rc*cos(ang)) + 1j*(yc + Rc*sin(ang));
        if abs(p) <= 1.02
            if sgn > 0
                s = sprintf('b=+%.2g',b);
                va = 'bottom';
            else
                s = sprintf('b=-%.2g',b);
                va = 'top';
            end
            text(ax, real(p), imag(p), s, ...
                'FontSize', fs, 'Color', col, ...
                'HorizontalAlignment','right', 'VerticalAlignment', va);
        end
    end
end

% ==================== Corner labels & legends (handle-safe) ====================

function corner_and_legend(ax, fs, ...
    col_rMaj, col_xpMaj, col_xnMaj, ...
    col_gMaj, col_bpMaj, col_bnMaj, which)
% Your requested positions:
% Corner labels
text(ax,  1.02, 0.02, 'Short', 'FontSize',fs);   % moved to right
text(ax, -1.2, 0.02, 'Open',  'FontSize',fs);
text(ax,  0.02, 0.02, 'Match', 'FontSize',fs);

% Tiny legends (outside circle)
y0 = 0.95;
text(ax, -1.5, y0,      'Legend',          'FontSize',fs, 'FontWeight','bold');
text(ax, -1.5, y0-0.06, 'Z: r=const',      'FontSize',fs, 'Color',col_rMaj);
text(ax, -1.5, y0-0.12, 'Z: x=+const (L)', 'FontSize',fs, 'Color',col_xpMaj);
text(ax, -1.5, y0-0.18, 'Z: x=-const (C)', 'FontSize',fs, 'Color',col_xnMaj);

text(ax,  1.0, y0,      'Legend (Y)',      'FontSize',fs, 'FontWeight','bold');
text(ax,  1.0, y0-0.06, 'Y: g=const',      'FontSize',fs, 'Color',col_gMaj);
text(ax,  1.0, y0-0.12, 'Y: b=+const',     'FontSize',fs, 'Color',col_bpMaj);
text(ax,  1.0, y0-0.18, 'Y: b=-const',     'FontSize',fs, 'Color',col_bnMaj);

% Note: axis limits are widened earlier to show x = ±1.5 comfortably.
end
