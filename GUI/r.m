%funzione per calcolare g dati F,x ed s
function [r] = r(F,x,s) %s è la sequenza sulla quale stiamo calcolando g
    fathers=fathersSearch(s,F); %cerco TUTTI i padri di s (padre, padre del padre ecc.)
    
    r=transpose(x); %algoritmicamente, è molto più vantaggioso partire direttamente da r=x e poi mettere a zero i fratelli di s ed i loro figli, piuttosto che
            %partire da tutto zero e poi aggiustare tutto l'albero.
    if fathers==0
        r(s)=1;
    else
        r(s)=x(fathers(1)); %s ha probabilità pari a quella del padre
    end
    
    r=brothers(F,s,r);
    clist=childrenSearch(s,F,1); %children list; ultimo parametro a piacimento, basta che ci sia un terzo parametro. Se non messo, si cerca SOLO il primo livello di figli
    if isempty(clist)~=1
        for jj=1:length(clist)
            r(clist(jj))=x(clist(jj))/(x(s)/r(s)); %normalizzo tutti i figli di ogni children rispetto ad s
        end
    end
end