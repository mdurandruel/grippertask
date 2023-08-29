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
addpath([pwd '\undecorateFig'])

%Setup operation parameters
%The function setup_parameters.m contains all constant values used in the
%program, such as delays, force percentages, etc. These parameters may be
%modified whithin this function directly

%Data save directory
subj = 'RSG_test';
task = 'Fam';
exercise = 'Fam';
save_dir = [pwd '\Results\Subject_' subj];

if 7 == exist(save_dir,'dir')
else
    mkdir(save_dir)
end

setup_parameters;

%Setup task panel
global PT t_param

PT.fig = figure('units','normalized',...
                 'name','Familiarization',...
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
                            'Position', [0.25, 0.25, 0.5, 0.5],...
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
undecorateFig(PT.fig)

set(PT.instructions_break, 'Visible', 'off');
set(PT.instructions_veil, 'Visible', 'off');

%Get relaxed value
relax = get_rest(PT);

%Record maximum force
Max_force = get_max_force(relax);

%Countdown
start_countdown;

%Build bars, arrows and ball
[top_bar, base_bar, ball_x, ball_y, patchhand, pr_vec_sep, white_numbers,...
        all_bars, barin_x, barout_x, barin_y,barout_y, seq_bar_real] = make_bars_n_arrows_fam();


N = 200;
Task_results = repmat(struct('x',1), N, 1 );

for i = 1:t_param.n_block_fam
   
        %Track task
        [recorded_grip, nb_trials, el_block_time, el_trial_time, val_save_trial, el_reach_time, val_save_reach, outcome_block, tt_bar, val_save, ball_distance] = track_task_fam(ball_x, ball_y, relax,...
        Max_force, seq_bar_real, all_bars, barin_x, barout_x, barin_y,barout_y);
   assert (nb_trials == 15)

        %Show results
    [distance_travelled, AUC, task_result] = get_results_and_distances_mod(recorded_grip, val_save, el_block_time, tt_bar, save_dir, i, exercise);
%         [distance_travelled, task_result] = show_results_multi(recorded_grip, val_save);

%         %Result processing
%         [diff_tar_bar, seq_outcome, mean_error] = result_processing(el_time, recorded_grip, pr_vec_sep, tt_bar, seq_bar, sel_seq, val_save);
        
       
        %Variable names
%         Task_results(series_index).Error_each_bar = diff_tar_bar;
    Task_results(i).Travelled_distance = distance_travelled;
    Task_results(i).Area_under_curve = AUC;
    Task_results(i).Error = ball_distance;
    Task_results(i).Completion_time = el_block_time;
    Task_results(i).Trial_time = el_trial_time;
    Task_results(i).Trial_val = val_save_trial;
    Task_results(i).Reach_time = el_reach_time;
    Task_results(i).Reach_val = val_save_reach;
    Task_results(i).Target_sequence = seq_bar_real;
    Task_results(i).Sequence_verdict = outcome_block;
    Task_results(i).Gripper_readout = task_result;
    Task_results(i).Block = i;
    Task_results(i).Task = task;
    Task_results(i).Max_Force = Max_force;
    Task_results(i).Relax = relax;
        
     %   series_index = series_index + 1;


    
    if i <= t_param.n_block_fam - 1
        %90 seconds break
        rest_break;

        %Countdown
        start_countdown;
    else
       the_end;
       [Total_sequences, Correct_sequences] = result_summary(Task_results);
       Task_results = Task_results(1:Total_sequences);
       %Save data
       
       subj_dir = fullfile([save_dir '\' subj '_fam_1.mat']);
       
       if 2 == exist(subj_dir,'file')
            subj_dir = fullfile([save_dir '\' subj '_fam_2.mat']);
            save(subj_dir, 'Task_results')
        else
            save(subj_dir, 'Task_results')
        end

       set(PT.instructions_veil, 'Visible', 'on');
       return
    end
    



end




