function [brothers] = brothersSearch(F,s)
    col=F(:,s);
    rowTemp=0;
    brothers=[]; %initialization
    if s~=1
        for ii=1:length(col)
            if col(ii)==1
                rowTemp=ii;
                break;
            end
        end

        row=F(rowTemp,:);
        for ii=1:length(row)
            if row(ii)==1 && ii~=s
                if isempty(brothers)
                    brothers=ii;
                else
                    brothers=[brothers ii];
                end
            end
        end
    end
end