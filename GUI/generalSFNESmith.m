function [dx] = generalSFNESmith(t,x,U1,U2,F1,F2,planesP1,planesP2)
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
    %player 1
    for i=2:len1
%         disp(['-------- P1 i ',num2str(i),' --------'])
        finalSum=0;
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
%         end

        for b=1:length(belongingPlanes)
            probBelPlane=1; %will contain the probability of the current belonging plane
            sequencesBel=[]; %will contain every action in the current belonging plane
            for c=1:sizePlanesP1(2)
                if isempty(plainsSeqP1{belongingPlanes(b),c})
                    break;
                end
                sequencesTemp=find(plainsSeqP1{belongingPlanes(b),c}==1);
                for s=1:length(sequencesTemp)
                    if ismember(sequencesTemp(s),sequencesBel)~=1
                        sequencesBel=[sequencesBel sequencesTemp(s)];
                    end
                end
            end
%             disp(['Considering belonging plane ',num2str(belongingPlanes(b)),'. Belonging actions: ',num2str(sequencesBel)])
            e_belonging=zeros(1,len1);
            for s=1:length(sequencesBel) %calculating the probability of the current belonging plane
                e_belonging(sequencesBel(s))=1;
                if sequencesBel(s)~=1
                    probBelPlane=probBelPlane*x(sequencesBel(s))/x(max(fathersSearch(sequencesBel(s),F1)));
                end
            end
 %           disp(['E_belonging: ',num2str(e_belonging),' with probability ',num2str(probBelPlane)])
            for nb=1:length(nonBelongingPlanes)
                probNonBelPlane=1; %will contain the probability of the current NoNbelonging plane
                sequencesNonBel=[]; %will contain every action in the current NoNbelonging plane
                for c=1:sizePlanesP1(2)
                    if isempty(plainsSeqP1{nonBelongingPlanes(nb),c})
                        break;
                    end
                    sequencesTemp=find(plainsSeqP1{nonBelongingPlanes(nb),c}==1);
                    for s=1:length(sequencesTemp)
                        if ismember(sequencesTemp(s),sequencesNonBel)~=1
                            sequencesNonBel=[sequencesNonBel sequencesTemp(s)];
                        end
                    end
                end
  %              disp(['Considering NoNbelonging plane ',num2str(nonBelongingPlanes(nb)),'. NoNbelonging actions: ',num2str(sequencesNonBel)])
                e_NoNbelonging=zeros(1,len1);
                for s=1:length(sequencesNonBel) %calculating the probability of the current NoNbelonging plane
                    e_NoNbelonging(sequencesNonBel(s))=1;
                    if sequencesNonBel(s)~=1
                        probNonBelPlane=probNonBelPlane*x(sequencesNonBel(s))/x(max(fathersSearch(sequencesNonBel(s),F1)));
                    end
                    
                end
   %             disp(['E_NoNbelonging: ',num2str(e_NoNbelonging),' with probability ',num2str(probNonBelPlane)])
                finalSum=finalSum+( probNonBelPlane*max(0,(e_belonging-e_NoNbelonging)*U1*x(len1+1:len1+len2)) - probBelPlane*max(0,(e_NoNbelonging-e_belonging)*U1*x(len1+1:len1+len2)) );
            end
        end

        dx(i)=finalSum;
 %       disp(['DX: ',num2str(dx(i))])
    end
    
    %player 2
    inc=2;
    for i=(len1+2):(len1+len2)
 %       disp(['-------- P2 INC ',num2str(inc),' --------'])
        finalSum=0;
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
        for b=1:length(belongingPlanes)
            probBelPlane=1; %will contain the probability of the current belonging plane
            sequencesBel=[]; %will contain every action in the current belonging plane
            for c=1:sizePlanesP2(2)
                if isempty(plainsSeqP2{belongingPlanes(b),c})
                    break;
                end
                sequencesTemp=find(plainsSeqP2{belongingPlanes(b),c}==1);
                for s=1:length(sequencesTemp)
                    if ismember(sequencesTemp(s),sequencesBel)~=1
                        sequencesBel=[sequencesBel sequencesTemp(s)];
                    end
                end
            end
   %         disp(['Considering belonging plane ',num2str(belongingPlanes(b)),'. Belonging actions: ',num2str(sequencesBel)])
            e_belonging=zeros(1,len2);
            for s=1:length(sequencesBel) %calculating the probability of the current belonging plane
                e_belonging(sequencesBel(s))=1;
                if sequencesBel(s)~=1
                    probBelPlane=probBelPlane*x(sequencesBel(s)+len1)/x(max(fathersSearch(sequencesBel(s),F2))+len1);
                end
            end
   %          disp(['E_belonging: ',num2str(e_belonging),' with probability ',num2str(probBelPlane)])
            for nb=1:length(nonBelongingPlanes)
                probNonBelPlane=1; %will contain the probability of the current NoNbelonging plane
                sequencesNonBel=[]; %will contain every action in the current NoNbelonging plane
                for c=1:sizePlanesP2(2)
                    if isempty(plainsSeqP2{nonBelongingPlanes(nb),c})
                        break;
                    end
                    sequencesTemp=find(plainsSeqP2{nonBelongingPlanes(nb),c}==1);
                    for s=1:length(sequencesTemp)
                        if ismember(sequencesTemp(s),sequencesNonBel)~=1
                            sequencesNonBel=[sequencesNonBel sequencesTemp(s)];
                        end
                    end
                end
%                disp(['Considering NoNbelonging plane ',num2str(nonBelongingPlanes(nb)),'. NoNbelonging actions: ',num2str(sequencesNonBel)])
                e_NoNbelonging=zeros(1,len2);
                for s=1:length(sequencesNonBel) %calculating the probability of the current NoNbelonging plane
                    e_NoNbelonging(sequencesNonBel(s))=1;
                    if sequencesNonBel(s)~=1
                        probNonBelPlane=probNonBelPlane*x(sequencesNonBel(s)+len1)/x(max(fathersSearch(sequencesNonBel(s),F2))+len1);
                    end
                end
%                disp(['E_NoNbelonging: ',num2str(e_NoNbelonging),' with probability ',num2str(probNonBelPlane)])
                finalSum=finalSum+( probNonBelPlane*max(0,transpose(x(1:len1))*U2*transpose((e_belonging-e_NoNbelonging))) - probBelPlane*max(0,transpose(x(1:len1))*U2*transpose((e_NoNbelonging-e_belonging))) );
            end
        end
        dx(i)=finalSum;
 %       disp(['DX: ',num2str(dx(i))])
        inc=inc+1;
    end
    %sumNonBelonging=sumNonBelonging+transpose(x(1:len1))*U2*(transpose(sequence)-x(len1+1:len1+len2));
end