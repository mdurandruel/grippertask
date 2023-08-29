% Test for checking the time

%Clear workspace
close all
clear
clc

addpath([pwd '\undecorateFig'])


% Joystick parameters
ID = 1;                         %Joystick ID
joy = vrjoystick(ID);           %Create Joystick object (Standard Matlab)

%Setup task panel
global PT

monitor_num = 0; 

PT.fig = figure('units','normalized',...
                 'name','Training',...
                 'menubar','none',...
                 'numbertitle','off',...
                 'innerposition',[monitor_num 0 1 1],...
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
                             
axis off

%Remove figure borders
undecorateFig(PT.fig)

set(PT.instructions_break, 'Visible', 'off');
set(PT.instructions_veil, 'Visible', 'off');

%%
%Get relaxed value
%Set instructions on panel
set(PT.instructions_task, 'Visible', 'off');
set(PT.instructions, 'Visible', 'on');
set(PT.instructions, 'String', 'Relâchez la gâchette svp');

relax_st = zeros(1,3);                  %Allocate memory for relax samples
%Record during 5 seconds, 1 Hz
for v = 1:3
    relax_st(1,v) = axis(joy,2);
    disp(relax_st)   
    pause(1)
end

set(PT.instructions, 'Visible', 'off');

relax = max(relax_st);                  %Relax value. The max is taken as
disp(relax)                                        %the output of the gripper is
                                        %positive at rest and becomes more
                                        %negative with increasing force

%%
%Record maximum force

%Pre-task instructions
set(PT.instructions, 'Visible', 'on');
% set(PT.instructions, 'String', 'Quand vous voyez le "Start", veuillez serrer votre main, aussi fort que possible, pendant 3 secondes');
% pause(1)
set(PT.instructions, 'Visible', 'off')

% startnum = t_param.startnum;
count_str = {'Start', '2', '1', 'Stop'};

s = 15;  %Number of samples

max_force_rep = zeros(1, s);           %Value storage array

    set(PT.instructions, 'Visible', 'on')
    pause(5)
    set(PT.instructions, 'Visible', 'off')
    
    block_sound;
    pause(1)
    
    set(PT.textcount, 'Visible', 'on');
    for q = 1:4
        set(PT.textcount, 'String', count_str(q));              %Update text box string
        for S = 1:s
            Y = axis(joy, 2) - relax;                                   %Get gripper value
            max_force_rep(1, S) = Y;   
            disp (max_force_rep) %Reading from gripper
            pause(1/s)                                            % Wait 1 second
        end
%         startnum = startnum - 1;                            % Subtract one from our counter
%         f_col = f_col + 1;
    end
    set(PT.textcount, 'Visible', 'off');
%     startnum = 3;
    pause(1)

max_force_std = std(std(max_force_rep));
max_force_mean = mean(mean(max_force_rep));
Max_force = - (abs(max_force_mean) + abs(max_force_std));

%%
% Construction des barres, de la croix  et de la balle
axis manual

cross_x= [0.27, 0.30, 0.50, 0.70, 0.73, 0.53, 0.73, 0.70, 0.50, 0.30, 0.27, 0.47];
cross_y= [0.30, 0.27, 0.47, 0.27, 0.30, 0.50, 0.70, 0.73, 0.53, 0.73, 0.70, 0.50];

ML = 0.50;
barw = 0.7;                     
barx =  0.5 - (barw/2);
bary = 0.02;
pstn_x = [barx, barx + barw, barx + barw, barx];
pstn_y = [ML - bary, ML - bary, ML + bary, ML + bary];

pstn_x_base = [barx, barx + barw, barx + barw, barx];
pstn_y_base = [0, 0, 2*bary, 2*bary];

%Barres de validation
barin_x = [barx + 0.01, barx + barw - 0.01, barx + barw - 0.01, barx + 0.01];
barin_y = [ML - bary + 0.01, ML - bary + 0.01, ML + bary - 0.01, ML + bary - 0.01];

barout_x = [barx - 0.01, barx + barw + 0.01, barx + barw + 0.01, barx - 0.01];
barout_y = [ML - bary - 0.01, ML - bary - 0.01, ML + bary + 0.01, ML + bary + 0.01];


bar = patch(pstn_x, pstn_y,[1, 1, 1],'LineWidth', 2.8);
base_bar = patch(pstn_x_base, pstn_y_base, [0.6, 0.6, 0.6],'LineWidth', 2.8);

arc = linspace(0, 2*pi);
ball_x = 0.01 * cos(arc) + 0.5;
ball_y = 0.01 * sin(arc);

pbaspect([1, 1, 1])

%%
% track_task
home_threshold = 0.04;
top_bar_force = 0.70;  
recorded_grip = zeros(1,1000000);   %Memory allocation for recording
error = zeros (1,100000);
val_save = 1;
ball_base = ball_y;
ttarget=0.5; %secondes
tball=0;
%Start timer
tic

while (1)
y = axis(joy, 2) - relax;
%     disp(y)
    if y > - home_threshold
        y = 0;
    end
    %Value mapping
%     A = relax;
A = 0;
B = Max_force * top_bar_force;
C = bary; %Lower bound
D = ML; %Upper bound

Y_c = (y - A)/(B - A) * (D - C) + C;
    
recorded_grip(1, val_save) = Y_c;
    
ball_y = ball_base + Y_c;
ball = patch(ball_x, ball_y, [0.6, 0.6, 0.6]);
drawnow

delete(ball)

if Y_c > 2*bary && (Y_c < ML - bary || Y_c > ML + bary)
    error(1,val_save) = std(recorded_grip((val_save-4):(val_save)));
    if std(recorded_grip((val_save-7):(val_save)))== 0
        cross = patch(cross_x,cross_y,[1, 1, 1]);
    end 
elseif Y_c > 2*bary && Y_c >= ML - bary && Y_c <= ML + bary
    t0=toc;
    while (tball <= ttarget)
        tball=toc-t0;
    end
    tf=tball;
    barout =  patch(barout_x, barout_y,[0.8, 0.8, 0.8],'LineWidth', 2.8);
    barin = patch(barin_x, barin_y,[1, 1, 1]);
%     return
    
end

val_save = val_save + 1;
end
