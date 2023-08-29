function Y = map_bar(joy, relax, Max_force)
    global t_param
    
    y = axis(joy, 2) - relax;
%     disp(y)
    %Condition editted 16.10.2018. threshold as percentage of max force.
    %Original condition is y > - t_param.home_threshold
    if y > t_param.home_threshold*Max_force
        y = 0;
    end
    %Value mapping
%     A = relax;
    A = 0;
    B = Max_force * t_param.top_bar_force;
    C = t_param.bary; %Lower bound
    D = t_param.ML; %Upper bound

    Y = (y - A)/(B - A) * (D - C) + C;
end