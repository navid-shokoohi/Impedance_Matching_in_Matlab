function SmithInteractive()
% SmithInteractive — indexed plotting with de-overlapped labels
% • ZLk labels show numeric value (jX + R), outside the circle with leaders
% • MkA/MkB labels evenly spaced on an inner ring with leaders from center
% • All impedance markers & labels are black and larger, with white background
%
% Requires: Smith.m that returns axes handles (struct with Z/Y or Overlay)

    % --- Mode selection ---
    mode = questdlg('Display mode?', 'Smith', ...
                    'Overlay (Z+Y)', 'Two panels (Z|Y)', 'Overlay (Z+Y)');
    if isempty(mode), return; end
    if strncmpi(mode,'Two',3), mode = 'two'; else, mode = 'overlay'; end

    % --- Inputs ---
    defZ0 = '50';
    defF0 = '2.4e9';
    defZL = '25+30j, 80-20j, 10, 100+50j';

    answ = inputdlg({'Z0 (ohms):', 'f0 (Hz):', 'Impedances ZL (comma/space-separated):'}, ...
                    'Smith inputs', 1, {defZ0, defF0, defZL});
    if isempty(answ), return; end
    Z0 = str2double(answ{1});
    f0 = str2num(answ{2}); %#ok<ST2NM>
    ZL_list = str2num(['[', answ{3}, ']']); %#ok<ST2NM>
    if isnan(Z0) || isempty(f0) || isempty(ZL_list)
        errordlg('Could not parse inputs. Check Z0, f0, and ZL list.','Input error'); 
        return;
    end

    % --- Draw base charts ---
    ax = Smith(mode);
    isTwo = isfield(ax,'Z') && isfield(ax,'Y');
    if isTwo
        axZ = ax.Z; axY = ax.Y;
    else
        axZ = ax.Overlay; axY = ax.Overlay;
    end

    % --- Style: all black & bigger ---
    labFS   = 12;     % label font size for ZL
    labFSM  = 12;     % label font size for matches
    mrkSzL  = 8;      % load marker size
    mrkSzM  = 7;      % match marker size
    kcol    = 'k';    % black
    tbg     = [1 1 1];% text white background
    tmg     = 2;      % text margin

    % --- ZL label placement: outside ring with sector stacking ---
    N      = numel(ZL_list);
    rLblZ  = 1.18;          % base radius for ZL labels (outside unit circle)
    rStepZ = 0.08;          % radial step when stacking labels within a sector
    nSec   = 24;            % number of angular sectors (15° each)
    secW   = 2*pi/nSec;     % sector width
    secCnt = zeros(1,nSec); % counters per sector

    % --- Match label placement: inner ring with even spacing (2N labels) ---
    N2     = max(1,2*N);
    rLblM  = 0.30;          % inner ring radius for match labels
    % (evenly spaced angles for: i=1..2N ; i=odd -> A, i=even -> B)

    for k = 1:N
        ZL = ZL_list(k);
        gamma = (ZL - Z0) / (ZL + Z0);

        % --- Plot Γ (load) on Z chart ---
        plot(axZ, real(gamma), imag(gamma), 'o', ...
            'MarkerFaceColor', kcol, 'MarkerEdgeColor', kcol, 'MarkerSize', mrkSzL);

        % ZL label outside: sector stack logic
        th  = atan2(imag(gamma), real(gamma));          % angle of Γ
        idx = floor(mod(th,2*pi)/secW) + 1;             % sector index 1..nSec
        secCnt(idx) = secCnt(idx) + 1;                  % stack count in sector
        rLab = rLblZ + (secCnt(idx)-1)*rStepZ;          % push outward if crowded
        [haZ, vaZ] = anchor_from_angle(th);             % neat alignment
        pLab = [rLab*cos(th), rLab*sin(th)];            % label position

        % leader line from Γ to its label
        plot(axZ, [real(gamma) pLab(1)], [imag(gamma) pLab(2)], '-', 'Color', kcol, 'LineWidth', 0.8);

        % label text: "ZLk = jX + R"
        text(axZ, pLab(1), pLab(2), sprintf(' ZL%d = %s', k, fmt_jX_plus_R(ZL)), ...
            'FontSize', labFS, 'Color', kcol, 'FontWeight','bold', ...
            'HorizontalAlignment', haZ, 'VerticalAlignment', vaZ, ...
            'BackgroundColor', tbg, 'Margin', tmg, 'Interpreter','tex');

        % --- Y point on second panel (if present) ---
        if isTwo
            % Admittance value for labeling (two-panel only)
            YL = 1 / ZL;   % <-- if you prefer normalized admittance, use: YL = (1/ZL) / (1/Z0);
        
            plot(axY, -real(gamma), -imag(gamma), 's', ...
                'MarkerFaceColor', kcol, 'MarkerEdgeColor', kcol, 'MarkerSize', mrkSzL-1);
        
            % Label like "YLk = jB + G" in black, larger font (matches your ZL style)
            text(axY, -real(gamma)+0.03, -imag(gamma), ...
                sprintf(' YL%d = %s', k, fmt_jB_plus_G(YL)), ...
                'FontSize', labFS, 'Color', kcol, 'FontWeight','bold', ...
                'BackgroundColor', tbg, 'Margin', tmg);
        end


        % --- L-match options (components) ---
        [Lopt, Copt] = lmatch_two_options(ZL, Z0, f0);
        strA = comp_string(Lopt.OptionA.Series_H, Copt.OptionA.Series_F, ...
                           Lopt.OptionA.Shunt_H,  Copt.OptionA.Shunt_F);
        strB = comp_string(Lopt.OptionB.Series_H, Copt.OptionB.Series_F, ...
                           Lopt.OptionB.Shunt_H,  Copt.OptionB.Shunt_F);

        % --- Match markers at the true match (center) ---
        plot(axZ, 0, 0, '^', 'MarkerFaceColor', kcol, 'MarkerEdgeColor', kcol, 'MarkerSize', mrkSzM);
        plot(axZ, 0, 0, 'v', 'MarkerFaceColor', kcol, 'MarkerEdgeColor', kcol, 'MarkerSize', mrkSzM);

        % Evenly spaced angle slots for 2N labels: A gets slot (2k-1), B gets slot (2k)
        thA = 2*pi*(2*k-2)/N2;
        thB = 2*pi*(2*k-1)/N2;
        pA  = rLblM * [cos(thA), sin(thA)];
        pB  = rLblM * [cos(thB), sin(thB)];

        % leader lines from center to callouts
        plot(axZ, [0 pA(1)], [0 pA(2)], '-', 'Color', kcol, 'LineWidth', 0.8);
        plot(axZ, [0 pB(1)], [0 pB(2)], '-', 'Color', kcol, 'LineWidth', 0.8);

        [haA, vaA] = anchor_from_angle(thA);
        [haB, vaB] = anchor_from_angle(thB);

        text(axZ, pA(1), pA(2), sprintf(' M%dA: %s', k, strA), ...
            'FontSize', labFSM, 'Color', kcol, 'FontWeight','bold', ...
            'HorizontalAlignment', haA, 'VerticalAlignment', vaA, ...
            'BackgroundColor', tbg, 'Margin', tmg, 'Interpreter','tex');

        text(axZ, pB(1), pB(2), sprintf(' M%dB: %s', k, strB), ...
            'FontSize', labFSM, 'Color', kcol, 'FontWeight','bold', ...
            'HorizontalAlignment', haB, 'VerticalAlignment', vaB, ...
            'BackgroundColor', tbg, 'Margin', tmg, 'Interpreter','tex');
    end

    % Titles
    if isTwo
        title(axZ, sprintf('Z-Smith (Z0=%g\\Omega) — %d load(s)', Z0, N));
        title(axY, 'Y-Smith (admittance mirror)');
    else
        title(axZ, sprintf('Dual Smith Chart (Z0=%g\\Omega) — %d load(s)', Z0, N));
    end
