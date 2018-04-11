% function [varNames, varValues] = outputSummaryFromStructure(p)

% function SpecifiedArgs=BerniotisParseArgs(ListenerName,varargin)
clear
p=BerniotisParseArgs('L01','OutputDir', 'fuzzy')

[varNames, varValues] = outputSummaryFromStructure(p)



return
allTheFields = fieldnames(p);
% output all the field names on one row
for i=1:length(allTheFields)
    fprintf('%s,', allTheFields{i})
end
fprintf('\n')

for i=1:length(allTheFields)
    xx = getfield(p,allTheFields{i});
    if ischar(xx)
        fprintf('%s,', xx);
    else
        fprintf('%g,', xx);
    end
end
fprintf('\n')


return


return

