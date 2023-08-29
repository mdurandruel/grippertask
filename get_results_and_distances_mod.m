function [distance_travelled, AUC, task_result, recorded_time_shaped] = get_results_and_distances_mod(recorded_grip, recorded_time, val_save, el_block_time, tt_bar,...
    save_dir, I, exercise)
    
    task_result = recorded_grip(1,1:val_save);
    recorded_time_shaped = recorded_time(1,1:val_save);
    try
        end_time = el_block_time;
        time_vec = linspace(0,end_time,val_save);
        travelled_dist = zeros(1,length(task_result));
        tt_bar_trial = zeros (1,15);
        tt_bar_trial(1,1)= tt_bar(1,1);
        for i= 1:14
            tt_bar_trial(i+1)= tt_bar(i+1)-tt_bar(i);
        end 
        
        for d=1:length(task_result)-1
            travelled_dist(1,d) = sqrt((time_vec(1,d+1) - time_vec(1,d))^2 + (task_result(1,d+1) - task_result(1,d))^2);
        end

        distance_travelled = sum(travelled_dist);
        AUC = trapz(task_result);
    catch
       fid = fopen([save_dir '\Error_report.txt'], 'a');
       fprintf(fid, ['\nAn error occurred in performance calculation for block ' num2str(I) ' of ' exercise ' exercise. Compute offline\n']);
       fclose(fid);
       distance_travelled = 0;
       AUC = 0;
    end
    
end