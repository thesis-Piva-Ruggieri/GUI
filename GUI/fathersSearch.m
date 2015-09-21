function [fathers] = fathersSearch(s,F)
    col=F(:,s);
    rowTemp=0;
    fathers=0; %inizializzazione, nel caso non si abbiano padri(q0)
    for ii=1:length(col)
        if col(ii)==1
            rowTemp=ii;
            break;
        end
    end
    
    if(rowTemp~=0) %i padri si cercano se si sa già che ce ne saranno (cioè se si è trovata rowtemp!=0)
        row=F(rowTemp,:);
        for ii=1:length(row)
            if row(ii)==-1
                fathers=ii;
                break;
            end
        end
        
        if fathers~=1 && fathers~=0
            fathers=[fathers fathersSearch(fathers,F)];
        end
    end
    
end

