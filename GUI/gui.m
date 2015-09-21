function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 16-May-2015 14:03:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @gui_OpeningFcn, ...
    'gui_OutputFcn',  @gui_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get(handles.radioSFNEreplicator,'Value')
% get(handles.radioSFAEreplicator,'Value')


x1=str2num(get(handles.edit6,'String'));
x2=str2num(get(handles.edit7,'String'));
x=[x1;x2];

U1=(get(handles.edit1,'String'));
U1=str2mat(U1);
U1=str2num(U1);


U2=(get(handles.edit2,'String'));
U2=str2mat(U2);
U2=str2num(U2);

F1=(get(handles.edit10,'String'));
F1=str2mat(F1);
F1=str2num(F1);

F2=(get(handles.edit11,'String'));
F2=str2mat(F2);
F2=str2num(F2);

TimeMax=str2double(get(handles.edit5,'String'));
Time=0.1:0.1:TimeMax;



if get(handles.radioSFNEreplicator,'Value')==1
    [T1,Yn]=ode113(@(t,y) generalSFNEReplicator(t,y,U1,U2,F1,F2),Time,x);
   Yn
    
    display('NORMAL replicator')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesNormal(T1,Yn,U1,U2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T1,Yn,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1normal(T1,Yn,U1,U2);
    end
    
elseif get(handles.radioSFAEreplicator,'Value')==1
    [T2,Ya]=ode113(@(t,y) generalSFAEReplicator(t,y,U1,U2,F1,F2),Time,x);
    Ya
    display('AGENT replicator')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesAgent(T2,Ya,U1,U2,F1,F2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T2,Ya,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1agent(T2,Ya,U1,U2,F1,F2);
    end
    
elseif get(handles.radioSFAElogit,'Value')==1
    eta=str2double(get(handles.edit12,'String'));
    
    [T2,Ya]=ode113(@(t,y) generalSFAELogit(t,y,U1,U2,F1,F2,eta),Time,x);
    Ya
    display('AGENT logit')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesAgent(T2,Ya,U1,U2,F1,F2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T2,Ya,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1agent(T2,Ya,U1,U2,F1,F2);
    end
    
    
elseif get(handles.radioSFAEbnn,'Value')==1
    
    [T2,Ya]=ode113(@(t,y) generalSFAEBNN(t,y,U1,U2,F1,F2),Time,x);
    Ya
    display('AGENT bnn')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesAgent(T2,Ya,U1,U2,F1,F2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T2,Ya,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1agent(T2,Ya,U1,U2,F1,F2);
    end
    
elseif get(handles.radioSFNElogit,'Value')==1
    eta=str2double(get(handles.edit12,'String'));
    [T1,Yn]=ode113(@(t,y) generalSFNELogit(t,y,U1,U2,F1,F2,eta),Time,x);
    Yn
    display('NORMAL logit')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesNormal(T1,Yn,U1,U2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T1,Yn,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1normal(T1,Yn,U1,U2);
    end
    
elseif get(handles.radioSFAEsmith,'Value')==1
    
    [T2,Ya]=ode113(@(t,y) generalSFAESmith(t,y,U1,U2,F1,F2),Time,x);
    Ya
    display('AGENT smith')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesAgent(T2,Ya,U1,U2,F1,F2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T2,Ya,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1agent(T2,Ya,U1,U2,F1,F2);
    end
elseif get(handles.radioSFNEsmith,'Value')==1
    [sequencesP1,planesP1]=planeToSequencesExpTime(F1);
    [sequencesP2,planesP2]=planeToSequencesExpTime(F2);
    [T2,Ya]=ode113(@(t,y) generalSFNESmith(t,y,U1,U2,F1,F2,planesP1,planesP2),Time,x);
    Ya
    display('NORMAL smith')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesNormal(T2,Ya,U1,U2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T2,Ya,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1normal(T2,Ya,U1,U2);
    end
elseif get(handles.radioSFNEbnn,'Value')==1
    [sequencesP1,planesP1]=planeToSequencesExpTime(F1);
    [sequencesP2,planesP2]=planeToSequencesExpTime(F2);
    [T1,Yn]=ode113(@(t,y) generalSFNEBNN(t,y,U1,U2,F1,F2,planesP1,planesP2),Time,x);
    Yn
    display('NORMAL BNN')
    
    if get(handles.checkbox1,'Value')==1
        showExpectedUtilitiesNormal(T1,Yn,U1,U2);
    end
    
    if get(handles.checkbox2,'Value')==1
        showProbabilities(T1,Yn,U1);
    end
    
    if get(handles.checkbox3,'Value')==1
        showE2overE1normal(T1,Yn,U1,U2);
    end
end





function showExpectedUtilitiesNormal(T1,Yn,U1,U2)
%Expected utilities
S=size(U1);
len1=S(1);
len2=S(2);
E1=zeros(length(T1),1);
E2=zeros(length(T1),1);
for ii=1:length(T1)
    E1(ii)=Yn(ii,1:len1)*U1*transpose(Yn(ii,len1+1:len1+len2));
    E2(ii)=Yn(ii,1:len1)*U2*transpose(Yn(ii,len1+1:len1+len2));
end

figure('Name','EU1 & EU2 over time, SFNE'), axis auto;
xlabel('Time'); % x-axis label
ylabel('Utilities'); % y-axis label
hold on;
plot(T1,E1,'+','color','green');
plot(T1,E2,'o','color','red');
legend ('E1','E2');
hold off;

function showExpectedUtilitiesAgent(T2,Ya,U1,U2,F1,F2)
S=size(U1);
len1=S(1);
len2=S(2);
S1=size(F1);
S2=size(F2);
if S1(1)>1 %se il gioco � banalmente costituito da solo q0, � inutile plottare le utilit�
    Etemp=zeros(length(T2),S1(1)); %utilit� dell'info set trovato;
    for ii=1:S1(1) %ciclo su ogni riga della matrice F
        if ii==1 %non si plotta q0, ovviamente
            continue;
        end
        row=F1(ii,:);
        vTemp=[]; %vettore temporaneo dove salvare i membri di ogni info set (giocatore);
        for jj=1:length(row) %trovo tutti i membri dell'info set
            if row(jj)==1
                vTemp=[vTemp jj];
            end
        end
        
        Yatemp=[];
        U1temp=[];
        for jj=1:length(vTemp)
            Yatemp=[Yatemp Ya(:,vTemp(jj))];
            %creo un Ya contenente SOLO le colonne relative ai membri dell'info set trovato. Normalmente dovrebbero essere
            %contigue (quindi basterebbe prendere Ya da vTemp(1) fino a vTemp(last)), ma per evitare di inserire vincoli sulla creazione di F preferisco unirle
            %iterativamente.
            U1temp=[U1temp; U1(vTemp(jj),:)]; %U1 con solo le righe relative ai membri dell'info set trovato.
        end
        for jj=1:length(T2)
            Etemp(jj,ii)=Yatemp(jj,:)*U1temp*transpose(Ya(jj,len1+1:len1+len2));
        end
    end
    
    figure('Name','Expected utility info set 1.x'), axis auto; %il -1 � dovuto al fatto che,per esempio, la seconda riga di F rappresenta l'info set 1.1
    xlabel('Time'); % x-axis label
    ylabel('Utility'); % y-axis label
    hold on;
    legendTemp='';
    symbols = ['+','o','*','.','-','s','x','^','v','>','<','p','h'];
    for ii=2:S1(1) %parte da 2 per evitare di plottare l'utilit� di q0, che � sempre 0.
        r=[rand rand rand];
        if ii==1
            legendTemp='q0';
            plot(T2,Etemp(:,ii),symbols(ii),'color',r);
        else
            plot(T2,Etemp(:,ii),symbols(ii),'color',r);
            legendTemp=char(legendTemp,strcat('Infoset 1.',num2str(ii-1))); %il -1 � dovuto al fatto che q0 non si conta
        end
    end
    legend (legendTemp);
    hold off;
end

if S2(1)>1 %se il gioco � banalmente costituito da solo q0, � inutile plottare le utilit�
    Etemp=zeros(length(T2),S2(1)); %utilit� dell'info set trovato;
    for ii=1:S2(1) %ciclo su ogni riga della matrice F
        if ii==1 %non si plotta q0, ovviamente
            continue;
        end
        row=F2(ii,:);
        vTemp=[]; %vettore temporaneo dove salvare i membri di ogni info set (giocatore);
        for jj=1:length(row) %trovo tutti i membri dell'info set
            if row(jj)==1
                vTemp=[vTemp jj];
            end
        end
        
        Yatemp=[];
        U2temp=[];
        for jj=1:length(vTemp)
            Yatemp=[Yatemp Ya(:,vTemp(jj))];
            %creo un Ya contenente SOLO le colonne relative ai membri dell'info set trovato. Normalmente dovrebbero essere
            %contigue (quindi basterebbe prendere Ya da vTemp(1) fino a vTemp(last)), ma per evitare di inserire vincoli sulla creazione di F preferisco unirle
            %iterativamente.
            U2temp=[U2temp U2(:,vTemp(jj))]; %U1 con solo le colonne relative ai membri dell'info set trovato.
        end
        
        for jj=1:length(T2)
            Etemp(jj,ii)=Ya(jj,len1+1:len1+len2)*U2temp*transpose(Yatemp(jj,:));
        end
    end
    
    figure('Name','Expected utility info set 2.x'), axis auto; %il -1 � dovuto al fatto che,per esempio, la seconda riga di F rappresenta l'info set 1.1
    xlabel('Time'); % x-axis label
    ylabel('Utility'); % y-axis label
    hold on;
    legendTemp='';
    symbols = ['+','o','*','.','-','s','x','^','v','>','<','p','h'];
    for ii=2:S2(1) %parte da 2 per evitare di plottare l'utilit� di q0, che � sempre 0.
        r=[rand rand rand];
        if ii==1
            legendTemp='q0';
            plot(T2,Etemp(:,ii),symbols(ii),'color',r);
        else
            plot(T2,Etemp(:,ii),symbols(ii),'color',r);
            legendTemp=char(legendTemp,strcat('Infoset 2.',num2str(ii-1))); %il -1 � dovuto al fatto che q0 non si conta
        end
    end
    legend (legendTemp);
    hold off;
end

function showProbabilities(T2,Ya,U1)

%   PLOT PROBABILITA' PER OGNI GIOCATORE
S=size(U1); %it is the same with U2, since both have the same size
len1=S(1); %torna il numero di righe della matrice di utilit�, cio� il numero di azioni di G1
len2=S(2); %torna il numero di righe della matrice di utilit�, cio� il numero di azioni di G2
symbols = ['+','o','*','.','-','s','x','^','v','>','<','p','h'];
figure('Name','P1 strategy'), axis([0 length(Ya)*0.1 0 1]);
xlabel('Time'); % x-axis label
ylabel('Probabilities'); % y-axis label
hold on;
legendTemp='';
for ii=1:len1
    r=[rand rand rand];
    if ii==1
        plot(T2,Ya(:,ii),symbols(ii),'color',r);
        legendTemp='q0';
    elseif ii>length(symbols)
        plot(T2,Ya(:,ii),symbols(mod(ii,length(symbols))+1),'color',r);
        legendTemp=char(legendTemp,strcat('Action ',num2str(ii-1)));
    else
        plot(T2,Ya(:,ii),symbols(ii),'color',r);
        legendTemp=char(legendTemp,strcat('Action ',num2str(ii-1))); %il -1 � dovuto al fatto che q0 non si conta
    end
end
legend (legendTemp);
hold off;

figure('Name','P2 strategy'), axis([0 length(Ya)*0.1 0 1]);
xlabel('Time'); % x-axis label
ylabel('Probabilities'); % y-axis label
hold on;
legendTemp='';
for ii=len1+1:len1+len2
    r=[rand rand rand];
    if ii==len1+1
        plot(T2,Ya(:,ii),symbols(ii-len1),'color',r);
        legendTemp='q0';
    elseif (ii-len1)>length(symbols)
        plot(T2,Ya(:,ii),symbols(mod(ii-len1,length(symbols))+1),'color',r);
        legendTemp=char(legendTemp,strcat('Action ',num2str(ii-1-len1)));    
    else
        plot(T2,Ya(:,ii),symbols(ii-len1),'color',r);
        legendTemp=char(legendTemp,strcat('Action ',num2str(ii-1-len1))); %il -1 � dovuto al fatto che q0 non si conta
    end
end
legend (legendTemp);
hold off;

function showE2overE1normal(T1,Yn,U1,U2)
S=size(U1);
len1=S(1);
len2=S(2);
E1=zeros(length(T1),1);
E2=zeros(length(T1),1);

for ii=1:length(T1)
    
    E1(ii)=Yn(ii,1:len1)*U1*transpose(Yn(ii,len1+1:len1+len2));
    E2(ii)=Yn(ii,1:len1)*U2*transpose(Yn(ii,len1+1:len1+len2));
end


figure('Name','EU2 over EU1'), axis auto;
xlabel('Utility Player 1'); % x-axis label
ylabel('Utility Player 2'); % y-axis label
hold on;
plot(E1,E2,'-','color','blue');
hold off;

function showE2overE1agent(T2,Ya,U1,U2,F1,F2)
S=size(U1);
len1=S(1);
len2=S(2);
S1=size(F1);
S2=size(F2);
if S1(1)>1 %se il gioco � banalmente costituito da solo q0, � inutile plottare le utilit�
    Etemp1=zeros(length(T2),S1(1)); %utilit� dell'info set trovato;
    Etemp2=zeros(length(T2),S1(1));
    for ii=1:S1(1) %ciclo su ogni riga della matrice F
        if ii==1 %non si plotta q0, ovviamente
            continue;
        end
        row=F1(ii,:);
        vTemp=[]; %vettore temporaneo dove salvare i membri di ogni info set (giocatore);
        for jj=1:length(row) %trovo tutti i membri dell'info set
            if row(jj)==1
                vTemp=[vTemp jj];
            end
        end
        
        Yatemp=[];
        U1temp=[];
        U2temp=[];
        for jj=1:length(vTemp)
            Yatemp=[Yatemp Ya(:,vTemp(jj))];
            %creo un Ya contenente SOLO le colonne relative ai membri dell'info set trovato. Normalmente dovrebbero essere
            %contigue (quindi basterebbe prendere Ya da vTemp(1) fino a vTemp(last)), ma per evitare di inserire vincoli sulla creazione di F preferisco unirle
            %iterativamente.
            U1temp=[U1temp; U1(vTemp(jj),:)]; %U1 con solo le righe relative ai membri dell'info set trovato.
            U2temp=[U2temp; U2(vTemp(jj),:)];
        end
        for jj=1:length(T2)
          
            Etemp1(jj,ii)=Yatemp(jj,:)*U1temp*transpose(Ya(jj,len1+1:len1+len2));    
            Etemp2(jj,ii)=Ya(jj,len1+1:len1+len2)*transpose(U2temp)*transpose(Yatemp(jj,:));
        end
    end
    
    figure('Name','Expected utility info set 1.x'), axis auto; %il -1 � dovuto al fatto che,per esempio, la seconda riga di F rappresenta l'info set 1.1
   xlabel('Utility Player 1'); % x-axis label
    ylabel('Utility Player 2'); % y-axis label
    hold on;
    legendTemp='';
    symbols = ['+','o','*','.','-','s','x','^','v','>','<','p','h'];
    for ii=1:S1(1) %parte da 2 per evitare di plottare l'utilit� di q0, che � sempre 0.
        r=[rand rand rand];
        if ii==1
            legendTemp='q0';
            plot(Etemp1(:,ii),Etemp2(:,ii),symbols(ii),'color',r);
        else
            plot(Etemp1(:,ii),Etemp2(:,ii),symbols(ii),'color',r);
            legendTemp=char(legendTemp,strcat('Infoset 1.',num2str(ii-1))); %il -1 � dovuto al fatto che q0 non si conta
        end
    end
    legend (legendTemp);
    hold off;
end

if S2(1)>1 %se il gioco � banalmente costituito da solo q0, � inutile plottare le utilit�
    Etemp2=zeros(length(T2),S2(1)); %utilit� dell'info set trovato;
    Etemp1=zeros(length(T2),S2(1));
    for ii=1:S2(1) %ciclo su ogni riga della matrice F
        if ii==1 %non si plotta q0, ovviamente
            continue;
        end
        row=F2(ii,:);
        vTemp=[]; %vettore temporaneo dove salvare i membri di ogni info set (giocatore);
        for jj=1:length(row) %trovo tutti i membri dell'info set
            if row(jj)==1
                vTemp=[vTemp jj];
            end
        end
        
        Yatemp=[];
        U2temp=[];
        U1temp=[];
        for jj=1:length(vTemp)
            Yatemp=[Yatemp Ya(:,vTemp(jj))];
            %creo un Ya contenente SOLO le colonne relative ai membri dell'info set trovato. Normalmente dovrebbero essere
            %contigue (quindi basterebbe prendere Ya da vTemp(1) fino a vTemp(last)), ma per evitare di inserire vincoli sulla creazione di F preferisco unirle
            %iterativamente.
            U2temp=[U2temp U2(:,vTemp(jj))]; %U1 con solo le colonne relative ai membri dell'info set trovato.
            U1temp=[U1temp U1(:,vTemp(jj))];
        end
        
        for jj=1:length(T2)
            Etemp2(jj,ii)=Ya(jj,len1+1:len1+len2)*U2temp*transpose(Yatemp(jj,:));

            Etemp1(jj,ii)=Yatemp(jj,:)*transpose(U1temp)*transpose(Ya(jj,len1+1:len1+len2));
        end
       
    end
     figure('Name','Expected utility info set 2.x'), axis auto; %il -1 � dovuto al fatto che,per esempio, la seconda riga di F rappresenta l'info set 1.1
     xlabel('Utility Player 1'); % x-axis label
    ylabel('Utility Player 2'); % y-axis label
     hold on;
    legendTemp='';
    symbols = ['+','o','*','.','-','s','x','^','v','>','<','p','h'];
    for ii=1:S2(1) %parte da 2 per evitare di plottare l'utilit� di q0, che � sempre 0.
        r=[rand rand rand];
        if ii==1
            legendTemp='q0';
            plot(Etemp1(:,ii),Etemp2(:,ii),symbols(ii),'color',r);
        else
            plot(Etemp1(:,ii),Etemp2(:,ii),symbols(ii),'color',r);
            legendTemp=char(legendTemp,strcat('Infoset 2.',num2str(ii-1))); %il -1 � dovuto al fatto che q0 non si conta
        end
    end
    legend (legendTemp);
    hold off;
end




function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radioSFNEreplicator.
function radioSFNEreplicator_Callback(hObject, eventdata, handles)
% hObject    handle to radioSFNEreplicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioSFNEreplicator


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over radioSFAEreplicator.
function radioSFAEreplicator_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to radioSFAEreplicator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uipanel1.
function uibuttongroup1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
try
    % Get the values of the radio buttons in this group.
    radio1Value = get(handles.radioSFNEreplicator, 'Value');
    radio2Value = get(handles.radioSFAEreplicator, 'Value');
    radio3Value = get(handles.radioSFAElogit, 'Value');
    radio4Value = get(handles.radioSFAEbnn, 'Value');
    radio5Value = get(handles.radioSFNElogit, 'Value');
    radio6Value = get(handles.radioSFAEsmith, 'Value');
    radio7Value = get(handles.radioSFNEbnn, 'Value');
    radio8Value = get(handles.radioSFNEsmith, 'Value');
    
    
    if radio1Value==1
        if strcmp(get(handles.uipanel6, 'visible'),'on')
            set(handles.uipanel6,'visible','off')
        end
    end
    if radio2Value==1
        if strcmp(get(handles.uipanel6, 'visible'),'on')
            set(handles.uipanel6,'visible','off')
        end
    end
    if radio3Value==1
        if strcmp(get(handles.uipanel6, 'visible'),'off')
            set(handles.uipanel6,'visible','on')
        end
    end
    if radio4Value==1
        
        if strcmp(get(handles.uipanel6, 'visible'),'on')
            set(handles.uipanel6,'visible','off')
        end
    end
    if radio5Value==1
        
        if strcmp(get(handles.uipanel6, 'visible'),'off')
            set(handles.uipanel6,'visible','on')
        end
    end
    if radio6Value==1
        
        if strcmp(get(handles.uipanel6, 'visible'),'on')
            set(handles.uipanel6,'visible','off')
        end
    end
    if radio7Value==1
        
        if strcmp(get(handles.uipanel6, 'visible'),'on')
            set(handles.uipanel6,'visible','off')
        end
    end
    if radio8Value==1
        
        if strcmp(get(handles.uipanel6, 'visible'),'on')
            set(handles.uipanel6,'visible','off')
        end
    end
    
catch ME
    errorMessage = sprintf('Error in function uipanel1_SelectionChangeFcn.\n\nError Message:\n%s', ME.message);
    fprintf('%s\n', errorMessage);
    uiwait(warndlg(errorMessage));
end
