function [dx] = generalSFNEBNN(t,x,U1,U2,F1,F2,planesP1,planesP2)
    S=size(U1); %it is the same with U2, since both have the same size
    len1=S(1); %torna il numero di righe della matrice di utilit�, cio� il numero di azioni di G1
    len2=S(2); %torna il numero di righe della matrice di utilit�, cio� il numero di azioni di G1
    dx=zeros(len1+len2,1);
    dx(1)=0;
    dx(len1+1)=0;
    
    %now we substitute at each member of a plane the respective sequence
        %first we create a cell containing in each position, the respective sequence
    seqP1={};
    seqP1{1,1}=zeros(1,len1);
    seqP1{1,1}(1,1)=1; %empty sequence
    for i=2:len1
        sequence=zeros(1,len1);
        fathers=fathersSearch(i,F1);
        %building the sequence
        sequence(i)=1;
        for f=1:length(fathers)
            sequence(fathers(f))=1;
        end
        seqP1{1,i}=sequence;
    end
    seqP2={};
    seqP2{1,1}=zeros(1,len2);
    seqP2{1,1}(1,1)=1; %empty sequence
    for i=2:len2
        sequence=zeros(1,len2);
        fathers=fathersSearch(i,F2);
        %building the sequence
        sequence(i)=1;
        for f=1:length(fathers)
            sequence(fathers(f))=1;
        end
        seqP2{1,i}=sequence;
    end
    
    sizePlanesP1=size(planesP1);
    plainsSeqP1={}; %this will contain the equivalent of planesP1 with sequences instead of numbers 
    for r=1:sizePlanesP1(1)
        for c=1:sizePlanesP1(2)
            if planesP1(r,c)~=0
                plainsSeqP1{r,c}=seqP1{1,planesP1(r,c)};
            else
                plainsSeqP1{r,c}=[];
            end
        end
    end
    sizePlanesP2=size(planesP2);
    plainsSeqP2={}; %this will contain the equivalent of planesP2 with sequences instead of numbers 
    for r=1:sizePlanesP2(1)
        for c=1:sizePlanesP2(2)
            if planesP2(r,c)~=0
                plainsSeqP2{r,c}=seqP2{1,planesP2(r,c)};
            else
                plainsSeqP2{r,c}=[];
            end
        end
    end
    
    %now the main calculation
    for i=2:len1
%         disp(['-------- P1 i ',num2str(i),' --------'])
        belongingPlanes=[]; %planes to whom sequence i belongs
        nonBelongingPlanes=[]; %planes to whom sequence i does NOT belong
        for r=1:sizePlanesP1(1)
            check=0; %check=1 if i belongs to plane planesP1(r,:)
            for c=1:sizePlanesP1(2)
%                 disp(['Iterazione ',num2str(i),'. Siamo in posizione ',num2str([r,c])])
                if isempty(plainsSeqP1{r,c})
                    break;
                end
%                 disp(['P1 Confronto ',num2str(plainsSeqP1{r,c}),' con ',num2str(i)])
                if plainsSeqP1{r,c}(1,i)==1 %check if i is in plainsSeqP1{r,c}
                    check=1;
                    break;
                end
            end
            if check
%                 disp('Belonging')
                belongingPlanes=[belongingPlanes r];
            else
%                 disp('NON Belonging')
                nonBelongingPlanes=[nonBelongingPlanes r];
            end
        end
%         for j=1:length(belongingPlanes)
%             disp(['Sequence ',num2str(i),' belongs to ',num2str(belongingPlanes(j))])
% %         end
        sumBelonging=0;
        for r=1:length(belongingPlanes) %cycling on planes
%             disp(['   Considero piano numero ',num2str(belongingPlanes(r)),' (',num2str(planesP1(belongingPlanes(r),:)),')'])
            contribute=0; %contribute of a single plane
            for c=1:sizePlanesP1(2) %cycling on sequences of the plane
                if isempty(plainsSeqP1{belongingPlanes(r),c})~=1
%                     disp(['      Considero sequenza ',num2str(plainsSeqP1{belongingPlanes(r),c})])
%                     disp(['Singolo contributo sequenza: ',num2str((plainsSeqP1{belongingPlanes(r),c}-transpose(x(1:len1)))*U1*x(len1+1:len1+len2))])
                    contribute=contribute+(plainsSeqP1{belongingPlanes(r),c})*U1*x(len1+1:len1+len2);
%                     contribute=contribute+(g(F1,x(1:len1),planesP1(belongingPlanes(r),c))-transpose(x(1:len1)))*U1*x(len1+1:len1+len2);
                end
            end
            contribute=contribute-transpose(x(1:len1))*U1*x(len1+1:len1+len2);
            sumBelonging=sumBelonging+max(contribute,0);
        end
        sumNonBelonging=0;
        for r=1:length(nonBelongingPlanes) %cycling on planes
            contribute=0; %contribute of a single plane
            for c=1:sizePlanesP1(2) %cycling on sequences of the plane
                if isempty(plainsSeqP1{nonBelongingPlanes(r),c})~=1
                    contribute=contribute+(plainsSeqP1{nonBelongingPlanes(r),c})*U1*x(len1+1:len1+len2);
