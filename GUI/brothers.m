%funzione per mettere a zero i fratelli di s (ed i loro figli) nel calcolo di r (forma sequenza equivalente agent)
function [r] = brothers(F,s,r2)
    col=F(:,s);
    rowTemp=0;
    for ii=1:length(col)
        if col(ii)==1
            rowTemp=ii; %trovata la riga nel quale s avrà fratelli
            break;
        end
    end
    
    brothers=[];
    row=F(rowTemp,:);
    for ii=1:length(row)
        if row(ii)==1 && ii~=s
            brothers=[brothers ii];
        end
    end
    
    if isempty(brothers)~=1
        for ii=1:length(brothers)
            r2(brothers(ii))=0;
            cList=childrenSearch(brothers(ii),F,1);
            if isempty(cList)~=1
                for jj=1:length(cList)
                    r2(cList(jj))=0;
                end
            end
        end
    end
    
    
    r=r2;
end

