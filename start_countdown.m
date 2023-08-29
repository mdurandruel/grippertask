function start_countdown

global PT 

%block_sound;

set(PT.instructions_veil, 'Visible', 'on');
pause(1)
set(PT.instructions_veil, 'Visible', 'off');
set(PT.instructions_break, 'Visible', 'on');

for i = 5:-1:1
    set(PT.instructions_break, 'String', [newline num2str(i)]);
    pause(1)
end

set(PT.instructions_veil, 'Visible', 'on');
set(PT.instructions_break, 'Visible', 'off');
% block_sound;
pause(1)
set(PT.instructions_veil, 'Visible', 'off');

end