%                     contribute=contribute+(g(F1,x(1:len1),planesP1(nonBelongingPlanes(r),c))-transpose(x(1:len1)))*U1*x(len1+1:len1+len2);
                end
            end
            contribute= contribute-transpose(x(1:len1))*U1*x(len1+1:len1+len2);
            sumNonBelonging=sumNonBelonging+max(contribute,0);
        end
%         disp(['Sequence ',num2str(i),' sumBelong: ',num2str(sumBelonging),' sunNONBelong: ',num2str(sumNonBelonging)])
        dx(i)=(1-x(i))*sumBelonging-x(i)*sumNonBelonging;
%         disp(['DX: ',num2str(dx(i))])
    end
    
    %player 2
    inc=2;
    for i=(len1+2):(len1+len2)
%         disp(['-------- P2 INC ',num2str(inc),' --------'])
        belongingPlanes=[]; %planes to whom sequence i belongs
        nonBelongingPlanes=[]; %planes to whom sequence i does NOT belong
        for r=1:sizePlanesP2(1)
            check=0; %check=1 if i belongs to plane planesP1(r,:)
            for c=1:sizePlanesP2(2)
%                 disp(['Iterazione ',num2str(i),'. Siamo in posizione ',num2str([r,c])])
                if isempty(plainsSeqP2{r,c})
                    break;
                end
%                 disp(['P2 Confronto ',num2str(plainsSeqP2{r,c}),' con ',num2str(inc)])
                if plainsSeqP2{r,c}(1,inc)==1 %check if i is in plainsSeqP1{r,c}
                    check=1;
                    break;
                end
            end
            if check
%                 disp('Belonging')
                belongingPlanes=[belongingPlanes r];
            else
%                 disp('NON Belonging')
                nonBelongingPlanes=[nonBelongingPlanes r];
            end
        end
%         for j=1:length(belongingPlanes)
%             disp(['Sequence ',num2str(i),' belongs to ',num2str(belongingPlanes(j))])
% %         end
%         inc
%         belongingPlanes
%         nonBelongingPlanes
        sumBelonging=0;
        for r=1:length(belongingPlanes) %cycling on planes
%             disp(['   Considero piano numero ',num2str(belongingPlanes(r)),' (',num2str(planesP2(belongingPlanes(r),:)),')'])
            contribute=0; %contribute of a single plane
            for c=1:sizePlanesP2(2) %cycling on sequences of the plane
                if isempty(plainsSeqP2{belongingPlanes(r),c})~=1
%                     disp(['      Considero sequenza ',num2str(plainsSeqP2{belongingPlanes(r),c})])
%                     disp(['Singolo contributo sequenza: ',num2str(transpose(x(1:len1))*U2*(transpose(plainsSeqP2{belongingPlanes(r),c})-x(len1+1:len1+len2)))])
                    contribute=contribute+transpose(x(1:len1))*U2*(transpose(plainsSeqP2{belongingPlanes(r),c}));
%                     contribute=contribute+transpose(x(1:len1))*U2*(transpose(g(F2,x(len1+1:len1+len2),planesP2(belongingPlanes(r),c))));
                end
            end
            contribute=contribute-transpose(x(1:len1))*U2*x(len1+1:len1+len2);

            sumBelonging=sumBelonging+max(contribute,0);
        end
        sumNonBelonging=0;
        for r=1:length(nonBelongingPlanes) %cycling on planes
            contribute=0; %contribute of a single plane
            for c=1:sizePlanesP2(2) %cycling on sequences of the plane
                if isempty(plainsSeqP2{nonBelongingPlanes(r),c})~=1
                    contribute=contribute+transpose(x(1:len1))*U2*(transpose(plainsSeqP2{nonBelongingPlanes(r),c}));
%                     contribute=contribute+transpose(x(1:len1))*U2*(transpose(g(F2,x(len1+1:len1+len2),planesP2(nonBelongingPlanes(r),c))));
                end
            end
            contribute=contribute-transpose(x(1:len1))*U2*x(len1+1:len1+len2);
            sumNonBelonging=sumNonBelonging+max(contribute,0);
        end
%         disp(['Sequence ',num2str(inc),' sumBelong: ',num2str(sumBelonging),' sunNONBelong: ',num2str(sumNonBelonging)])
        dx(i)=(1-x(i))*sumBelonging-x(i)*sumNonBelonging;
%         disp(['DX: ',num2str(dx(i))])
        inc=inc+1;
    end
    %sumNonBelonging=sumNonBelonging+transpose(x(1:len1))*U2*(transpose(sequence)-x(len1+1:len1+len2));
end