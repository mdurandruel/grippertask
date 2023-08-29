function relax = get_rest(PT)
%This function captures the output value from the gripper during 5
%seconds so that it may work as a minimum value for value mapping

global t_param

%Set instructions on panel
set(PT.instructions_task, 'Visible', 'off');
set(PT.instructions, 'Visible', 'on');
set(PT.instructions, 'String', ['Rel' char(226) 'chez la g' char(226) 'chette svp']);

relax_st = zeros(1,5);                  %Allocate memory for relax samples
%Record during 5 seconds, 1 Hz
for v = 1:5
    relax_st(1,v) = axis(t_param.joy,2);
    pause(1)
end

set(PT.instructions, 'Visible', 'off');

relax = max(relax_st);                  %Relax value. The max is taken as
                                        %the output of the gripper is
disp(['Relax force is:' num2str(relax)])%positive at rest and becomes more
                                        %negative with increasing force
end