end

% ----------------- Helpers -----------------

function s = fmt_jX_plus_R(Z)
% Format complex Z as "jX + R" with signs (Ω), 3 sig figs
    R = real(Z); X = imag(Z);
    if X >= 0, s = sprintf('j%.3g + %.3g', X, R);
    else       s = sprintf('-j%.3g + %.3g', -X, R);
    end
end

function s = comp_string(Ls, Cs, Lp, Cp)
% Build concise component string, skipping zeros; SI-scale nicely
    parts = {};
    if Ls>0, parts{end+1} = ['Ls=' fmt_si(Ls,'H')]; end
    if Cs>0, parts{end+1} = ['Cs=' fmt_si(Cs,'F')]; end
    if Lp>0, parts{end+1} = ['Lp=' fmt_si(Lp,'H')]; end
    if Cp>0, parts{end+1} = ['Cp=' fmt_si(Cp,'F')]; end
    if isempty(parts), s = 'no components'; else, s = strjoin(parts, ', '); end
end

function [ha, va] = anchor_from_angle(theta)
% Choose text alignment based on angle so labels sit cleanly
    ct = cos(theta); st = sin(theta);
    ha = 'left';  va = 'middle';
    if ct < -0.15, ha = 'right'; end
    if st >  0.35, va = 'bottom'; elseif st < -0.35, va = 'top'; end
