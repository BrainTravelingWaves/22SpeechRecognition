%% Load data
Nchn=306;
MM=3; % 1-m1 2-m2 3-m3
%% word list
wrds={'zavitoy','vozmojn','vzaimny';
      'kudryav','dostupn','dvoyaky';
      'petlaus','pravdop','dvukrat';
      'kurchav','pronicm','sdvoeny';
      'vyazany','sudohod','dvoichn';
      'pleteny','realizm','oboudny';
      'volnist','osushes','dvuliky';
      'kruchen','vypolnm','dvoistv'};
% swrd=wrds;  % sort of words
%% 1-3->0 +3  Numbers of labeles
wrd1=[1,1,7,12,14,16;
     2,6,24,33,37,39;
     3,2,11,20,25,40;
     4,3,9,26,34,35;
     5,4,13,18,19,30;
     6,5,17,27,32,38;
     7,8,10,22,23,36;
     8,15,21,28,29,31];
 %%
 wrd2=[1,4,15,17,19,31;
       2,6,14,18,36,37;
       3,8,11,25,26,29;
       4,1,21,32,38,39;
       5,2,10,12,24,40;
       6,3,16,23,27,35;
       7,5,7,9,13,34;
       8,20,22,28,30,33];
  %%
 wrd3=[1,9,19,26,32,40;
       2,8,18,21,22,30;
       3,2,17,24,27,28;
       4,1,5,15,29,37;
       5,3,4,16,33,38;
       6,6,7,13,20,25;
       7,10,11,14,23,36;
       8,12,31,34,35,39];
%% Labeles of words
if MM==1 
    Nstr=8;
    Nwrd=5;
    wrd=wrd1;
    stimuls=m1.Events(1).times; % Start word
    %behavir=m1.Events(2).times(1,2:end); % Reaction
    firstEl=m1.Time(1);  % Start experiment
    sig=m1.F(1:Nchn,:);  % Signal of MEG
end
if MM==2 
    Nstr=8;
    Nwrd=5;
    wrd=wrd2;
    stimuls=m2.Events(1).times; % Start word
    %behavir=m2.Events(2).times(1,2:end); % Reaction
    firstEl=m2.Time(1);  % Start experiment
    sig=m2.F(1:Nchn,:);  % Signal of MEG
end
if MM==3 
    Nstr=8;
    Nwrd=5;
    wrd=wrd3;
    stimuls=m3.Events(1).times; % Start word
    %behavir=m3.Events(2).times(1,2:end); % Reaction
    firstEl=m3.Time(1);  % Start experiment
    sig=m3.F(1:Nchn,:);  % Signal of MEG
end 
%%
tTime=zeros(Nstr,Nwrd);
for i=1:Nstr
    for j=1:Nwrd
        tTime(i,j)=int32((stimuls(1,wrd(i,j+1))-firstEl)*1000)+1;
    end
end
%% Matrix of correlation 306
dTime=1000;
sigMGG=zeros(Nchn,dTime);
corrsig=zeros(Nchn,Nchn);
corpval=corrsig;
tresh=0.7;
%% 306
jj=1;
for ns=1:Nstr % 1-80
sigAMG=zeros(Nchn,dTime);
for nw=1:Nwrd % 1-5
%%%    
% MEG1+GRD2+GRD3
for i=1:Nchn
    sigMGG(i,:)=sig(i,tTime(ns,nw)+1:tTime(ns,nw)+dTime);
end
sigAMG=sigAMG+sigMGG;
%%% MGG_MGG
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
%AMG
for i=1:Nchn
    sig1=sigAMG(i,:);
    for j=1:Nchn
        sig2=sigAMG(j,:);
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
save(strcat(numst,'AMG_AMGc',num2str(ns),'_',num2str(nw+1)),'corrsig')
save(strcat(numst,'AMG_AMGp',num2str(ns),'_',num2str(nw+1)),'corpval')
jj=jj+1;
end
%% Matrix of correlation 102
NchnMG=102;
dTime=1000;
sigM1=zeros(NchnMG,dTime);
sigG2=sigM1;
sigG3=sigM1;
corrsig=zeros(NchnMG,NchnMG);
corpval=corrsig;
tresh=0.7;
%% 102
jj=1;
for ns=1:Nstr % 1-8
for nw=1:Nwrd % 1-5
%%%    
j=1; % MEG1 GRD2 GRD3
for i=1:NchnMG
    sigM1(i,:)=sig(j,tTime(ns,nw)+1:tTime(ns,nw)+dTime);
    sigG2(i,:)=sig(j+1,tTime(ns,nw)+1:tTime(ns,nw)+dTime);
    sigG3(i,:)=sig(j+2,tTime(ns,nw)+1:tTime(ns,nw)+dTime);
    j=j+3;
