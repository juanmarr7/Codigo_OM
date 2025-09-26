%T = readtable('/Volumes/TOSHIBA EXT/Optical mapping/Mice/Marato_Set2/R82Wnew2/ECG/ECG.csv','NumHeaderLines',6,'PreserveVariableNames',true);  % skips the first three rows of data

T = readtable('/Users/liliangutierrez/Desktop/OMcode/ECG.csv','NumHeaderLines',6,'PreserveVariableNames',true);  % skips the first three rows of data
figure
plot(T.("AI0 (V)"),'k','LineWidth',1.0); xlim([0 10000]);ylim([0 5]); grid off; title('Optical ECG')

TIME=T.("Date/Time"); 
TIMEDIFF =  TIME(2)-TIME(1);


total = length(T.("AI0 (V)"));
x = 0:2:9;
1000000/0.00005
            XTime = 0.00005:0.00005:(1000000*0.00005);
