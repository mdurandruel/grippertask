function [distance_travelled, task_result] = show_results(recorded_grip, el_time, save_dir, val_save)
    
    task_result = recorded_grip(1,1:val_save);
    plot_time = linspace(0,el_time, length(task_result));
    
    distance_travelled = trapz(task_result);
%     distance_travelled = sum(abs(task_result));
    
    g1 = figure(2);
    plot(plot_time, task_result)
    title('Measured grip force')
    xlabel('Time to complete task (s)'); ylabel('Gripper output');
    
    saveas(g1, [save_dir '\Force_vs_time.jpg'])
end