end

function out = fmt_si(x, unit)
% SI scaling: "3.2 nH" or "1.1 pF" etc.
    if ~isfinite(x) || x==0, out = ['0 ' unit]; return; end
    [mant, expo] = normalize_si(x);
    prefix = si_prefix(expo);
    out = sprintf('%.3g %s%s', mant, prefix, unit);
end

function [mant, expo] = normalize_si(x)
    expo = floor(log10(abs(x))/3)*3;
    expo = max(min(expo, 12), -12);  % clamp p..T
    mant = x / 10^expo;
end

function p = si_prefix(expo)
    switch expo
        case -12, p='p';
        case -9,  p='n';
        case -6,  p='\mu';
        case -3,  p='m';
        case 0,   p='';
        case 3,   p='k';
        case 6,   p='M';
        case 9,   p='G';
        case 12,  p='T';
        otherwise, p = sprintf('e%d',expo);
    end
end

function [Lopt, Copt, details] = lmatch_two_options(ZL, Z0, f0)
% Single-frequency L-match calculations
    w = 2*pi*f0;
    R = real(ZL); X = imag(ZL);
    if R <= 0, error('Load must have positive real part.'); end

    Xs_cancel = -X; Rload = R;
    if abs(Rload - Z0) < 1e-12
        Q = 0; Xseries_mag = 0; Xshunt_mag = inf;
    elseif Rload < Z0
        Q = sqrt(Z0/Rload - 1);
        Xseries_mag = Q * Rload;
        Xshunt_mag  = Rload / Q;
    else
        Q = sqrt(Rload/Z0 - 1);
        Xseries_mag = Q * Z0;
        Xshunt_mag  = Z0 / Q;
    end

    % Option A
    Xseries_A = Xs_cancel + Xseries_mag;
    La = 0; Ca_series_A = 0;
    if Xseries_A > 0, La = Xseries_A / w; elseif Xseries_A < 0, Ca_series_A = 1/(w*abs(Xseries_A)); end
    Ca_shunt_A = finite_val(1/(w*Xshunt_mag)); La_shunt_A = 0;

    % Option B
    Xseries_B = Xs_cancel - Xseries_mag;
    Lb = 0; Cb_series_B = 0;
    if Xseries_B > 0, Lb = Xseries_B / w; elseif Xseries_B < 0, Cb_series_B = 1/(w*abs(Xseries_B)); end
    Lb_shunt_B = finite_val(Xshunt_mag / w); Cb_shunt_B = 0;

    Lopt.OptionA.Series_H = La;  Lopt.OptionA.Shunt_H  = La_shunt_A;
    Copt.OptionA.Series_F = Ca_series_A; Copt.OptionA.Shunt_F  = Ca_shunt_A;

    Lopt.OptionB.Series_H = Lb;  Lopt.OptionB.Shunt_H  = Lb_shunt_B;
    Copt.OptionB.Series_F = Cb_series_B; Copt.OptionB.Shunt_F  = Cb_shunt_B;

    details = struct('Q',[]); %#ok<NASGU>
end

function v = finite_val(x)
    if isfinite(x), v = x; else, v = 0; end
end
function s = fmt_jB_plus_G(Y)
% Format complex admittance as "jB + G" (3 sig figs), no units by default.
    G = real(Y); B = imag(Y);
    if B >= 0
        s = sprintf('j%.3g + %.3g', B, G);
    else
        s = sprintf('-j%.3g + %.3g', -B, G);
    end
end
