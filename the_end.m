function the_end
    global t_param PT
    
    set(PT.instructions_break, 'Visible', 'on');
    set(PT.instructions_break, 'String', [newline 'Fin']);
    pause(t_param.end_time)
    set(PT.instructions_break, 'Visible', 'off');
end