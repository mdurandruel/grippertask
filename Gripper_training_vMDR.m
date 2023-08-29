%Gripper task tracker multiple blocks
%This program uses the 932 interface & power supply (FIU-932-B) alongside
%the Grip Force (HHSC-1X1-GRFC-V2), both from Current Designs (R), to track
%the grip force excerted by a participant. The tasks consists of excerting
%a variable amount of force to move a ball towards a set of specific
%targets. Each stage of the process will be described below. Refer to the
%README.txt file for a detailed description of the task and other relevant
%information.

%The operation of the gripper with this program requires the configuration
%of the FIU-932-B using the following parameters:
%Gripper setup
%USB     601
%HHSC-1x1-GRFC
%HID Joystick

%Clear workspace
close all
clear
clc

%Path to function to remove figure borders. Source: 
%https://www.mathworks.com/matlabcentral/fileexchange/50111-undecoratefig-remove-restore-figure-border-and-title-bar
%addpath([pwd '\undecorateFig'])

%Setup operation parameters
%The function setup_parameters.m contains all constant values used in the
%program, such as delays, force percentages, etc. These parameters may be
%modified whithin this function directly

%Data save directory
subj = 'test';
task = 'B'; %A for familiarization and B for the real task
%day = '1';
exercise = 'Training1';

save_dir = [pwd '\Results\Subject_' subj];

if 7 == exist(save_dir,'dir')
else
    mkdir(save_dir)
end

setup_parameters;

% Setup task panel
global PT t_param

PT.fig = figure('units','normalized',...
                 'name','Training',...
                 'menubar','none',...
                 'numbertitle','off',...
                 'innerposition',[t_param.monitor_num 0 1 1],...
                 'color',[0, 0, 0],...
                 'busyaction','cancel',...
                 'renderer','opengl');
PT.textcount = uicontrol('Style', 'text',...           % We want a text box
                         'BackgroundColor',[0, 0, 0],...
                         'Units', 'Normalized',...     % Scale the box relative to figure window
                         'Position', [0.25, 0.25, 0.5, 0.5], ...  % Scale the box relative to figure window
                         'FontUnits', 'Normalized',... % Scale font relative to text box
                         'ForegroundColor',[1,1,1],...
                         'FontSize', 0.6);            % Scale font relative to text box
PT.instructions = uicontrol('Style', 'text',...
                            'BackgroundColor',[0, 0, 0],...
                            'Units', 'Normalized',...
                            'Position', [0.24, 0.25, 0.5, 0.5],...
                            'FontUnits', 'Normalized',...
                            'FontSize', 0.15,...
                            'ForegroundColor',[1,1,1]);
PT.instructions_task = uicontrol('Style', 'text',...
                                'BackgroundColor',[0, 0, 0],...
                                'Units', 'Normalized',...
                                'Position', [0.25, 0.25, 0.5, 0.5],...
                                'FontUnits', 'Normalized',...
                                'FontSize', 0.1,...
                                'ForegroundColor',[1,1,1]);
PT.instructions_break = uicontrol('Style', 'text',...
                                 'BackgroundColor',[0, 0, 0],...
                                 'Units', 'Normalized',...
                                 'Position', [0.05, 0.1, 0.9, 0.9],...
                                 'FontUnits', 'Normalized',...
                                 'FontSize', 0.3,...
                                 'ForegroundColor',[1,1,1]);
PT.instructions_veil = uicontrol('Style', 'text',...
                                 'BackgroundColor',[0, 0, 0],...
                                 'Units', 'Normalized',...
                                 'Position', [0.05, 0.1, 0.9, 0.9],...
                                 'FontUnits', 'Normalized',...
                                 'FontSize', 0.3,...
                                 'ForegroundColor',[1,1,1]);
% PT.field = rectangle('pos',[0.3, 0.05, 0.2, 0.8],...
%                      'facecolor',[0, 0, 0],...
%                      'linewidth',2); % This is used below the preview.  
axis off

%Remove figure borders
% undecorateFig(PT.fig)

set(PT.instructions_break, 'Visible', 'off');
set(PT.instructions_veil, 'Visible', 'off');

%% Relax and max force
%Get relaxed value
relax = get_rest(PT);

%Record maximum force
Max_force = get_max_force(relax);

%%

