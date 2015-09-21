%funzione per calcolare g dati F,x ed s
function [g] = g(F,x,s) %s è la sequenza sulla quale stiamo calcolando g
    fathers=fathersSearch(s,F); %cerco TUTTI i padri di s (padre, padre del padre ecc.)
    
    g=zeros(1,length(x)); %prealloca memoria per ottimizzare tempo e spazio
    for ii=1:s
        if ii==1 || ii==s
            g(ii)=1; %metto 1 a q0 ed ad s
            continue;
        end
        
        for jj=1:length(fathers) %mette 1 nella posizione dei padri
            if ii==fathers(jj)
                g(ii)=1;
            end
        end
    end
    
    clist=childrenSearch(s,F,1); %children list; ultimo parametro a piacimento, basta che ci sia un terzo parametro. Se non messo, si cerca SOLO il primo livello di figli
    if isempty(clist)~=1
        for jj=1:length(clist)
            g(clist(jj))=x(clist(jj))/x(s); %normalizzo tutti i figli di ogni children rispetto ad s
        end
    end
    
    %ora la parte più difficile: normalizzare tutte le possibili q''(la definizione di q'' è data nel papero)
    if fathers~=0
        for ii=1:length(fathers)
            g=g2normalization(g,F,s,fathers(ii),x,fathers);
        end
    end

end