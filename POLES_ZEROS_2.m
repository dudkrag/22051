function POLES_ZEROS
 
    fig = figure('Name', 'Interactive Filter Design', 'NumberTitle', 'off', ...
        'MenuBar', 'none', 'Toolbar', 'none', 'Position', [100, 100, 800, 600]);
    
    ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.4, 0.6]);
    hold(ax, 'on');
    axis(ax, [-2 2 -2 2]);
    grid(ax, 'on');
    xlabel(ax, 'Real Part');
    ylabel(ax, 'Imaginary Part');
    title(ax, 'Pole-Zero Placement');
    
    theta = linspace(0, 2*pi, 100);
    plot(ax, cos(theta), sin(theta), '--k');
    
    % Initialize list for poles and zeros
    zeros_list = []; 
    poles_list = []; 

    %BUTTONS - check yt video
    uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Add Zero', ...
        'Position', [50, 50, 100, 30], 'Callback', @(src, event)add_zero());
    uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Add Pole', ...
        'Position', [200, 50, 100, 30], 'Callback', @(src, event)add_pole());
    uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Clear All', ...
        'Position', [350, 50, 100, 30], 'Callback', @(src, event)clear_all());
    uicontrol('Parent', fig, 'Style', 'pushbutton', 'String', 'Compute Filter', ...
        'Position', [500, 50, 150, 30], 'Callback', @(src, event)compute_filter());

    %ASK FOR HELP---- ZERO/POLE
    function add_zero()
        [x, y] = ginput(1);
        zeros_list = [zeros_list, x + 1j*y, x - 1j*y]; %conjugates pairs
        plot(ax, real(zeros_list), imag(zeros_list), 'ob', 'MarkerSize', 8, 'LineWidth', 2);
    end

    function add_pole()
        [x, y] = ginput(1);
        poles_list = [poles_list, x + 1j*y, x - 1j*y];
        plot(ax, real(poles_list), imag(poles_list), 'xr', 'MarkerSize', 8, 'LineWidth', 2);
    end

    function clear_all()
        zeros_list = [];
        poles_list = [];
        cla(ax);
        plot(ax, cos(theta), sin(theta), '--k'); 
        title(ax, 'Pole-Zero Placement');
    end

    function compute_filter()
        if isempty(zeros_list) && isempty(poles_list)
            errordlg('no poles and zeros', 'Error');
            return;
        end

        B = poly(zeros_list);
        A = poly(poles_list); 

        % Display coefficients + pplot
        disp('Numerator coefficients (B):');
        disp(B);
        disp('Denominator coefficients (A):');
        disp(A);

        figure;
        zplane(B, A);
        title('Pole-Zero Plot');
        figure;
        freqz(B, A, 1024);
        title('Frequency Response');       %not needed
        figure;
        impz(B, A);
        title('Impulse Response');
        syms z;
        
        H = poly2sym(B, z) / poly2sym(A, z);
        disp('Transfer Function H(z):');
        pretty(H); 
   
    end
end

