%Main function to calculate contribute of a node in lastNodesArray to the global,final matrix(planes). Seq is the starting sequence of that node, to be carried between recursions
function [planes] = planesCalc(F,lastNodesArray,num,seq) %num è il nodo in cui mi trovo. Seq è la prima sequenza, che ricorsivamente chiama le altre
%     disp(['  Entrata nella funzione, num= ',num2str(num)])
    planes=[]; %the final matrix
    uniques={}; %this cell keeps track of the unique contribute of every iteration of the following loop, to avoid having sub-planes in the final matrix (planes)
    if num~=length(lastNodesArray)
        for i=num+1:length(lastNodesArray)
            if isempty(lastNodesArray{1,i})~=1
%                 disp(['     Ciclo su lastNodesArray (siamo in ',num2str(num),') i= ',num2str(i)])
                temp_planes=[];
                for_check=0; %this variable tells if we must skip the current iteration of the most external for loop
                for j=1:length(seq)
                    length_seq=length(fathersSearch(seq(j),F));
                    length_i=length(fathersSearch(lastNodesArray{1,i}{1,1},F));
                    if length_seq<length_i
                        fathers=fathersSearch(seq(j),F);
                        bros=[];
                        for f=1:length(fathers)
                            bros=[bros brothersSearch(F,fathers(f))];
                        end
                        bros=[bros brothersSearch(F,seq(j))];
                        if isempty(intersect(bros,fathersSearch(lastNodesArray{1,i}{1,1},F)))~=1 %the MAIN control; sequences which satisfy this condition have NOT to be matched together
                            for_check=1;
                            break;
                        end
                    else
                        fathers=fathersSearch(lastNodesArray{1,i}{1,1},F);
                        bros=[];
                        for f=1:length(fathers)
                            bros=[bros brothersSearch(F,fathers(f))];
                        end
                        bros=[bros brothersSearch(F,lastNodesArray{1,i}{1,1})];
                        if isempty(intersect(bros,fathersSearch(seq(j),F)))~=1 %the MAIN control; sequences which satisfy this condition have NOT to be matched together
                            for_check=1;
                            break;
                        end
                    end
                end
                if for_check
                    continue;
                end
                %                 disp(['        Sequenza ',num2str(seq),' confrontabile con nodo ',num2str(i)])
                vect=planesCalc(F,lastNodesArray,i,[seq lastNodesArray{1,i}{1,1}]); %starting the recursion
                S=size(vect);
                new_col=[];
                for j=1:length(lastNodesArray{1,num}) %take cares of brothers in the current node
                    if S(1)>0
                        for x=1:S(1)
                            new_col(x,1)=lastNodesArray{1,num}{1,j};
                        end
                    else
                        new_col(j,1)=lastNodesArray{1,num}{1,j};
                    end
                    temp_plane=[new_col vect];
                    temp_planes=[temp_planes;temp_plane];
                end
                if isempty(planes)
                    planes=temp_planes;
                    uniPlanes=unique(planes);
                    uniPlanes(uniPlanes==0)=[];
                    uniques{1,length(uniques)+1}=uniPlanes; %adding contribute to uniques
                else
                    S=size(planes);
                    S2=size(temp_planes);
%                     disp('INSIDE planesCalc')
                    uniTempPlanes=unique(temp_planes);
                    uniTempPlanes(uniTempPlanes==0)=[];
                    check=1;
                    for j=1:length(uniques)
                        if isempty(setdiff(uniTempPlanes,uniques{1,j}))==1
                            check=0;
                            break;
                        end
                    end
                    if check
                        uniques{1,length(uniques)+1}=uniTempPlanes; %adding contribute to uniques
                        if S(2)>S2(2) %planes has more rows than temp_planes
                            temp_planes(:,S(2))=0;
                            planes=[planes; temp_planes];
                        elseif S2(2)>S(2) %temp_planes has more rows than planes
                            planes(:,S2(2))=0;
                            planes=[planes; temp_planes];
                            %                         planes(all(planes==0,2),:)=[];
                        else %planes and temp_planes has the same number of rows
                            planes=[planes; temp_planes];
                        end
                    end
                end
            end
        end
        if isempty(planes)
            for j=1:length(lastNodesArray{1,num})
                planes=[planes;lastNodesArray{1,num}{1,j}];
            end
        end
    else %exit of the recursion
        for j=1:length(lastNodesArray{1,num})
            planes=[planes;lastNodesArray{1,num}{1,j}];
        end
    end
%     disp(['  USCITA dalla funzione, num= ',num2str(num)])
end