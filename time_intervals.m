function [des_t, init_t, t_init, t_des] = time_intervals(tt_bar, samp_time, task_result)

    des_t = zeros(1, length(tt_bar));
    init_t = zeros(1, length(tt_bar));
%     fin_t = zeros(1, length(tt_bar));
    mark_bar = zeros(1, length(tt_bar));
    t_init = zeros(1, length(tt_bar));
    t_des = zeros(1, length(tt_bar));
    
    for i = 2:2:length(tt_bar)
        des_t(1,i) = find(samp_time >= tt_bar(1,i),1);
        mark_bar(1,i) = task_result(1,des_t(1,i));
        vect_2_sweep_b = flipud(task_result(1,1:des_t(1,i))');
        if isempty(find(vect_2_sweep_b <= mark_bar(1,i) - (mark_bar(1,i)/10),1))
            init_t(1,i) = des_t(1,i) - 10;
        else
            init_t(1,i) = length(vect_2_sweep_b) - find(vect_2_sweep_b <= mark_bar(1,i) - (mark_bar(1,i)/10),1);
        end
        t_init(1,i) = samp_time(init_t(1,i));
        t_des(1,i) = tt_bar(1,i);
    end
    
%     rise_fall = abs(diff(task_result));
%     [B,idx] = sort(rise_fall,'descend');
%     rise_fall_times = samp_time(sort(idx(1,1:10)));
    
end