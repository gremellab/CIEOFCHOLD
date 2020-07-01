function [Prime] = findSigChangePerformance_dPrime(Table)

%%%%%%%%%%%%%%%%%%%
%   All Units
%
%%%%%%%%%%%%%%%%%%%
sigs_PreLP = [];
sigs_PostLP = [];
%%Success vs Failure
%% Before LP Onset
for unit = 1:max(Table.All_Units_Array_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% After LP Offset
for unit = 1:max(Table.All_Units_Array_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_Success_vs_Failure = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
Prime.postLP_Success_vs_Failure = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% After Success vs After Failure
sigs_PreLP = [];
sigs_PostLP = [];
%% Before LP Onset
for unit = 1:max(Table.All_Units_Array_After_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_After_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_After_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_After_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_After_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_After_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_After_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_After_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_After_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% After LP Offset
for unit = 1:max(Table.All_Units_Array_After_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_After_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_After_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_After_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_After_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_After_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_After_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_After_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_After_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_After_Success_vs_After_Failure = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
Prime.postLP_After_Success_vs_After_Failure = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});


%% After Success Success vs After Success Failure
sigs_PreLP = [];
sigs_PostLP = [];
%% Before LP Onset
for unit = 1:max(Table.All_Units_Array_After_Success_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_After_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_After_Success_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_After_Success_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_After_Success_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_After_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_After_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_After_Success_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_After_Success_Success.File(duration_idxs_success));
    
    try
    [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit
        h = 0;
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end
end
%% After LP Offset
for unit = 1:max(Table.All_Units_Array_After_Success_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_After_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_After_Success_Failure.Unit == unit);
    
    success_FRs = Table.All_Units_Array_After_Success_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_After_Success_Failure.PostLPRate(duration_idxs_failure);
    
    True_Unit = unique(Table.All_Units_Array_After_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_After_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_After_Success_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_After_Success_Success.File(duration_idxs_success));
    try
        [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit
        h = 0;
        if h == 1
            sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end
end
%% Turn into Table
Prime.preLP_After_Success_Success_vs_After_Success_Failure = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
Prime.postLP_After_Success_Success_vs_After_Success_Failure = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% After Failure Success vs After Failure Failure
sigs_PreLP = [];
sigs_PostLP = [];
%% Before LP Onset
for unit = 1:max(Table.All_Units_Array_After_Failure_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_After_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_After_Failure_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_After_Failure_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_After_Failure_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_After_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_After_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_After_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_After_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% After LP Offset
for unit = 1:max(Table.All_Units_Array_After_Failure_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_After_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_After_Failure_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_After_Failure_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_After_Failure_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_After_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_After_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_After_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_After_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_After_Failure_Success_vs_After_Failure_Failure = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
Prime.postLP_After_Failure_Success_vs_After_Failure_Failure = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});



%% Before Success Success vs Before Success Failure
sigs_PreLP = [];
sigs_PostLP = [];
%% Before LP Onset
for unit = 1:max(Table.All_Units_Array_Before_Success_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_Before_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_Before_Success_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_Before_Success_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_Before_Success_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_Before_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_Before_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_Before_Success_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_Before_Success_Success.File(duration_idxs_success));
    try
        [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit
        h = 0;
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end
end
%% After LP Offset
for unit = 1:max(Table.All_Units_Array_Before_Success_Failure.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_Before_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_Before_Success_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_Before_Success_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_Before_Success_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_Before_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_Before_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_Before_Success_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_Before_Success_Success.File(duration_idxs_success));
    try
        [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit
        h = 0;
        if h == 1
            sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end
end
%% Turn into Table
Prime.preLP_Before_Success_Success_vs_Before_Success_Failure = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
Prime.postLP_Before_Success_Success_vs_Before_Success_Failure = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% Before Failure Success vs Before Failure Failure
sigs_PreLP = [];
sigs_PostLP = [];
%% Before LP Onset
for unit = 1:max(Table.All_Units_Array_Before_Failure_Success.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_Before_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_Before_Failure_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_Before_Failure_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_Before_Failure_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_Before_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_Before_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_Before_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_Before_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% After LP Offset
for unit = 1:max(Table.All_Units_Array_Before_Failure_Failure.Unit)
    
    duration_idxs_success = find(Table.All_Units_Array_Before_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.All_Units_Array_Before_Failure_Failure.Unit == unit);

    success_FRs = Table.All_Units_Array_Before_Failure_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.All_Units_Array_Before_Failure_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.All_Units_Array_Before_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.All_Units_Array_Before_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.All_Units_Array_Before_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.All_Units_Array_Before_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_Before_Failure_Success_vs_Before_Failure_Failure = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
Prime.postLP_Before_Failure_Success_vs_Before_Failure_Failure = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});































%%%%%%%%%%%%%%%%%%%
%   Sig Unit Types
%   LP ON
%%%%%%%%%%%%%%%%%%%
%% LP ON Up Units
sigs_PreLP = [];
%%Success vs Failure
%% Before LP Onset
for unit = 1:max(Table.LP_ON_Up_Units_Array_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Up_Units_Array_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Up_Units_Array_Failure.Unit == unit);

    success_FRs = Table.LP_ON_Up_Units_Array_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Up_Units_Array_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_ON_Up_Units_Array_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Up_Units_Array_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Up_Units_Array_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Up_Units_Array_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_Success_vs_Failure_LPON_Up = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP ON Down Units
sigs_PreLP = [];
%%Success vs Failure
%% Before LP Onset
for unit = 1:max(Table.LP_ON_Down_Units_Array_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Down_Units_Array_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Down_Units_Array_Failure.Unit == unit);

    success_FRs = Table.LP_ON_Down_Units_Array_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Down_Units_Array_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_ON_Down_Units_Array_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Down_Units_Array_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Down_Units_Array_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Down_Units_Array_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_Success_vs_Failure_LPON_Down = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});

%% LP ON Up Units
%% After Success vs After Failure
sigs_PreLP = [];
%% Before LP Onset
for unit = 1:max(Table.LP_ON_Up_Units_Array_After_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Up_Units_Array_After_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Up_Units_Array_After_Failure.Unit == unit);

    success_FRs = Table.LP_ON_Up_Units_Array_After_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Up_Units_Array_After_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_ON_Up_Units_Array_After_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Up_Units_Array_After_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Up_Units_Array_After_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Up_Units_Array_After_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_After_Success_vs_After_Failure_LPON_Up = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});

%% LP ON Down Units
%% After Success vs After Failure
sigs_PreLP = [];
%% Before LP Onset
for unit = 1:max(Table.LP_ON_Down_Units_Array_After_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Down_Units_Array_After_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Down_Units_Array_After_Failure.Unit == unit);

    success_FRs = Table.LP_ON_Down_Units_Array_After_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Down_Units_Array_After_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_ON_Down_Units_Array_After_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Down_Units_Array_After_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Down_Units_Array_After_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Down_Units_Array_After_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_After_Success_vs_After_Failure_LPON_Down = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP ON Up Units
%% After Success Success vs After Success Failure
sigs_PreLP = [];
%% Before LP Onset
for unit = 1:max(Table.LP_ON_Up_Units_Array_After_Success_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Up_Units_Array_After_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Up_Units_Array_After_Success_Failure.Unit == unit);
    
    success_FRs = Table.LP_ON_Up_Units_Array_After_Success_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Up_Units_Array_After_Success_Failure.PreLPRate(duration_idxs_failure);
    
    True_Unit = unique(Table.LP_ON_Up_Units_Array_After_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Up_Units_Array_After_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Up_Units_Array_After_Success_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Up_Units_Array_After_Success_Success.File(duration_idxs_success));
    
    try
        [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit;
        h = 0;
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end 
end
%% Turn into Table
Prime.preLP_After_Success_Success_vs_After_Success_Failure_LPON_Up = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP ON Down Units
%% After Success Success vs After Success Failure
sigs_PreLP = [];
%% Before LP Onset
for unit = 1:max(Table.LP_ON_Down_Units_Array_After_Success_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Down_Units_Array_After_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Down_Units_Array_After_Success_Failure.Unit == unit);
    
    success_FRs = Table.LP_ON_Down_Units_Array_After_Success_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Down_Units_Array_After_Success_Failure.PreLPRate(duration_idxs_failure);
    
    True_Unit = unique(Table.LP_ON_Down_Units_Array_After_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Down_Units_Array_After_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Down_Units_Array_After_Success_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Down_Units_Array_After_Success_Success.File(duration_idxs_success));
    try
        [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit;
        h = 0;
        if h == 1
            sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end
    
end
%% Turn into Table
Prime.preLP_After_Success_Success_vs_After_Success_Failure_LPON_Down = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});

%% LP ON Up Units
%% After Failure Success vs After Failure Failure
sigs_PreLP = [];
%% Before LP Onset
for unit = 1:max(Table.LP_ON_Up_Units_Array_After_Failure_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Up_Units_Array_After_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Up_Units_Array_After_Failure_Failure.Unit == unit);

    success_FRs = Table.LP_ON_Up_Units_Array_After_Failure_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Up_Units_Array_After_Failure_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_ON_Up_Units_Array_After_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Up_Units_Array_After_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Up_Units_Array_After_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Up_Units_Array_After_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_After_Failure_Success_vs_After_Failure_Failure_LPON_Up = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP ON Down Units
%% After Failure Success vs After Failure Failure
sigs_PreLP = [];
%% After LP Offset
for unit = 1:max(Table.LP_ON_Down_Units_Array_After_Failure_Success.Unit)
    
    duration_idxs_success = find(Table.LP_ON_Down_Units_Array_After_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_ON_Down_Units_Array_After_Failure_Failure.Unit == unit);

    success_FRs = Table.LP_ON_Down_Units_Array_After_Failure_Success.PreLPRate(duration_idxs_success);
    failure_FRs = Table.LP_ON_Down_Units_Array_After_Failure_Failure.PreLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_ON_Down_Units_Array_After_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_ON_Down_Units_Array_After_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_ON_Down_Units_Array_After_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.LP_ON_Down_Units_Array_After_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PreLP = [sigs_PreLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.preLP_After_Failure_Success_vs_After_Failure_Failure_LPON_Down = array2table(sigs_PreLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});


%%%%%%%%%%%%%%%%%%%
%   Sig Unit Types
%   LP OFF
%%%%%%%%%%%%%%%%%%%
%% LP OFF Up Units
sigs_PostLP = [];
%%Success vs Failure
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Up_Units_Array_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Up_Units_Array_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Up_Units_Array_Failure.Unit == unit);

    success_FRs = Table.LP_OFF_Up_Units_Array_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Up_Units_Array_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_OFF_Up_Units_Array_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Up_Units_Array_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Up_Units_Array_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Up_Units_Array_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.postLP_Success_vs_Failure_LPOFF_Up = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP OFF Down Units
