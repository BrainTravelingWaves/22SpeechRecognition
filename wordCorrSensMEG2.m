%% Load data
MM=3; % 1-m1 2-m2 3-m3
Nchn=306;
%% word list
wrds={'zavitoy','vozmojn','vzaimny';
      'kudryav','dostupn','dvoyaky';
      'petlaus','pravdop','dvukrat';
      'kurchav','pronicm','sdvoeny';
      'vyazany','sudohod','dvoichn';
      'pleteny','realizm','oboudny';
      'volnist','osushes','dvuliky';
      'kruchen','vypolnm','dvoistv'};
 %% Numbers of stimulus
 wrd1=[4,10,15,17,19;  % 104 110....
     9,27,36,40,42;
     5,14,23,28,43;
     6,12,29,37,38;
     7,16,21,22,33;
     8,20,30,35,41;
     11,13,25,26,39;
     18,24,31,32,34];
 %%
 wrd2=[7,18,20,22,34; % 207 218....+++3
       9,17,21,39,40;
       11,14,28,29,32;
       4,24,35,41,42;
       5,13,15,27,43;
       6,19,26,30,38;
       8,10,12,16,37;
       23,25,31,33,36];
  %%
 wrd3=[12,22,29,35,43; % 312 322....+++3
       11,21,24,25,33;
       5,20,27,30,31;
       4,8,18,32,40;
       6,7,19,36,41;
       9,10,16,23,28;
       13,14,17,26,39;
       15,34,37,38,42];
%% Labeles of words
if MM==1 
    Nstr=8;
    Nwrd=5;
    wrd=wrd1;
    stimulus=m1.Events(1).times; % Start word
    %behavir=m1.Events(2).times(1,4:end); % Reaction
    timeSig=m1.Time;     % Signal time
    sig=m1.F(1:Nchn,:);  % Signal of MEG
end
%%
if MM==2 
    Nstr=8;
    Nwrd=5;
    wrd=wrd2;
    stimulus=m2.Events(1).times; % Start word
    %behavir=m2.Events(2).times(1,2:end); % Reaction
    timeSig=m2.Time;     % Signal time
    sig=m2.F(1:Nchn,:);  % Signal of MEG
end
%%
if MM==3 
    Nstr=8;
    Nwrd=5;
    wrd=wrd3;
    stimulus=m3.Events(1).times; % Start word
    %behavir=m3.Events(2).times(1,2:end); % Reaction
    timeSig=m3.Time;     % Signal time
    sig=m3.F(1:Nchn,:);  % Signal of MEG
end 
%% Find labeles numbers 
Nsignal=size(timeSig,2);
tTime=zeros(Nstr,Nwrd);
for i=1:Nstr
    for j=1:Nwrd
        jj=1;
        while jj < Nsignal+1
          if timeSig(jj) > stimulus(wrd(i,j))
            break  
          end
          jj=jj+1;
        end
        tTime(i,j)=jj;
    end
end
%% Matrix of correlation 306
dTime=1000;
sigMGG=zeros(Nchn,dTime);
corrsig=zeros(Nchn,Nchn);
corpval=corrsig;
tresh=0.7;
%%%%%
jj=1;
for ns=1:Nstr % 1-8

for nw=1:Nwrd % 1-5
%%%    
% MEG1+GRD2+GRD3
for i=1:Nchn
    sigMGG(i,:)=sig(i,tTime(ns,nw)+1:tTime(ns,nw)+dTime);
end

%%% cor_MGG_MGG
for i=1:Nchn
    sig1=sigMGG(i,:);
    for j=1:Nchn
        sig2=sigMGG(j,:);
        [corrsig(i,j),corpval(i,j)]=corr(sig1',sig2');
        if i==j
            corrsig(i,j)=0;
        end
        if corrsig(i,j)<tresh
            corrsig(i,j)=0;
        end        
    end
end
nullstr='';
if jj<100
    nullstr='0';
end
if jj<10
    nullstr='00';
end
numst=strcat(nullstr,num2str(jj));
save(strcat(numst,'MGG_MGGc',num2str(ns),'_',num2str(nw)),'corrsig')
save(strcat(numst,'MGG_MGGp',num2str(ns),'_',num2str(nw)),'corpval')
jj=jj+1;
end
end
%% View correlation 
jj=1;
for ns=1:8 % 1-8
for nw=1:5 % 1-5
%%% MGG_MGG
nullstr='';
if jj<100
    nullstr='0';
end
if jj<10
    nullstr='00';
