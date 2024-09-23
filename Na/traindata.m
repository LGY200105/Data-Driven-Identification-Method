
a = 1e-12;
b = 1e-9;
c = 1e-17;
d = 1e-14;
n = 10;

K_values = linspace(a, b, n);
D_values = linspace(c, d, n);

timetable = table('Size', [n*n, 5], ...
   'VariableTypes', {'double', 'double', 'double', 'datetime', 'double'}, ...
   'VariableNames', {'KP', 'DP', 'time', 'completion', 'yes'});

row_index = 1;

for i = 1:n
    for j = 1:n
        tic;
        KP = K_values(i);
        DP = D_values(j);
        
        model = mphopen('train.mph');

%        model.param.set('sigmal', '6[mS/cm]');
%        model.param.set('k_p', '2.75E-11[m/s]');
%        model.param.set('Ds_p', '2.51E-15[m^2/s]');
 %       model.param.set('Dl', '7E-11[m^2/s]');
        model.param.set('k_p', [num2str(KP),'[m/s]']);
        model.param.set('Ds_p', [num2str(DP),'[m^2/s]']);

        try
            model.study('std3').run;
            yes = 1;
            filenameE = sprintf('D:\\project\\battery-final\\Na\\traindata\\E%d.csv', row_index);
 %           filenameC = sprintf('D:\\project\\battery\\Na_id\\Na0701\\C%d.csv', row_index);
 %           model.result().export().create("plot41", "Plot");
 %           model.result.export('plot41').set('plotgroup', 'pg6');
%           model.result.export('plot41').set('plot', 'lngr1');
 %           model.result.export('plot41').set('filename', filenameE);
 %           model.result.export('plot41').set('multiplecurves', 'ascolumns');
 %           model.result.export('plot41').set('separator', ',');
  %          model.result().export("plot41").run();


   %         model.result().export("plot1").set("plotgroup", "pg9");
   %         model.result().export("plot1").set("plot", "lngr1");
            model.result().export("plot1").set("filename", filenameE);
   %         model.result().export("plot1").set("separator", ",");
            model.result().export("plot1").run();

   %         model.result().export("plot2").set("plotgroup", "pg6");
   %         model.result().export("plot2").set("filename", filenameE);
   %         model.result().export("plot2").run();

            catch exception
                disp(['错误消息：' exception.message]);
                yes = 0;
        end
        completion = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
        disp(['当前时间：' char(completion)]);

        time = toc;

        timetable(row_index, :) = {KP, DP, time, completion, yes};

        row_index = row_index + 1;
    end
end