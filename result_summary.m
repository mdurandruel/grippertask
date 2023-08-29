function [Total_sequences] = result_summary(Task_results)
Task_results_cell = struct2cell(Task_results);
Total_sequences = nnz(cell2mat(Task_results_cell(14,:)));
% Mean_values = cell2mat(Task_results_cell(9,:));
% Mean_error_all = mean(Mean_values);
end