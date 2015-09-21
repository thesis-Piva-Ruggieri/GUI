%funzione per cercare i figli; cerca solo i figli di primo livello
function [children] = childrenSearch(s,F,~) %se ~ non è dato come input calcola solo i figli di primo livello, se no calcola tutti i figli di s, a qualsiasi livello
    col=F(:,s);
    rowTemp=[];
    children=[];
    for ii=1:length(col)
        if col(ii)==-1
            rowTemp=[rowTemp ii]; %trova tutti i figli di primo grado di s
        end
    end
    
    if isempty(rowTemp)~=1 %i figli si cercano se si sa già che ce ne saranno (cioè se si è trovata rowtemp non vuota)
        for rr=1:length(rowTemp)
            row=F(rowTemp(rr),:);
            for ii=1:length(row)
                if row(ii)==1
                    if isempty(children)
                        children=ii;
                    else
                        children=[children ii];
                    end

                end
            end
        end
    end
    
    if nargin==3 %controlla se c'è il terzo parametro
        if isempty(children)~=1
            for ii=1:length(children)
                temp=childrenSearch(children(ii),F,children);
                children=[children temp];
            end
        end
    end
end