sigs_PostLP = [];
%%Success vs Failure
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Down_Units_Array_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Down_Units_Array_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Down_Units_Array_Failure.Unit == unit);

    success_FRs = Table.LP_OFF_Down_Units_Array_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Down_Units_Array_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_OFF_Down_Units_Array_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Down_Units_Array_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Down_Units_Array_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Down_Units_Array_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.postLP_Success_vs_Failure_LPOFF_Down = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});

%% LP OFF Up Units
%% After Success vs After Failure
sigs_PostLP = [];
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Up_Units_Array_After_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Up_Units_Array_After_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Up_Units_Array_After_Failure.Unit == unit);

    success_FRs = Table.LP_OFF_Up_Units_Array_After_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Up_Units_Array_After_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_OFF_Up_Units_Array_After_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Up_Units_Array_After_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Up_Units_Array_After_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Up_Units_Array_After_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.postLP_After_Success_vs_After_Failure_LPOFF_Up = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});

%% LP OFF Down Units
%% After Success vs After Failure
sigs_PostLP = [];
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Down_Units_Array_After_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Down_Units_Array_After_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Down_Units_Array_After_Failure.Unit == unit);

    success_FRs = Table.LP_OFF_Down_Units_Array_After_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Down_Units_Array_After_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_OFF_Down_Units_Array_After_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Down_Units_Array_After_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Down_Units_Array_After_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Down_Units_Array_After_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.postLP_After_Success_vs_After_Failure_LPOFF_Down = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP OFF Up Units