N = 200;
Task_results = repmat(struct('x',1), N, 1 );
for I = 1:t_param.n_block
    disp(['Number of block is ' num2str(I)]);
    
    f = figure(1);
    disp('Press 5 to start the task') %Trigger of the MRI scanner
    waitforbuttonpress;
    
    if f.CurrentCharacter == '5'
        start_times = clock;
        if I == 1
            image = tic;
            image_times = toc(image);
            start_session_time = tic;
        else
            image_times = toc(image);
        end
        
        %Countdown
        start_countdown;
        
        
        %Build bars, arrows and ball
        [top_bar, base_bar, ball_x, ball_y, patchhand, pr_vec_sep, white_numbers,...
            all_bars, barin_x, barout_x, barin_y,barout_y, seq_bar_real, rand_bar_real] = make_bars_n_arrows(exercise,task,I);
    
        
        %Track task
        [recorded_grip, recorded_time, nb_trials, el_block_time, el_trial_time, val_save_trial, el_reach_time, ...
            val_save_reach, outcome_block, tt_bar, val_save, ball_distance, hit_times, motor_start] = track_task_vMDR(ball_x, ball_y, ...
            relax, Max_force, seq_bar_real, rand_bar_real, I, all_bars, barin_x, barout_x, barin_y,barout_y);
        
        motor_end = clock;
        
        waitforbuttonpress;
        if f.CurrentCharacter == '5'
            end_times = clock; 
        else
            error('Unexpected command received');
        end
        
        if I <= t_param.n_block - 1
            
            %Delete previous bars and numbers
            delete(top_bar);
            delete(base_bar);
            for k = 1:5
                delete(white_numbers(1,k));
                if k ~= 5
                delete(patchhand{1,k});
                end
            end
            %Rest period
            [start_rest, end_rest] = rest_period;
       end

        %Get results, calculate distance travelled and area under the curve
        [distance_travelled, AUC, task_result, recorded_time_shaped] = get_results_and_distances_mod(recorded_grip, recorded_time, val_save, el_block_time, tt_bar, save_dir, I, exercise);
    else
        error('Unexpected command received');
    end
  
    %Outcome
    if I == t_param.random_block
       seq_bar_real = rand_bar_real;
    else
    end

    %Variable names
    book_keep_time = tic;
    
    Task_results(I).Travelled_distance = distance_travelled;
    Task_results(I).Area_under_curve = AUC;
    Task_results(I).Error = ball_distance;
    Task_results(I).Block_time = el_block_time;
    Task_results(I).Trial_time = el_trial_time;
    Task_results(I).Trial_val = val_save_trial;
    Task_results(I).Trial_HZ_time = tt_bar;
    Task_results(I).Reach_time = el_reach_time;
    Task_results(I).Reach_val = val_save_reach;
    Task_results(I).Target_sequence = seq_bar_real;
    Task_results(I).Sequence_verdict = outcome_block;
    Task_results(I).Gripper_readout = task_result;
    Task_results(I).Block = I;
    Task_results(I).Task = task;
    Task_results(I).Max_Force = Max_force;
    Task_results(I).Relax = relax;
    
    Task_results(I).Time_readout = recorded_time_shaped;
    Task_results(I).Start_5_time = start_times;    %Time at which the "5" is received before the motor block
    Task_results(I).End_5_time = end_times;    %Time at which the "5" is received after the motor block
    Task_results(I).Image_time = image_times;    %Precise time of the image at the beginning of each block
    Task_results(I).Motor_start = motor_start;%Time start motor task (block)
    Task_results(I).Motor_end = motor_end;%End of motor task (block)
    Task_results(I).Reach_Time_stamps = hit_times; %Time stamp for every read value
    Task_results(I).Break_start = start_rest;    %Time stamp Break start
    Task_results(I).Break_end = end_rest;        %Time stamp Break end
    Task_results(I).Organize_time = toc(book_keep_time);%Time to organize data in structure

    % End
    if I == t_param.n_block
        session_time_sec = toc(start_session_time);
        session_time = session_time_sec/60;
        the_end;
        [Total_sequences] = result_summary(Task_results);
        
        Task_results = Task_results(1:Total_sequences);
        
        %Save data
        
        subj_dir = fullfile([save_dir '\' subj '_' exercise]);
        if 2 == exist(subj_dir,'file')
            subj_dir = fullfile([save_dir '\' subj '_' exercise '_V2.mat']);
            save(subj_dir, 'Task_results')
        else
            save(subj_dir, 'Task_results')
            save(fullfile([save_dir '\session_time_' exercise '.mat']),'session_time')
        end

        set(PT.instructions_veil, 'Visible', 'on');
        return
    end
    
end

