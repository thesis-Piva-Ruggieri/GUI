%this function deals with the mapping from a plane in the normal form to a sequence in the sequence form
function [sum] = planeToSequences(F,U,x,q,eta,player,mode)
if strcmp(mode,'exp')
    col=F(:,q);
    rowTemp=[];
    children=[];
    num=0; %it will contain the sum at the numerator
    childNodesCount=0;
    row_q=0; %here is saved the row in F containing q as child (as number 1). We'll need this later
    for ii=1:length(col)
        if col(ii)==1
            row_q=ii;
        end
    end
    
    for ii=1:length(col)
        num_temp=0;
        children=[];
        if col(ii)==-1 %if q is not final, it's value is the sum of the children of one of it's child nodes
            childNodesCount=childNodesCount+1;
            rowTemp=ii;
            row=F(rowTemp,:);
            for jj=1:length(row)
                if row(jj)==1
                    if isempty(children)
                        children=jj;
                    else
                        children=[children jj];
                    end
                end
            end
            for jj=1:length(children)
                child_contr=planeToSequences(F,U,x,children(jj),eta,player,'exp');
                num_temp=num_temp+child_contr; %sequences of brothers have to be summed. Here starts the recursion
            end
            
            num=num_temp;
            break;
        end
    end
    S=size(U);
    len1=S(1);
    len2=S(2);

    if childNodesCount==0 %it means that q has no children (this is the end of the recursion)
        if player==1
            e_q=zeros(1,len1);
            e_q(q)=1;
            exponent=e_q*U*x(len1+1:len1+len2);
            num=exp(inv(eta)*exponent);
        elseif player==2
            e_q=zeros(len2,1);
            e_q(q)=1;
            exponent=transpose(x(1:len1))*U*e_q;
            num=exp(inv(eta)*exponent);
        end
        
        %checking for step brothers
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
            for ii=1:length(rowTemp)
                num_temp=0;
                row=F(rowTemp(ii),:);
                for jj=1:length(row)
                    if row(jj)==1 %here ii is a step brother
                        checkIfFinal=1;
                        col_temp=F(:,jj);
                        for kk=1:length(col_temp) %checking if row(ii) is a final node to avoid an infinite loop
                            if col_temp(kk)==-1
                                checkIfFinal=0;
                                break;
                            end
                        end
                        
                        if checkIfFinal==1
                            if player==1
                                %                                 disp(['Fratello ',num2str(ii),' di ',num2str(q),' di P1 è FINALE.'])
                                e_q=zeros(1,len1);
                                e_q(jj)=1;
                                step_b_cont=exp(inv(eta)*e_q*U*x(len1+1:len1+len2));
                                num_temp=num_temp+step_b_cont;
                            elseif player==2
                                e_q=zeros(len2,1);
                                e_q(jj)=1;
                                step_b_cont=exp(inv(eta)*(transpose(x(1:len1))*U*e_q));
                                num_temp=num_temp+step_b_cont;
                            end
                        else
                            row2=F(kk,:);
                            children=[];
                            num_temp2=0;
                            for kk=1:length(row2)
                                if row2(kk)==1
                                    if isempty(children)
                                        children=kk;
                                    else
                                        children=[children kk];
                                    end
                                end
                            end
                            for kk=1:length(children)
                                child_cont=planeToSequences(F,U,x,children(kk),eta,player,'simp');
                                num_temp2=num_temp2+child_cont;%brothers in the same node have to be summed
                            end
                            num_temp=num_temp+num_temp2;
                        end
                    end
                end
                num=num*num_temp;
            end
        end
        
        father=max(fathersSearch(q,F)); %this is the father of q
        if q~=1 && father~=1
            num=exponentialG(F,U,x,father,eta,player,num);
        end
    end
    sum=num;
    
