function [dx] = generalSFAEBNN(t,x,U1,U2,F1,F2)
    S=size(U1); %it is the same with U2, since both have the same size
    len1=S(1); %torna il numero di righe della matrice di utilit�, cio� il numero di azioni di G1
    len2=S(2); %torna il numero di righe della matrice di utilit�, cio� il numero di azioni di G1
    dx=zeros(len1+len2,1);
    dx(1)=0;
    dx(len1+1)=0;
    
    %controllare correttezza di F
    
    for ii=2:len1 %da 2 perch� in dx(1) � 0 per definizione di q0
%         disp(['        ii = ',num2str(ii)])
        fathers=fathersSearch(ii,F1);
%         disp(['padri: ',num2str(fathers)])
        len=length(fathers);
        sumR=0; %corrisponde alla somma sulle azioni di q
        for jj=1:len %calcolo l'equazione per tutte le azioni di q, esclusa l'ultima (cio� calcolo per tutti i padri dell'ultima)
            if fathers(jj)~=1 %elimino il caso di padre=q0
%                 disp(['padre ',num2str(fathers(jj))])
                vec_r=r(F1,x(1:len1),fathers(jj));
         
                q_sign=max(fathersSearch(fathers(jj),F1)); %il padre di fathers(jj) � quello con il maggior valore tra tutti i suoi antenati
            
                denom=x(fathers(jj))/x(q_sign);
               
                
%               rhoH=childrenSearch(q_sign,F1);
               rhoH= brothersSearch(F1,fathers(jj));
               rhoH=[fathers(jj) rhoH];
                
                
%                 disp(['figli: ',num2str(rhoH)])
                sumK=0; %il valore della sommatoria con indice k
                for k=1:length(rhoH) %rhoH non potr� mai essere vuoto, perch� nel caso limite corrisponder� ai figli di q0
                    sumK=sumK+max((r(F1,x(1:len1),rhoH(k))-transpose(x(1:len1)))*U1*x(len1+1:len1+len2),0);
%                     disp(['figlio ',num2str(rhoH(k)),' sumK: ',num2str(sumK)])
                end
                sumR=sumR+( (max((vec_r-transpose(x(1:len1)))*U1*x(len1+1:len1+len2),0)/denom) - sumK );
            end
        end
        
        %ora calcolo l'equazione per l'ultima azione di q
%         disp(['azione ',num2str(ii)])
        vec_r=r(F1,x(1:len1),ii);
    
        q_sign=max(fathersSearch(ii,F1)); %il padre di fathers(jj) � quello con il maggior valore tra tutti i suoi antenati
  
        denom=x(ii)/x(q_sign);

%         rhoH=childrenSearch(q_sign,F1);
               rhoH= brothersSearch(F1,ii);
               rhoH=[ii rhoH];
                
        
        
%         disp(['figli: ',num2str(rhoH)])
        sumK=0; %il valore della sommatoria con indice k
        for k=1:length(rhoH) %rhoH non potr� mai essere vuoto, perch� nel caso limite corrisponder� ai figli di q0
            sumK=sumK+max((r(F1,x(1:len1),rhoH(k))-transpose(x(1:len1)))*U1*x(len1+1:len1+len2),0);
%             disp(['figlio ',num2str(rhoH(k)),' sumK: ',num2str(sumK)])
        end
        sumR=sumR+( (max((vec_r-transpose(x(1:len1)))*U1*x(len1+1:len1+len2),0)/denom) - sumK );
        
        dx(ii)= x(ii)*sumR;
    end
    
    
    
    inc=2;
    for ii=(len1+2):(len1+len2) %da 2 perch� in dx(1) � 0 per definizione di q0
        fathers=fathersSearch(inc,F2);
        len=length(fathers);
        sumR=0; %corrisponde alla somma sulle azioni di q
        for jj=1:len %calcolo l'equazione per tutte le azioni di q, esclusa l'ultima (cio� calcolo per tutti i padri dell'ultima)
            if fathers(jj)~=1 %elimino il caso di padre=q0
                vec_r=r(F2,x(len1+1:len1+len2),fathers(jj));
                q_sign=max(fathersSearch(fathers(jj),F2)); %il padre di fathers(jj) � quello con il maggior valore tra tutti i suoi antenati
                denom=x(len1+fathers(jj))/x(len1+q_sign);
                
%                 rhoH=childrenSearch(q_sign,F2);
               rhoH= brothersSearch(F2,fathers(jj));
               rhoH=[fathers(jj) rhoH];
                
                sumK=0; %il valore della sommatoria con indice k
                for k=1:length(rhoH) %rhoH non potr� mai essere vuoto, perch� nel caso limite corrisponder� ai figli di q0
                    sumK=sumK+max(transpose(x(1:len1))*U2*(transpose(r(F2,x(len1+1:len1+len2),rhoH(k)))-x(len1+1:len1+len2)),0);
                end
                sumR=sumR+( (max(transpose(x(1:len1))*U2*(transpose(vec_r)-x(len1+1:len1+len2)),0)/denom) - sumK );
            end
        end
        
        %ora calcolo l'equazione per l'ultima azione di q
        vec_r=r(F2,x(len1+1:len1+len2),inc);
        q_sign=max(fathersSearch(inc,F2)); %il padre di inc � quello con il maggior valore tra tutti i suoi antenati
        denom=x(ii)/x(q_sign+len1);
        
%         rhoH=childrenSearch(q_sign,F2);
               rhoH= brothersSearch(F2,inc);
               rhoH=[inc rhoH];
        
        sumK=0; %il valore della sommatoria con indice k
        for k=1:length(rhoH) %rhoH non potr� mai essere vuoto, perch� nel caso limite corrisponder� ai figli di q0
            sumK=sumK+max(transpose(x(1:len1))*U2*(transpose(r(F2,x(len1+1:len1+len2),rhoH(k)))-x(len1+1:len1+len2)),0);
        end
        sumR=sumR+( (max(transpose(x(1:len1))*U2*(transpose(vec_r)-x(len1+1:len1+len2)),0)/denom) - sumK );
        
        
        dx(ii)= x(ii)*sumR;
        inc= inc+1;
       
    end
end
