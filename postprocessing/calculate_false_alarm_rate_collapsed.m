function falseAlarmRate = calculate_false_alarm_rate_collapsed(responses,SubjectList,nS, mean_stim_streams)

for subject = 1:nS
    sessions = 6;
    
    subjectID =  SubjectList(subject);
    if subjectID == 26
        sessions = 5;
    end
    for sessionID = 1:sessions
        for condition = 1:4
            
            
            time_ITI_sec =   sum(mean_stim_streams{subjectID,sessionID}(:,condition) == 0)/100;
            
            
            FA_num = sum(responses(:,7) == 2 & responses(:,9) == condition & responses(:,10) == sessionID & responses(:,11) == subjectID);
            
            FA_rate(sessionID, subjectID, condition) = FA_num/time_ITI_sec;
            
            
        end
    end

    
    FA_rateLong = FA_rate(:, subjectID, [2,4]);
    FA_rateShort = FA_rate(:, subjectID, [1,3]);
    
    FA_rateLong = squeeze(FA_rateLong);
    FA_rateShort = squeeze(FA_rateShort);
    

    % mean per subject
    subjectLevelLong(1,subject) = mean(FA_rateLong(:));
    subjectLevelShort(1,subject) = mean(FA_rateShort(:));
    
    
    
end


%%%% This is for excluding outliers 
mean_FA_rate_total = mean([subjectLevelLong, subjectLevelShort]);
sd_FA_rate_total = 2 * std([subjectLevelLong, subjectLevelShort]);
% 
[~,sj_idLong] = find(subjectLevelLong>= mean_FA_rate_total + sd_FA_rate_total);
subjectLevelLong(:,sj_idLong) = [];

[~,sj_idShort] = find(subjectLevelShort>= mean_FA_rate_total + sd_FA_rate_total);
subjectLevelShort(:,sj_idShort) = [];
    
    groupLevelLong = mean(subjectLevelLong);
    groupLevelShort = mean(subjectLevelShort);   
    %se_FA_rate_all(condition) = std(subjectLevel(condition,:))/sqrt(nS);


falseAlarmRate.subjectLevelLong = subjectLevelLong;
falseAlarmRate.subjectLevelShort= subjectLevelShort;

falseAlarmRate.groupLevelLong = groupLevelLong;
falseAlarmRate.groupLevelShort = groupLevelShort;


% y = [[FA_rate_sj(1,:)';FA_rate_sj(2,:)'],[FA_rate_sj(3,:)';FA_rate_sj(4,:)']];
%
% [p,tbl,stats] = anova2(y,length(FA_rate_sj(1,:)));


end