end
numst=strcat(nullstr,num2str(jj));
load(strcat(numst,'MGG_MGGc',num2str(ns),'_',num2str(nw))); % corrsig
jj=jj+1;
figure(1)
imagesc(corrsig)
name=strcat('MGG',wrds{ns,MM},num2str(nw));
title(name)
colorbar
name=strcat(numst,name,'.fig');
savefig(name)
close(1)
end
end
%% Differences
corsum=zeros(Nchn,Nchn);
corsumW=zeros(Nchn,Nchn,Nstr);
jj=1;
for ns=1:Nstr
    corsumS=zeros(Nchn,Nchn);
for nw=1:Nwrd
    nullstr='';
    if jj<100
       nullstr='0';
    end
    if jj<10
       nullstr='00';
    end
    numst=strcat(nullstr,num2str(jj));
    numst=strcat(numst,'MGG_MGGc',num2str(ns),'_',num2str(nw),'.mat');
    load(numst);
    corsum=corsum+corrsig;
    corsumS=corsumS+corrsig;
    jj=jj+1;
end
    corsumW(:,:,ns)=corsumS/Nwrd;
end
corsum=corsum/(Nstr*Nwrd);
%% Filtr tresh Save MGG+
for j=1:Nchn
    for i=1:Nchn
        if corsum(i,j)<0.7
            corsum(i,j)=0;
        end
    end
end
save('MGG+','corsum')
figure(1)
imagesc(corsum)
name='MGG+';
title(name)
colorbar
name=strcat(name,'.fig');
savefig(name)
%close(1)
%% Save MGG minus
for ns=1:Nstr
    corsumW(:,:,ns)=corsumW(:,:,ns)-corsum;
    for j=1:Nchn
        for i=1:Nchn
            if corsumW(i,j,ns)<0.7
              corsumW(i,j,ns)=0;
            end
        end
    end
end
save('MGG-','corsumW')
for ns=1:Nstr
    corsum=corsumW(:,:,ns);
    figure(ns)
    imagesc(corsum)
    name=strcat('MGG-',wrds{ns,MM});
    title(name)
    colorbar
    name=strcat(name,'.fig');
    savefig(name)
    close(ns)
end
%% Recognition
for ii=1:Nstr
corsum=corsumW(:,:,ii);
weight_w=zeros(Nstr,Nwrd);
jj=1;
for ns=1:Nstr
    for nw=1:Nwrd
        nullstr='';
        if jj<100
           nullstr='0';
        end
        if jj<10
           nullstr='00';
        end
        numst=strcat(nullstr,num2str(jj));
        load(strcat(numst,'MGG_MGGc',num2str(ns),'_',num2str(nw))); % corrsig    
        for i=1:Nchn
            for j=1:Nchn
                if corsum(i,j)>0
                   weight_w(ns,nw)=weight_w(ns,nw)+corrsig(i,j);
                end
            end
        end        
        jj=jj+1;
    end
end
  figure(ii)
  imagesc(weight_w)
  name=wrds{ii,MM};
  title(name)
  colorbar
  name=strcat(num2str(ii),name,'.fig');
  savefig(name)
  close(ii)
end
%% Netword
%Nstr=8;
%Nwrd=5;
Nchn=306;
netword=zeros(Nchn*Nchn,1);
ii=1;
for jj=1:Nstr
for i=1:Nchn
    j=i;
    netword(ii,1)=-i;
    ii=ii+1;
    while j < Nchn
        if corsumW(i,j,jj)>0.7
            netword(ii,1)=j;
            ii=ii+1;
        end
        j=j+1;
    end
end
    netword(ii,1)=0;
    ii=ii+1;
end
%netword(ii:end,:)=[];
networds=zeros(size(netword));
j=1;
for i=1:ii-1
    if netword(i,1)==0
        networds(j,1)=0;
        j=j+1;
    end
    if netword(i,1)>0
        if netword(i-1,1)<0
           networds(j,1)=netword(i-1,1); 
           j=j+1; 
        end
        networds(j,1)=netword(i,1);
        j=j+1;
    end
end
networds(j-1:end,:)=[];
plot(networds)
%% Load to Brainstorm
Nchn=306;
%Nstr=8;
%e.F=[];
e.Time=[];
e.Time=(0:Nchn*Nstr-1)*1+1;
%e.F(:,Nchn*Nstr+1:end)=[];
e.F=[];
e.F=zeros(Nchn+27,Nchn*Nstr);
e.Events=[];
jj=1;
for iStr=1:Nstr
    corsum=corsumW(:,:,iStr);
    cs=zeros(Nchn,1);
for i=1:Nchn
    for j=1:Nchn
        cs(i,1)=cs(i,1)+corsum(i,j);
    end
end
corsum(:,Nchn)=cs;
e.F(1:Nchn,jj:jj+Nchn-1)=corsum;
jj=jj+Nchn;
end
e.Comment='MGG-';
e.Comment=strcat(e.Comment,wrds{1,MM}); 
%%