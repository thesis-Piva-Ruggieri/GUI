function [expG] = exponentialG(F,U,x,q,eta,player,pre_num)
    S=size(U);
    len1=S(1);
    len2=S(2);
    col=F(:,q);
    row_q=0; %here is saved the row in F containing q as child (as number 1). We'll need this later
    for ii=1:length(col)
        if col(ii)==1
            row_q=ii;
        end
    end
    check=0;
    num=pre_num;
    if player==1
        for ii=1:len2
            if U(q,ii)>0 %if it's true, then q has a direct utility
                check=1;
                break;
            end
        end
        if check==1
            %                 disp(['Padre di ',num2str(q),': ',num2str(q),' risulta avere U diretta.'])
            e_q=zeros(1,len1);
            e_q(q)=1;
            U_q=exp(inv(eta)*e_q*U*x(len1+1:len1+len2));
            num=num*U_q;
        end
    elseif player==2
        for ii=1:len1
            if U(ii,q)>0 %if it's true, then q has a direct utility
                check=1;
                break;
            end
        end
        if check==1
            e_q=zeros(len2,1);
            e_q(q)=1;
            U_q=exp(inv(eta)*(transpose(x(1:len1))*U*e_q));
            num=num*U_q;
        end
    end
    
    father=max(fathersSearch(q,F)); %this is the father of q
    col=F(:,father);
    rowTemp=[];
    children=[];
    for ii=1:length(col)
        if col(ii)==-1 && ii~=row_q
            rowTemp=[rowTemp ii]; %finding all q's step brothers nodes
        end
    end
    
    if isempty(rowTemp)~=1
        %             disp(['Siamo in ',num2str(q),' di P',num2str(player)])
        for rr=1:length(rowTemp) %cycling for every q's step brothers nodes
            num_temp=0;
            row=F(rowTemp(rr),:);
            for ii=1:length(row)
                if row(ii)==1 %here ii is a step brother
                    checkIfFinal=1;
                    col_temp=F(:,ii);
                    for jj=1:length(col_temp) %checking if row(ii) is a final node to avoid an infinite loop
                        if col_temp(jj)==-1
                            checkIfFinal=0;
                            break;
                        end
                    end
                    
                    if checkIfFinal==1
                        if player==1
                            %                                 disp(['Fratello ',num2str(ii),' di ',num2str(q),' di P1 è FINALE.'])
                            e_q=zeros(1,len1);
                            e_q(ii)=1;
                            step_b_cont=exp(inv(eta)*e_q*U*x(len1+1:len1+len2));
                            num_temp=num_temp+step_b_cont;
                        elseif player==2
                            %                                 disp(['Fratello ',num2str(ii),' di ',num2str(q),' di P2 è FINALE.'])
                            e_q=zeros(len2,1);
                            e_q(ii)=1;
                            step_b_cont=exp(inv(eta)*(transpose(x(1:len1))*U*e_q));
                            num_temp=num_temp+step_b_cont;
                        end
                    else
%                         disp(['   EXPG chiama figlio ',num2str(ii),' di ',num2str(q)])
                        num_temp=num_temp+planeToSequences(F,U,x,ii,eta,player,'simp');
                    end
                end
            end
            num=num*num_temp; %multipling q for his step-brothers
        end
    end
    
    father=max(fathersSearch(q,F)); %this is the father of q
    if q~=1 && father~=1
        expG=exponentialG(F,U,x,father,eta,player,num);
    else
        expG=num;
    end
end

