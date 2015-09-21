function [dx] = generalSFAESmith(t,x,U1,U2,F1,F2)
    S=size(U1); %it is the same with U2, since both have the same size
    len1=S(1); %number of rows of U, that is the numer of action of Player 1 
    len2=S(2); %number of columns of U, that is the numer of action of Player 2 
    dx=zeros(len1+len2,1);
    dx(1)=0;
    dx(len1+1)=0;
    
    %check F correctness
    
    for ii=2:len1 %from 2 because dx(1) is 0 by definition
        fathers=fathersSearch(ii,F1);
        len=length(fathers);
        sumR=0; %this variable stores the final result
        for jj=1:len %calculate equation for all q's fathers
            if fathers(jj)~=1 %not considering the father=q0 case
                vec_r=r(F1,x(1:len1),fathers(jj));
                q_sign=max(fathersSearch(fathers(jj),F1)); %direct fathers(jj)'s father (the one with the highest number among all its fathers)
                denom=x(fathers(jj))/x(q_sign);
                %                 rhoH=childrenSearch(q_sign,F1);
                rhoH= brothersSearch(F1,fathers(jj));
                rhoH=[fathers(jj) rhoH];
                sumKnum=0; %it's the summatory at the numerator (the one in the first part of the equation)
                for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children 
                    q_cap=max(fathersSearch(rhoH(k),F1)); %it could tecnically go outside the summatory, cause it never changes
                    sumKnum=sumKnum+(x(rhoH(k))/x(q_cap))*max((vec_r-r(F1,x(1:len1),rhoH(k)))*U1*x(len1+1:len1+len2),0);
                end
                
                sumK=0; %value of the summatory with index k
                for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children 
                    sumK=sumK+max((r(F1,x(1:len1),rhoH(k))-vec_r)*U1*x(len1+1:len1+len2),0);
                end
                sumR=sumR+( (sumKnum/denom) - sumK );
            end
        end
        
        %now we calculate the equation for the last action of q
        vec_r=r(F1,x(1:len1),ii);
        q_sign=max(fathersSearch(ii,F1)); %direct ii's father (the one with the highest number among all its fathers)
        denom=x(ii)/x(q_sign);
        rhoH= brothersSearch(F1,ii);
        rhoH=[ii rhoH];
        
        sumKnum=0; %it's the summatory at the numerator (the one in the first part of the equation)
        for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children 
            q_cap=max(fathersSearch(rhoH(k),F1)); %it could tecnically go outside the summatory, cause it never changes
            sumKnum=sumKnum+(x(rhoH(k))/x(q_cap))*max((vec_r-r(F1,x(1:len1),rhoH(k)))*U1*x(len1+1:len1+len2),0);
        end
        
        sumK=0; %value of the summatory with index k
        for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children 
            sumK=sumK+max((r(F1,x(1:len1),rhoH(k))-vec_r)*U1*x(len1+1:len1+len2),0);
        end
        sumR=sumR+( (sumKnum/denom) - sumK );
        
        
        dx(ii)= x(ii)*sumR;
    end
    
    
    
    inc=2;
    for ii=(len1+2):(len1+len2) %from len1+2 because dx(len1+1) is 0 by definition
        fathers=fathersSearch(inc,F2);
        len=length(fathers);
        sumR=0; %this variable stores the final result
        sumKnum=0;
        for jj=1:len %calculate equation for all q's fathers
            if fathers(jj)~=1 %elimino il caso di padre=q0
                vec_r=r(F2,x(len1+1:len1+len2),fathers(jj));
                q_sign=max(fathersSearch(fathers(jj),F2)); %direct fathers(jj)'s father (the one with the highest number among all its fathers)
                denom=x(len1+fathers(jj))/x(len1+q_sign);

                rhoH= brothersSearch(F2,fathers(jj));
                rhoH=[fathers(jj) rhoH];
                sumKnum=0; %it's the summatory at the numerator (the one in the first part of the equation)
                for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children
                    q_cap=max(fathersSearch(rhoH(k),F2)); %it could tecnically go outside the summatory, cause it never changes
                    sumKnum=sumKnum+(x(len1+rhoH(k))/x(len1+q_cap))*max(transpose(x(1:len1))*U2*(transpose(vec_r)-transpose(r(F2,x(len1+1:len1+len2),rhoH(k)))),0);
                end
                
                sumK=0; %value of the summatory with index k
                for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children
                    sumK=sumK+max(transpose(x(1:len1))*U2*(transpose(r(F2,x(len1+1:len1+len2),rhoH(k)))-transpose(vec_r)),0);
                end
                sumR=sumR+( (sumKnum/denom) - sumK );
            end
        end
        
        %now we calculate the equation for the last action of q
        vec_r=r(F2,x(len1+1:len1+len2),inc);
        q_sign=max(fathersSearch(inc,F2)); %direct inc's father (the one with the highest number among all its fathers)
        denom=x(ii)/x(len1+q_sign);
        rhoH= brothersSearch(F2,inc);
        rhoH=[inc rhoH];
        sumKnum=0; %it's the summatory at the numerator (the one in the first part of the equation)
        for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children 

            q_cap=max(fathersSearch(rhoH(k),F2)); %it could tecnically go outside the summatory, cause it never changes
            sumKnum=sumKnum+(x(len1+rhoH(k))/x(len1+q_cap))*max(transpose(x(1:len1))*U2*(transpose(vec_r)-transpose(r(F2,x(len1+1:len1+len2),rhoH(k)))),0);
        end
        
        sumK=0; %il valore della sommatoria con indice k
        for k=1:length(rhoH) %rhoH can't possibly be empty; limit case: it will be q0's children
            sumK=sumK+max(transpose(x(1:len1))*U2*(transpose(r(F2,x(len1+1:len1+len2),rhoH(k)))-transpose(vec_r)),0);
        end
        sumR=sumR+( (sumKnum/denom) - sumK );
        
        dx(ii)= x(ii)*sumR;
        inc= inc+1;
    end
end
