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
timetable0 = table('Size', [n*n*n*n, 7], ...
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
                
                try
                    % Run the study
                 
                    yes = 1;

                catch exception
                    disp(['Error message: ' exception.message]);
                    yes = 0;
                end

                % Record completion time and duration
                completion = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
                disp(['Current time: ' char(completion)]);

                time = toc;

                % Store the results in the timetable
                timetable0(row_index, :) = {KN, DN, KP, DP, time, completion, yes};

                % Increment row index
                row_index = row_index + 1;
            end
        end
    end
end

% Display the timetable
disp(timetable0);