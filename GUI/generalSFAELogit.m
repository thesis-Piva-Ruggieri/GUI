function [dx] = generalSFAELogit(t,x,U1,U2,F1,F2,eta)
S=size(U1); %it is the same with U2, since both have the same size
len1=S(1); %torna il numero di righe della matrice di utilit�, cio� il numero di azioni di G1
len2=S(2); %torna il numero di colonne della matrice di utilit�, cio� il numero di azioni di G2
dx=zeros(len1+len2,1);
dx(1)=0;
dx(len1+1)=0;
eta=1/eta;
%controllare correttezza di F

for ii=2:len1 %da 2 perch� in dx(1) � 0 per definizione di q0
    
    fathers=fathersSearch(ii,F1);
    
    len=length(fathers);
    sum=0;
    for jj=1:len
        
        if fathers(jj)~=1

             x_q=max(fathersSearch(fathers(jj),F1));
       
   %         ro_h=childrenSearch(x_q,F1);
            ro_h= brothersSearch(F1,fathers(jj));
               ro_h=[fathers(jj) ro_h];
            sumDen=0;
            for kk=1:length(ro_h)
                sumDen=sumDen+ (exp(eta*r(F1,x(1:len1),ro_h(kk))*U1*x(len1+1:len1+len2)));
            end
            
             sigma=x(fathers(jj))/x(x_q);

            vec_r=r(F1,x(1:len1),fathers(jj));
           
            sum=sum+((exp(eta*vec_r*U1*x(len1+1:len1+len2)))/(sigma*sumDen));
            
        end
    end
    
    
    sumDen=0;
    x_q=max(fathersSearch(ii,F1));

%     ro_h=childrenSearch(x_q,F1);
             ro_h= brothersSearch(F1,ii);
    ro_h=[ii ro_h];
    for kk=1:length(ro_h)
        sumDen=sumDen+ exp(eta*r(F1,x(1:len1),ro_h(kk))*U1*x(len1+1:len1+len2));
    end
    
    sigma=x(ii)/x(x_q);
    vec_r=r(F1,x(1:len1),ii);
    
    sum=sum+((exp(eta*vec_r*U1*x(len1+1:len1+len2)))/(sigma*sumDen));
   
    
    dx(ii)= x(ii)*(sum-len);
    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
inc=2;
for ii=(len1+2):(len1+len2)
    fathers=fathersSearch(inc,F2);
    len=length(fathers);
    sum=0;
    for jj=1:len
        
        if fathers(jj)~=1
            
            x_q=max(fathersSearch(fathers(jj),F2));
%             ro_h=childrenSearch(x_q,F2);
                   ro_h= brothersSearch(F2,fathers(jj));
                   ro_h=[fathers(jj) ro_h];
            sumDen=0;
            for kk=1:length(ro_h)
                sumDen=sumDen+ (exp(eta*transpose(x(1:len1))*U2*transpose(r(F2,x(len1+1:len1+len2),ro_h(kk)))));
            end
            sigma=x(len1+fathers(jj))/x(len1+x_q);
            vec_r=r(F2,x(len1+1:len1+len2),fathers(jj));
            sum=sum+((exp(eta*transpose(x(1:len1))*U2*(transpose(vec_r))))/(sigma*sumDen));
        end
    end
    
    sumDen=0;
    
   x_q=max(fathersSearch(inc,F2));
%     ro_h=childrenSearch(x_q,F2);
           ro_h= brothersSearch(F2,inc);
    ro_h=[inc ro_h];
    for kk=1:length(ro_h)
        sumDen=sumDen+ (exp(eta*transpose(x(1:len1))*U2*transpose(r(F2,x(len1+1:len1+len2),ro_h(kk)))));
    end
    
    sigma=x(ii)/x(x_q+len1);
    vec_r=r(F2,x(len1+1:len1+len2),inc);
    sum=sum+((exp(eta*transpose(x(1:len1))*U2*(transpose(vec_r))))/(sigma*sumDen));
    
    
    dx(ii)= x(ii)*(sum-len);
    
    inc= inc+1;
   
end



end