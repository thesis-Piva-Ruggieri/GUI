%g2normalization è la funzione per la normalizzazione di ogni possibile q''
function [g] = g2normalization(g2,F,s,father,x,fList) %fList è una lista di padri di s
    g=g2;
    col=F(:,father);
    rowTemp=0;
    
    for ii=1:length(col) %ciclo su tutti gli elementi della colonna di father
        if col(ii)==-1
            rowTemp=ii; %trova i figli di primo grado di UN solo nodo tra quelli figli
        end
        
        children=[];
        if rowTemp~=0 %i figli si cercano se si sa già che ce ne saranno (cioè se si è trovata rowtemp diversa da 0)
            row=F(rowTemp,:);
            for kk=1:length(row) %trovo tutti i figli del nodo figlio di father
                if row(kk)==1
                    if isempty(children)
                        children=kk;
                    else
                        children=[children kk];
                    end
                    
                end
            end
            norm=1; %se alla fine resta ad 1 vuol dire che i figli presenti in row(e tutti i loro figli) sono da normalizzare
            for aa=1:length(children) %controllo se tra i figli del nodo c'è s o uno dei padri di s
                if ~norm
                    break;
                end
                
                if children(aa)==s %se s è tra i figli, allora la normalizzazione in questo frangente non è necessaria
                    norm=0;
                    break;
                end
                
                for bb=1:length(fList)
                    if children(aa)==fList(bb) %se tra i figli risulta esserci uno dei padri di s, allora non è necessario normalizzare in questo frangente
                        norm=0;
                        break;
                    end
                end
                
            end
            
            if norm %se norm è ancora ==1, allora vuol dire che è necessario normalizzare
                for aa=1:length(children)
                    g(children(aa))=x(children(aa))/x(father);
                    clist=childrenSearch(children(aa),F,1);
                    if isempty(clist)~=1
                        for bb=1:length(clist)
                            g(clist(bb))=x(clist(bb))/x(father); %normalizzo tutti i figli di ogni children rispetto ad s
                        end
                    end
                end
            end
            
        end
        
        rowTemp=0; %ripristino rowTemp per evitare che al ciclo dopo, se non trova altri riscontri con father=-1, rientri nell'if esterno
        
    end
    
    
end