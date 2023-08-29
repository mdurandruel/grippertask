function [seq_bar_real, rand_bar_real] = seq_gen(exercise,task)
% This function generates the target sequence to be completed

if strcmp(task, 'A')
    seq_bar_real = [3, 1, 4, 2, 5];
    rand_bar_real = [1, 5, 2, 4, 3];
elseif strcmp(task, 'B')
    seq_bar_real = [2, 1, 5, 3, 4];
    rand_bar = [4, 5, 2, 1, 3;...
                1, 3, 4, 2, 5;...
                3, 4, 1, 5, 2;...
                5, 1, 3, 2, 4;...
                2, 5, 3, 4, 1];

    for i= 1:5
        if contains(exercise,string(i))== 1
        rand_bar_real = rand_bar(i,:);
        end
    end
end

end