%% After Success Success vs After Success Failure
sigs_PostLP = [];
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Up_Units_Array_After_Success_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Up_Units_Array_After_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Up_Units_Array_After_Success_Failure.Unit == unit);
    
    success_FRs = Table.LP_OFF_Up_Units_Array_After_Success_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Up_Units_Array_After_Success_Failure.PostLPRate(duration_idxs_failure);
    
    True_Unit = unique(Table.LP_OFF_Up_Units_Array_After_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Up_Units_Array_After_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Up_Units_Array_After_Success_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Up_Units_Array_After_Success_Success.File(duration_idxs_success));
    try
        [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit;
        h = 0;
        if h == 1
            sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end
end
%% Turn into Table
Prime.postLP_After_Success_Success_vs_After_Success_Failure_LPOFF_Up = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP OFF Down Units
%% After Success Success vs After Success Failure
sigs_PostLP = [];
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Down_Units_Array_After_Success_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Down_Units_Array_After_Success_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Down_Units_Array_After_Success_Failure.Unit == unit);
    
    success_FRs = Table.LP_OFF_Down_Units_Array_After_Success_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Down_Units_Array_After_Success_Failure.PostLPRate(duration_idxs_failure);
    
    True_Unit = unique(Table.LP_OFF_Down_Units_Array_After_Success_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Down_Units_Array_After_Success_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Down_Units_Array_After_Success_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Down_Units_Array_After_Success_Success.File(duration_idxs_success));
    try
        [p,h] = ranksum(success_FRs,failure_FRs);
        if h == 1
            sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    catch
        unit;
        h = 0;
        if h == 1
            sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
        end
    end
