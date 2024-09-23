% Define parameter ranges and step count
a = 1e-12;
b = 1e-10;
c = 1e-15;
d = 1e-13;
n = 4;

% Generate parameter values
Kn_values = linspace(a, b, n);
Dn_values = linspace(c, d, n);
Kp_values = linspace(a, b, n);
Dp_values = linspace(c, d, n);

% Initialize the timetable
timetable = table('Size', [n*n*n*n, 7], ...
   'VariableTypes', {'double', 'double', 'double', 'double', 'double', 'datetime', 'double'}, ...
   'VariableNames', {'KN', 'DN', 'KP', 'DP', 'time', 'completion', 'yes'});

row_index = 1;

% Nested loops to iterate through all combinations of parameter values
for i = 1:n
    for j = 1:n
        for k = 1:n
            for l = 1:n

                tic; % Start timer
                
                % Assign parameter values
                KN = Kn_values(i);
                DN = Dn_values(j);
                KP = Kp_values(k);
                DP = Dp_values(l);
        
                % Open the model
                model = mphopen('train1.mph');

                % Set model parameters
                model.param.set('k_n', [num2str(KN),'[m/s]']);
                model.param.set('Ds_n', [num2str(DN),'[m^2/s]']);
                model.param.set('k_p', [num2str(KP),'[m/s]']);
                model.param.set('Ds_p', [num2str(DP),'[m^2/s]']);

                try
                    % Run the study
                    model.study('std1').run;
                    yes = 1;

                    % Define filename for exporting results
                    filenameE = sprintf('D:\\project\\battery-final\\LMO\\traindata1\\E%d.csv', row_index);

                    % Export the results
                    model.result().export("plot1").set("filename", filenameE);
                    model.result().export("plot1").run();

                catch exception
                    disp(['Error message: ' exception.message]);
                    yes = 0;
                end

                % Record completion time and duration
                completion = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
                disp(['Current time: ' char(completion)]);

                time = toc;

                % Store the results in the timetable
                timetable(row_index, :) = {KN, DN, KP, DP, time, completion, yes};

                % Increment row index
                row_index = row_index + 1;
            end
        end
    end
end

% Display the timetable
disp(timetable);