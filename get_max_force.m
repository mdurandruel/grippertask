function Max_force = get_max_force(relax)
%This function gets the maximum excerted force over a time of 4 seconds in
%3 repetitions

global PT t_param

%Pre-task instructions
set(PT.instructions, 'Visible', 'on');
set(PT.instructions, 'String', 'Après le "Start", veuillez serrer votre main, le plus fort possible, pendant 3 secondes');
pause(5)
set(PT.instructions, 'Visible', 'off')

% startnum = t_param.startnum;
count_str = {'Start', '2', '1', 'Stop'};

s = 20;  %Number of samples

max_force_rep = zeros(t_param.measure_rep, s);           %Value storage array
for i = 1:t_param.measure_rep
    set(PT.instructions, 'Visible', 'on')
    pause(3)
    set(PT.instructions, 'Visible', 'off')
    
   % block_sound;
    pause(t_param.max_force_t_delay)
    
    set(PT.textcount, 'Visible', 'on');
    for q = 1:4
        if ( q == 1 || q == 2 || q == 3)
            set(PT.textcount, 'String', count_str(q));              %Update text box string
        end
        for S = 1:s
            Y = axis(t_param.joy, 2) - relax;               %Get gripper value
            max_force_rep(i, S) = Y;                        %Reading from gripper
            pause(1/s)                                            % Wait 1 second
        end
        if q == 4
        set(PT.textcount, 'String', count_str(q));              %Update text box string
        pause(0.5)
        end
%         startnum = startnum - 1;                            % Subtract one from our counter
%         f_col = f_col + 1;
    end
    set(PT.textcount, 'Visible', 'off');
%     startnum = 3;
    pause(t_param.time_rep)
end

max_force_std = std(std(max_force_rep));
max_force_mean = mean(mean(max_force_rep));
Max_force = - (abs(max_force_mean) + abs(max_force_std));

set(PT.instructions_task, 'String', 'Suivez la séquence le plus précisement et rapidement possible');
set(PT.instructions_task, 'Visible', 'on')
pause(3)
set(PT.instructions_task, 'Visible', 'off');
disp(max_force_rep)
disp(['Max force was: ' num2str(Max_force)])
end