end
%sigMM1=sigMM1+sigM1;
%sigGG2=sigGG2+sigG2;
%sigGG3=sigGG3+sigG3;
%%% MEG1_MEG1
for i=1:NchnMG
    sig1=sigM1(i,:);
    for j=1:NchnMG
        sig2=sigM1(j,:);
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
save(strcat(numst,'MEG1_MEG1c',num2str(ns),'_',num2str(nw)),'corrsig')
save(strcat(numst,'MEG1_MEG1p',num2str(ns),'_',num2str(nw)),'corpval')
jj=jj+1;
%%%
%{
figure(1)
%ifig=ifig+1;
imagesc(corrsig)
Name=strcat('MEG1 ',wrds{ns},' ',num2str(nw));
title(Name)
colorbar
Name=strcat(Name,'.fig');
savefig(Name)
close(1)
%}
%%% GRD2_GRD2
for i=1:NchnMG
    sig1=sigG2(i,:);
    for j=1:NchnMG
        sig2=sigG2(j,:);
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
save(strcat(numst,'GRD2_GRD2c',num2str(ns),'_',num2str(nw)),'corrsig')
save(strcat(numst,'GRD2_GRD2p',num2str(ns),'_',num2str(nw)),'corpval')
jj=jj+1;
%{
figure(1)
imagesc(corrsig)
Name=strcat('GRD2 ',wrds{ns},' ',num2str(nw));
title(Name)
colorbar
Name=strcat(Name,'.fig');
savefig(Name)
close(1)
%}
%%% GRD3_GRD3
for i=1:NchnMG
    sig1=sigG3(i,:);
    for j=1:NchnMG
        sig2=sigG3(j,:);
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
save(strcat(numst,'GRD3_GRD3c',num2str(ns),'_',num2str(nw)),'corrsig')
save(strcat(numst,'GRD3_GRD3p',num2str(ns),'_',num2str(nw)),'corpval')
jj=jj+1;
%{
figure(1)
imagesc(corrsig)
Name=strcat('GRD3 ',wrds{ns},' ',num2str(nw));
title(Name)
colorbar
Name=strcat(Name,'.fig');
savefig(Name)
close(1)
%}
%%% MEG1_GRD2
for i=1:NchnMG
    sig1=sigM1(i,:);
    for j=1:NchnMG
        sig2=sigG2(j,:);
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
save(strcat(numst,'MEG1_GRD2c',num2str(ns),'_',num2str(nw)),'corrsig')
save(strcat(numst,'MEG1_GRD2p',num2str(ns),'_',num2str(nw)),'corpval')
jj=jj+1;
%%% MEG1_GRD2
for i=1:NchnMG
    sig1=sigM1(i,:);
    for j=1:NchnMG
        sig2=sigG2(j,:);
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
save(strcat(numst,'MEG1_GRD2c',num2str(ns),'_',num2str(nw)),'corrsig')
save(strcat(numst,'MEG1_GRD2p',num2str(ns),'_',num2str(nw)),'corpval')
jj=jj+1;
%%% GRD2_GRD3
for i=1:NchnMG
    sig1=sigG2(i,:);
    for j=1:NchnMG
        sig2=sigG3(j,:);
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
save(strcat(numst,'GRD2_GRD3c',num2str(ns),'_',num2str(nw)),'corrsig')
save(strcat(numst,'GRD2_GRD3p',num2str(ns),'_',num2str(nw)),'corpval')
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
nullstr='';
if jj<100
    nullstr='0';
end
if jj<10
    nullstr='00';
end
numst=strcat(nullstr,num2str(jj));
load(strcat(numst,'AMG_AMGc',num2str(ns),'_',num2str(6))); % corrsig
jj=jj+1;
figure(1)
imagesc(corrsig)
name=strcat('AMG',wrds{ns,MM});
title(name)
colorbar
name=strcat(name,'.fig');
savefig(name)
close(1)
end
%% View correlation
jj=1;
for ns=1:Nwrd % 1-8
for nw=1:Nstr % 1-5
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
nullstr='';
if jj<100
    nullstr='0';
end
if jj<10
    nullstr='00';
end
numst=strcat(nullstr,num2str(jj));
load(strcat(numst,'AMG_AMGc',num2str(ns),'_',num2str(6))); % corrsig
jj=jj+1;
figure(1)
imagesc(corrsig)
name=strcat('AMG',wrds{ns,MM});
title(name)
colorbar
name=strcat(name,'.fig');
savefig(name)
close(1)
end
%% Differences
%Nstr=8;
%Nwrd=5;
Nchn=306;
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
    jj=jj+1;
end
corsum=corsum/(Nstr*Nwrd);
%%
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
close(1)
%%
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
    figure(ns+1)
    imagesc(corsum)
    name=strcat('MGG-',wrds{ns});
    title(name)
    colorbar
    name=strcat(name,'.fig');
    savefig(name)
    close(ns+1)
end
%% Recognition
%Nstr=8;
%Nwrd=5;
Nchn=306;
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
    jj=jj+1;
end
  figure(ii)
  imagesc(weight_w)
  name=wrds{ii};
  title(name)
  colorbar
  name=strcat(name,'.fig');
  savefig(name)
  %close(ii)
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
e.F=[];
e.Time=[];
e.Time=(0:Nchn*Nstr-1)*1+1;
e.F=zeros(Nchn+27,Nchn*Nstr);
jj=1;
for iStr=1:Nstr
    corsum=corsumW(:,:,iStr);
for i=1:Nchn
    corsum(i,Nchn)=0;
    for j=1:Nchn
        corsum(i,Nchn)=corsum(i,Nchn)+corsum(i,j);
    end
end
e.F(1:Nchn,jj:jj+Nchn-1)=corsum;
jj=jj+Nchn;
end
e.Comment='MGG-';
for iStr=1:Nstr
  e.Comment=strcat(e.Comment,'+',wrds{iStr,MM});
end  
%%