end
%% Turn into Table
Prime.postLP_After_Success_Success_vs_After_Success_Failure_LPOFF_Down = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});

%% LP OFF Up Units
%% After Failure Success vs After Failure Failure
sigs_PostLP = [];
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Up_Units_Array_After_Failure_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Up_Units_Array_After_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Up_Units_Array_After_Failure_Failure.Unit == unit);

    success_FRs = Table.LP_OFF_Up_Units_Array_After_Failure_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Up_Units_Array_After_Failure_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_OFF_Up_Units_Array_After_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Up_Units_Array_After_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Up_Units_Array_After_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Up_Units_Array_After_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.postLP_After_Failure_Success_vs_After_Failure_Failure_LPOFF_Up = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});
%% LP OFF Down Units
%% After Failure Success vs After Failure Failure
sigs_PostLP = [];
%% After LP Offset
for unit = 1:max(Table.LP_OFF_Down_Units_Array_After_Failure_Success.Unit)
    
    duration_idxs_success = find(Table.LP_OFF_Down_Units_Array_After_Failure_Success.Unit == unit);
    duration_idxs_failure = find(Table.LP_OFF_Down_Units_Array_After_Failure_Failure.Unit == unit);

    success_FRs = Table.LP_OFF_Down_Units_Array_After_Failure_Success.PostLPRate(duration_idxs_success);
    failure_FRs = Table.LP_OFF_Down_Units_Array_After_Failure_Failure.PostLPRate(duration_idxs_failure);

    True_Unit = unique(Table.LP_OFF_Down_Units_Array_After_Failure_Success.True_Unit(duration_idxs_success));
    Mouse = unique(Table.LP_OFF_Down_Units_Array_After_Failure_Success.Mouse(duration_idxs_success));
    Session = unique(Table.LP_OFF_Down_Units_Array_After_Failure_Success.Session(duration_idxs_success));
    File = unique(Table.LP_OFF_Down_Units_Array_After_Failure_Success.File(duration_idxs_success));
    
    [p,h] = ranksum(success_FRs,failure_FRs);
    if h == 1
        sigs_PostLP = [sigs_PostLP ; Mouse Session True_Unit unit File];%Table.All_Units_Array_Success.True_Unit(duration_idxs_success)];
    end
end
%% Turn into Table
Prime.postLP_After_Failure_Success_vs_After_Failure_Failure_LPOFF_Down = array2table(sigs_PostLP,'VariableNames',{'Mouse','Session', 'True_Unit', 'Unit', 'File'});







end


