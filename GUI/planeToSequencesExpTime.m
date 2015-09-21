function [sequences,planes] = planeToSequencesExpTime(F)
tic
    children=childrenSearch(1,F,1); %find all children of F
    for c=1:length(children)
        if isempty(childrenSearch(children(c),F))~=1
            children(c)=0;
        end
    end
    %creating a cube: we store the FINAL brother sequences together, in the same (1,x) position of the cube, but in different (1,x)(1,Y) positions
    lastNodesArray={};
    planes=[];
    n=1;
    for c=1:length(children)
        if children(c)~=0
            lastNodesArray{1,n}={};
            lastNodesArray{1,n}{1,1}=children(c);
            bros=brothersSearch(F,children(c));
            children(c)=0;
            empty=0; %tracking empty brothers, to not create empty spaces in lastNodesArray
            for b=1:length(bros)
                index=find(children==bros(b));
                if isempty(index)~=1
                    lastNodesArray{1,n}{1,1+b-empty}=children(index);
                    children(index)=0;
                else
                    empty=empty+1;
                end
            end
            n=n+1;
        end
    end
    uniques={}; %this cell keeps track of the unique contribute of every iteration of the following loop, to avoid having sub-planes in the final matrix (planes)
    for i=1:length(lastNodesArray)
        if isempty(lastNodesArray{1,i})~=1
%             disp(['CHECKING NODE ',num2str(i)])
            p_temp=planesCalc(F,lastNodesArray,i,[lastNodesArray{1,i}{1,1}]); %calculating the new sub-plane, to be added to the global one (planes)
            if isempty(planes)
                planes=[planes;p_temp];
                uniPlanes=unique(planes);
                uniPlanes(uniPlanes==0)=[];
                uniques{1,length(uniques)+1}=uniPlanes; %adding contribute to uniques
            else
                uniTempPlanes=unique(p_temp);
                uniTempPlanes(uniTempPlanes==0)=[];
                check=1;
                for j=1:length(uniques)
                    if isempty(setdiff(uniTempPlanes,uniques{1,j}))==1 %checking if the contribute of the new sub-plane is useful or not. In the latter case it won't be added to the global planes
                        check=0;
                        break;
                    end
                end
                if check %the contribute is useful
                    uniques{1,length(uniques)+1}=uniTempPlanes;
                    S=size(planes);
                    S2=size(p_temp);
                    if S(2)~=S2(2) && (S(2)~=0 && S2(2)~=0) %if sizes mismatch, add zeros
                        if S(2)>S2(2)
                            zero=zeros(S2(1),S(2)-S2(2));
                            p_temp=[p_temp zero];
                        else
                            zero=zeros(S(1),S2(2)-S(2));
                            planes=[planes zero];
                        end
                        planes=[planes;p_temp];
                    else
                        planes=[planes;p_temp];
                    end
                end
            end
        end
    end
    sequences=lastNodesArray;
S=size(planes);
% planes
% disp(['Elapsed time: ',num2str(toc),'. Number of planes founded: ',num2str(S(1))])

end