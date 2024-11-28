function ECHO

    %BUTTONS + SLIDER --- CHECK GUIDE TO CORRECRT
    fig = figure('Name', 'Echo Effect', 'NumberTitle', 'off', ...
        'MenuBar', 'none', 'Toolbar', 'none', ...
        'Position', [100, 100, 600, 400]);

    uicontrol('Style', 'pushbutton', 'String', 'Upload Audio', ...
        'Position', [50, 300, 100, 30], ...
        'Callback', @upload_audio);

    uicontrol('Style', 'text', 'String', 'Delay (ms):', ...
        'Position', [50, 250, 100, 20]);
    delay_slider = uicontrol('Style', 'slider', 'Min', 50, 'Max', 1000, ...
        'Value', 300, 'Position', [50, 230, 150, 20], ...
        'Callback', @update_delay);

    delay_text = uicontrol('Style', 'text', 'String', '300 ms', ...
        'Position', [210, 230, 60, 20]);

    uicontrol('Style', 'text', 'String', 'Echo Gain:', ...
        'Position', [50, 180, 100, 20]);
    gain_slider = uicontrol('Style', 'slider', 'Min', 0.1, 'Max', 1, ...
        'Value', 0.5, 'Position', [50, 160, 150, 20], ...
        'Callback', @update_gain);

    gain_text = uicontrol('Style', 'text', 'String', '0.50', ...
        'Position', [210, 160, 60, 20]);
    uicontrol('Style', 'pushbutton', 'String', 'Play Original', ...
        'Position', [50, 100, 100, 30], ...
        'Callback', @play_original);
    uicontrol('Style', 'pushbutton', 'String', 'Play Echoed', ...
        'Position', [200, 100, 100, 30], ...
        'Callback', @play_echoed);

    original_ax = axes('Parent', fig, 'Position', [0.4, 0.55, 0.5, 0.4]);
    echoed_ax = axes('Parent', fig, 'Position', [0.4, 0.1, 0.5, 0.4]);

    audio_data = [];
    sample_rate = 44100;
    delay_samples = round(300 * 1e-3 * sample_rate);
    echo_gain = 0.5;

    function upload_audio(~, ~)
        [file, path] = uigetfile({'*.wav'}, 'Select a WAV file');
        if isequal(file, 0)
            return;
        end
        [audio_data, sample_rate] = audioread(fullfile(path, file));
        if size(audio_data, 2) > 1
            audio_data = mean(audio_data, 2); %mono
        end
        plot_waveform(original_ax, audio_data, 'Original Audio');
    end

    % Update delay callback
    function update_delay(~, ~)
        delay_ms = round(get(delay_slider, 'Value'));
        delay_samples = round(delay_ms * 1e-3 * sample_rate); 
        set(delay_text, 'String', sprintf('%d ms', delay_ms));
    end

    function update_gain(~, ~)
        echo_gain = get(gain_slider, 'Value');
        set(gain_text, 'String', sprintf('%.2f', echo_gain));
    end

    %%%%%%%%%%PLAY AUDIO BEFORE AFTER
    function play_original(~, ~)
        if isempty(audio_data)
            errordlg('NO AUDIO', 'Error');
            return;
        end
        sound(audio_data, sample_rate);
    end

    function play_echoed(~, ~)
        if isempty(audio_data)
            errordlg('NO AUDIO', 'Error');
            return;
        end
        echoed_audio = apply_echo(audio_data, delay_samples, echo_gain);
        plot_waveform(echoed_ax, echoed_audio, 'Echoed Audio');
        sound(echoed_audio, sample_rate);
    end

    %PLOT
    function plot_waveform(ax, data, title_text)
        axes(ax);
        plot((0:length(data)-1) / sample_rate, data);
        xlabel('Time (s)');
        ylabel('Amplitude');
        title(title_text);
        grid on;
    end

    %echo
    function y = apply_echo(x, delay, gain)
        delay = round(delay); % round to ensure itg
        y = x; 
        for i = delay + 1:length(x)
            y(i) = y(i) + gain * y(i - delay);
        end
    end
end
