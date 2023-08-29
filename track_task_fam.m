function [recorded_grip, nb_trials, el_block_time, el_trial_time, val_save_trial, el_reach_time, val_save_reach, outcome_block, tt_bar, val_save, ball_distance] = track_task_fam(ball_x, ball_y, relax,...
        Max_force, seq_bar_real, all_bars, barin_x, barout_x, barin_y,barout_y)
%This function contains the tracking task

global t_param


%% Initialisation of variables

barin = cell(1,5);
barout = cell(1,5);



banner = 1;
nf_trials = t_param.n_trials;
nb_trials = 0;

max_time = t_param.max_time; 
el_block_time = 0;
el_trial_time = zeros(1,length(nf_trials));   % From when the ball leaves the HZ to when it re enters
val_save_trial = zeros(1,length(nf_trials));
tt_bar = zeros(1,length(nf_trials));
el_reach_time = zeros(1,length(nf_trials));
val_save_reach = zeros(1,length(nf_trials));
ball_distance = zeros(1,length(nf_trials));
%el_home_zone_time_in =zeros(1,length(nf_trials));
%el_home_zone_time_out =zeros(1,length(nf_trials));
test = 0;
test2=0;

outcome_block = strings(1,15);

ball_base = ball_y;


recorded_grip = zeros(1,1000000);                       %Memory allocation for recording
val_save = 1;

used_bar_real = seq_bar_real;

%% The main experiment
start_time = tic;

 while (1)
    Y_c = map_bar(t_param.joy, relax, Max_force); 
    recorded_grip(1, val_save) = Y_c;
    ball_y = ball_base + Y_c;
    ball = patch(ball_x, ball_y, t_param.ball_color);
    drawnow
    val_save = val_save + 1;
 
    delete(ball)
    
    %% Check if the sequence is finished. If 3 sequences are finished, we go out of the function
    if  banner > numel (used_bar_real) && test == 0
        assert (rem (nb_trials, 5) == 0)
        for k = 1:5
            delete(barin{1,k});
            delete(barout{1,k});
        end
        
        if nb_trials == nf_trials
           el_block_time = toc(start_time);
           return
        end
        banner = 1;
    end
    
    % Assign the new bar number if the 3 sequences are not finished
    if banner <= numel (used_bar_real)
        barreal = used_bar_real(banner);
    end
    % disp (barreal)
    
    
   %% Three different possibilities: 1-The ball is in the home zone. 2-The ball is outside of the correct target. 3-The ball is inside the correct target
    
    
   % 1-When the ball is in the home zone
    if Y_c <= t_param.base_bar_y_pos
        if test == 1
            tt_bar(nb_trials)=toc(start_time);
            el_trial_time(nb_trials) = toc(black_time);
            val_save_trial(nb_trials) = val_save;
            set(all_bars{6},'FaceColor', t_param.base_color);
            test2 =0;
        end
        test = 0;
    end    
   % When the ball leave the home zone, start timer for each trial
    if (Y_c > t_param.base_bar_y_pos && test2 == 0)
       black_time = tic;
    end
   
    % 2-When the ball is outside of the correct target
    while ( Y_c > t_param.base_bar_y_pos && (Y_c < all_bars{barreal}.Vertices(3,2) || Y_c > all_bars{barreal}.Vertices(1,2)) && test == 0)
        test2 = 1;
        delete(ball)
        Y_c = map_bar(t_param.joy, relax, Max_force);
        recorded_grip(1, val_save) = Y_c;
        ball_y = ball_base + Y_c;
        ball = patch(ball_x, ball_y, t_param.ball_color);
        drawnow
        val_save = val_save + 1;

        if val_save > max_time && std(recorded_grip((val_save - max_time):(val_save-1))) == 0

            barout{1,barreal} =  patch(barout_x, barout_y(barreal,:),[0.40, 0.40, 0.40],'LineWidth', 2.8);
            barin{1,barreal} = patch(barin_x, barin_y(barreal,:),[1, 1, 1]);

            set(all_bars{6},'FaceColor', [1, 1, 1]);
            
            ball_distance(nb_trials+1) = abs(Y_c - (all_bars{barreal}.Vertices(3,2)+ 0.02));
            banner = banner + 1;
            nb_trials = nb_trials +1; % wrong trial
            test = 1;
            el_reach_time(nb_trials) = toc(black_time);
            val_save_reach(nb_trials) = val_save;
            outcome_block(nb_trials)= 'Incorrect';
            break;
        end
    end

    % 3-When the ball is inside the correct target
    t0 = val_save;
    disp(t0)
    while (Y_c > t_param.base_bar_y_pos && Y_c >= all_bars{barreal}.Vertices(3,2) && Y_c <= all_bars{barreal}.Vertices(1,2) && test == 0)
        disp(t0)
        test2 = 1;
        delete(ball)
        Y_c = map_bar(t_param.joy, relax, Max_force);
        recorded_grip(1, val_save) = Y_c;
        ball_y = ball_base + Y_c;
        ball = patch(ball_x, ball_y, t_param.ball_color);
        drawnow
        val_save = val_save + 1;

        if val_save - t0 >= max_time-1

            barout{1,barreal} =  patch(barout_x, barout_y(barreal,:),[0.89, 0.89, 0.89],'LineWidth', 2.8);
            barin{1,barreal} = patch(barin_x, barin_y(barreal,:),[1, 1, 1]);

            set(all_bars{6},'FaceColor', [1, 1, 1]);
            ball_distance(nb_trials+1) = abs(Y_c - (all_bars{barreal}.Vertices(3,2)+ 0.02));
            banner = banner + 1;
            nb_trials= nb_trials +1; % successful trial
            test = 1;
            el_reach_time(nb_trials)=toc(black_time);
            val_save_reach(nb_trials) = val_save;
            outcome_block(nb_trials)= 'Correct';
            break;
        end 
    end
    
    delete(ball)

 end
end