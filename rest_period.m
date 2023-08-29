function [start_rest, end_rest] = rest_period
    global t_param PT
    
    start_rest = clock;
    
    set(PT.instructions_break, 'Visible', 'on');
    set(PT.instructions_break, 'String', [newline '+']);
    pause(t_param.break_time)
    %set(PT.instructions_break, 'Visible', 'off');
    
    end_rest = clock;   
end