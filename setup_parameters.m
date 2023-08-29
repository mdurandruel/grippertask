function setup_parameters
%setup_parameters Function used to initialize all constant values used
%during the task. The values that may be modified are:
%   - Joystick paramaters
%   - Parameters for acquiring max force
%   - Bar position setup
%   - Arrow parameters
%   - Ball parameters
%   - Task parameters

global t_param

%Screen select
t_param.monitor_num = 1;        %0 for screen 1, 1 for screen 2 to change for mock and MRI

% Training parameters
t_param.n_trials = 15;          %Nb of trials to perform per block
t_param.n_block = 9;            %Nb of training/Baseline blocks
t_param.break_time = 15.5;      %Rest time
t_param.end_time = 5;           %Time to display "END"
t_param.random_block =5;       %Position for random block V9(4)

% Joystick parameters
t_param.ID = 1;                         %Joystick ID
%t_param.joy = vrjoystick(t_param.ID);           %Create Joystick object (Standard Matlab)

% Parameters for acquiring max force 
t_param.startnum = 1;                   %Our starting countdown number
t_param.measure_rep = 3;                %Number of measurement repetitions. Default is 3
t_param.time_rep = 2;                   %Time between acquisition countdown repetitions
t_param.max_force_t_delay = 1;          %Delay between sound and max force acquisition

% Bar position setup. As the units of the panel are normalized to ensure 
% fit into any screen, coordinates go from 0 to 1
t_param.ML = 0.85;                              %Max bar position in panel
t_param.barw = 0.4;%0.07;                       %Width of the bars (normalized)
t_param.barx =  0.5 - (t_param.barw/2);%0.375   %Horizontal position of the bars' lower left corner (normalized)
t_param.bary = 0.02;                            %Vertical distance from bar midline to its vertices 
t_param.base_bar_y_pos = 0.09;                  %upper Y coordinate for the base bar
t_param.num_pos = 0.05;                         %Number shift to the left of the bars
t_param.target_color = [1, 1, 1];               %Color for target bars
t_param.base_color = [0.6, 0.6, 0.6];           %Color for base bar
t_param.ball_color = [0.6, 0.6, 0.6];           %Color for ball
t_param.force_per = [0.55, 0.45,...             %Force percentages for bars 2 - 5 
                    0.30, 0.20];
t_param.top_bar_force = 0.70;           %Force percentage for top bar
t_param.nbar = 4;                       %Number of bars besides top. Must coincide with force_per

% Ball parameters
t_param.r = 0.01;                     %Ball radius V9(0.025)
t_param.ell_fact = 6;                 %Factor to alter ellipse to account for rectangular screen

% Task parameters
t_param.max_time = 0.200;               %Time in seconds so that a hit is registered
                                        % Former Number of cycles to be met before hit is registered (wrong or successful trial) V1 was 7
t_param.home_threshold = 0.04;          %Threshold for pulling rest values to zero V9(0.02)

end