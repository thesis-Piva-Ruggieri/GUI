%implementation of the logit dynamic in sequence equivalent normal form
function [dx] = generalSFNELogit(t,x,U1,U2,F1,F2,eta)
    S=size(U1); %it is the same with U2, since both have the same size
    len1=S(1); %returns the number of rows of U, that is the number of sequences for player 1
    len2=S(2); %returns the number of columns of U, that is the number of sequences for player 1
    dx=zeros(len1+len2,1);
    dx(1)=0;
    dx(len1+1)=0;
    %controllare correttezza di F
    
    %denominators in logit form are common for all the sequences of a player
    denom1=planeToSequences(F1,U1,x,1,eta,1,'exp');
    denom2=planeToSequences(F2,U2,x,1,eta,2,'exp');
    for ii=2:len1
        num=planeToSequences(F1,U1,x,ii,eta,1,'exp'); %calculating numerator
        dx(ii)=(num/denom1)-x(ii);
    end
    
    inc=2;
    for ii=len1+2:len1+len2
        num=planeToSequences(F2,U2,x,inc,eta,2,'exp'); %calculating numerator
        dx(ii)=(num/denom2)-x(ii);
        inc= inc+1;
    end
end