elseif strcmp(mode,'simp') %simple mode: stops calculating utility for q at q's level. Never calls exponentialG.
    col=F(:,q);
    rowTemp=[];
    children=[];
    num=1; %it will contain the sum at the numerator
    childNodesCount=0;
    row_q=0; %here is saved the row in F containing q as child (as number 1). We'll need this later
    for ii=1:length(col)
        if col(ii)==1
            row_q=ii;
        end
    end
    
    for ii=1:length(col)
        num_temp=0;
        children=[];
        if col(ii)==-1 %if q is not final, it's value is the sum of the children of one of it's child nodes
            childNodesCount=childNodesCount+1;
            rowTemp=ii;
            row=F(rowTemp,:);
            for jj=1:length(row)
                if row(jj)==1
                    if isempty(children)
                        children=jj;
                    else
                        children=[children jj];
                    end
                end
            end
            for jj=1:length(children)
                num_temp=num_temp+planeToSequences(F,U,x,children(jj),eta,player,'simp'); %sequences of brothers have to be summed. Here starts the recursion
            end
            
            num=num_temp;
            break;
        end
    end
    
    
    S=size(U);
    len1=S(1);
    len2=S(2);
    
    if q~=1 %excluding q0
        
        %now, this is tricky: it may happen that an action has children AND it also leads directly to a utility. Here we check this last case
        
        father=max(fathersSearch(q,F)); %this is the father of q
        check=0;
        U_father=1;
        if player==1
            for ii=1:len2
                if U(father,ii)>0 %if it's true, then father has a direct utility
                    check=1;
                    break;
                end
            end
            if check==1
                %                 disp(['Padre di ',num2str(q),': ',num2str(father),' risulta avere U diretta.'])
                e_q=zeros(1,len1);
                e_q(father)=1;
                U_father=exp(inv(eta)*e_q*U*x(len1+1:len1+len2));
                num=num*U_father;
            end
        elseif player==2
            for ii=1:len1
                if U(ii,father)>0 %if it's true, then father has a direct utility
                    check=1;
                    break;
                end
            end
            if check==1
                e_q=zeros(len2,1);
                e_q(father)=1;
                U_father=exp(inv(eta)*(transpose(x(1:len1))*U*e_q));
                num=num*U_father;
            end
        end
    end
    
    if childNodesCount==0 %it means that q has no children (this is the end of the recursion)
        if player==1
            e_q=zeros(1,len1);
            e_q(q)=1;
            exponent=e_q*U*x(len1+1:len1+len2);
            num=num*exp(inv(eta)*exponent);
        elseif player==2
            e_q=zeros(len2,1);
            e_q(q)=1;
            exponent=transpose(x(1:len1))*U*e_q;
            num=num*exp(inv(eta)*exponent);
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
            for ii=1:length(rowTemp)
                num_temp=0;
                row=F(rowTemp(ii),:);
                for jj=1:length(row)
                    if row(jj)==1 %here ii is a step brother
                        checkIfFinal=1;
                        col_temp=F(:,jj);
                        for kk=1:length(col_temp) %checking if row(ii) is a final node to avoid an infinite loop
                            if col_temp(kk)==-1
                                checkIfFinal=0;
                                break;
                            end
                        end
                        
                        if checkIfFinal==1
                            if player==1
                                e_q=zeros(1,len1);
                                e_q(jj)=1;
                                step_b_cont=exp(inv(eta)*e_q*U*x(len1+1:len1+len2));
                                num_temp=num_temp+step_b_cont;
                            elseif player==2
                                e_q=zeros(len2,1);
                                e_q(jj)=1;
                                step_b_cont=exp(inv(eta)*(transpose(x(1:len1))*U*e_q));
                                num_temp=num_temp+step_b_cont;
                            end
                        else
                            row2=F(kk,:);
                            children=[];
                            num_temp2=0;
                            for kk=1:length(row2)
                                if row2(kk)==1
                                    if isempty(children)
                                        children=kk;
                                    else
                                        children=[children kk];
                                    end
                                end
                            end
                            for kk=1:length(children)
                                child_cont=planeToSequences(F,U,x,children(kk),eta,player,'simp');
                                num_temp2=num_temp2+child_cont;%brothers in the same node have to be summed
                            end
                            num_temp=num_temp+num_temp2;
                        end
                    end
                end
                num=num*num_temp;
            end
        end
    end
    sum=num;
end
    
end