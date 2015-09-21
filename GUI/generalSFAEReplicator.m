function [dx] = generalSFAEReplicator(t,x,U1,U2,F1,F2)
    S=size(U1); %it is the same with U2, since both have the same size
    len1=S(1); %torna il numero di righe della matrice di utilità, cioè il numero di azioni di G1
    len2=S(2); %torna il numero di righe della matrice di utilità, cioè il numero di azioni di G1
    dx=zeros(len1+len2,1);
    dx(1)=0;
    dx(len1+1)=0;
    
    %controllare correttezza di F
    
    for ii=2:len1 %da 2 perchè in dx(1) è 0 per definizione di q0
        fathers=fathersSearch(ii,F1);
        len=length(fathers);
        sumR=0;
        for jj=1:len
            if fathers(jj)~=1
                sumR=sumR+r(F1,x(1:len1),fathers(jj));
            end
        end
        sumR=sumR+r(F1,x(1:len1),ii);
        dx(ii)= x(ii)*len*(sumR/len-transpose(x(1:len1)))*U1*x(len1+1:len1+len2);
    end
    
    inc=2;
    for ii=(len1+2):(len1+len2) %da 2 perchè in dx(1) è 0 per definizione di q0
        fathers=fathersSearch(inc,F2);
        len=length(fathers);
        sumR=0;
        for jj=1:len
            if fathers(jj)~=1
                sumR=sumR+r(F2,x(len1+1:len1+len2),fathers(jj));
            end
        end
        sumR=sumR+r(F2,x(len1+1:len1+len2),inc);
        dx(ii)= x(ii)*len*(transpose(x(1:len1))*U2*(transpose(sumR)/len-x(len1+1:len1+len2)));
        inc= inc+1;
    end
end