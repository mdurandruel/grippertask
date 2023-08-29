function [top_bar, base_bar, ball_x, ball_y, patchhand, pr_vec_sep, white_numbers,...
  all_bars, barin_x, barout_x, barin_y,barout_y, seq_bar_real, rand_bar_real] = make_bars_n_arrows(exercise, task, I)


%This function builds the bars, the arrow and the ball for the task. The
%involved parameters may be modified in setup_parameters.m

global t_param

axis manual

barx = t_param.barx;
bary = t_param.bary;
barw = t_param.barw;
ML = t_param.ML;

%Base bar
pstn_x_base = [barx, barx + barw, barx + barw, barx];
pstn_y_base = [0, 0, t_param.base_bar_y_pos, t_param.base_bar_y_pos];

%Top bar
pstn_x = [barx, barx + barw, barx + barw, barx];
pstn_y = [ML + bary, ML + bary,ML - bary, ML - bary];

%Make bars
top_bar = patch(pstn_x, pstn_y, t_param.target_color,'LineWidth', 2.8);
base_bar = patch(pstn_x_base, pstn_y_base, t_param.base_color,'LineWidth', 2.8);

% if I == t_param.random_block
%     for i= 1:5
%         if contains(exercise,string(i))== 1
%         pr_vec = ML * t_param.force_per_rand(i,:)'; %Force percentages for each bar     
%         pr_vec_sc = pr_vec ./ t_param.top_bar_force;
%         pr_vec_sep = repmat(pr_vec_sc,1,4);
%         end
%     end
% else

pr_vec = ML * t_param.force_per'; %Force percentages for each bar
pr_vec_sc = pr_vec ./ t_param.top_bar_force;
pr_vec_sep = repmat(pr_vec_sc,1,4);
% end

patchhand = {t_param.nbar};
for i=1:t_param.nbar
   patchhand{i} = patch(pstn_x, pr_vec_sep(i,:) - [-bary, -bary, bary, bary], t_param.target_color,'LineWidth', 2.8);
end
axis off

all_bars = {patchhand{1,4}, patchhand{1,3}, patchhand{1,2}, patchhand{1,1}, top_bar, base_bar};

%Make the validation bars
barin_x = [t_param.barx + 0.01, t_param.barx + t_param.barw - 0.01, t_param.barx + t_param.barw - 0.01, t_param.barx + 0.01];
barout_x = [t_param.barx - 0.01, t_param.barx + t_param.barw + 0.01, t_param.barx + t_param.barw + 0.01, t_param.barx - 0.01];
barin_y = zeros(5,4);
barout_y = zeros(5,4);
for i= 1:5
    barin_y(i,:) = [all_bars{i}.Vertices(3,2) + 0.01, all_bars{i}.Vertices(3,2) + 0.01, all_bars{i}.Vertices(1,2) - 0.01, all_bars{i}.Vertices(1,2) - 0.01];
    barout_y(i,:) = [all_bars{i}.Vertices(3,2) - 0.01, all_bars{i}.Vertices(3,2) - 0.01, all_bars{i}.Vertices(1,2) + 0.01, all_bars{i}.Vertices(1,2) + 0.01];
end

%Generate sequence to be completed
[seq_bar_real, rand_bar_real] = seq_gen(exercise,task);
if I == t_param.random_block
    num_set = rand_bar_real;
else
    num_set = seq_bar_real;
end
y_coord = [patchhand{4}.Vertices(3,2); patchhand{3}.Vertices(3,2);...
    patchhand{2}.Vertices(3,2); patchhand{1}.Vertices(3,2); top_bar.Vertices(3,2)];
num_num = 1;

%Print bar numbers
white_numbers = gobjects(1,5);
for n = num_set
    white_numbers(1,num_num) = text(pstn_x(1) - t_param.num_pos, y_coord(n,1) + bary, num2str(num_num),...
        'FontUnits', 'Normalized', 'FontSize', 0.07, 'Color', [1, 1, 1]);
    num_num = num_num + 1;
end


%Build ball
arc = linspace(0, 2*pi);
ball_x = t_param.r * cos(arc) + 0.5;
ball_y = t_param.r * sin(arc);

pbaspect([1, 1, 1])

end