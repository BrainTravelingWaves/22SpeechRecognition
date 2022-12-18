%% Load data
MM=4; % 1-m1 2-m2 3-m3 % 4-m1+m2+m3
Nchn=306;
%% word list
wrds={'zavitoy';
      'kudryav';
      'petlaus';
      'kurchav';
      'vyazany';
      'pleteny';
      'volnist';
      'kruchen';
      'vozmojn';
      'dostupn';
      'pravdop';
      'pronicm';
      'sudohod';
      'realizm';
      'osushes';
      'vypolnm';
      'vzaimny';
      'dvoyaky';
      'dvukrat';
      'sdvoeny';
      'dvoichn';
      'oboudny';
      'dvuliky';
      'dvoistv'};
 %% Numbers of stimulus
 wrd4=[4,10,15,17,19;  % 104 110....
     9,27,36,40,42;
     5,14,23,28,43;
     6,12,29,37,38;
     7,16,21,22,33;
     8,20,30,35,41;
    11,13,25,26,39;
    18,24,31,32,34;
     7,18,20,22,34; % 207 218....+++3
     9,17,21,39,40;       
    11,14,28,29,32;
     4,24,35,41,42;
     5,13,15,27,43;
     6,19,26,30,38;
     8,10,12,16,37;
    23,25,31,33,36;
    12,22,29,35,43; % 312 322....+++3
    11,21,24,25,33;
     5,20,27,30,31;
      4,8,18,32,40;
      6,7,19,36,41;
     9,10,16,23,28;
    13,14,17,26,39;
    15,34,37,38,42];
%% Labeles of words
if MM==4
    Nstr=8*3;
    Nwrd=5;
    wrd=wrd4;
    stimulus=zeros(3,size(m1.Events(1).times,2)); % Start word
    stimulus(1,:)=m1.Events(1).times; % Start word
    stimulus(2,:)=m2.Events(1).times; % Start word
    stimulus(3,:)=m3.Events(1).times; % Start word
    %behavir=m1.Events(2).times(1,4:end); % Reaction
    timeSig1=m1.Time;                 % Signal time
    timeSig2=m2.Time;                 % Signal time
    timeSig3=m3.Time;                 % Signal time    
    sig1=m1.F(1:Nchn,:);  % Signal of MEG
    sig2=m2.F(1:Nchn,:);  % Signal of MEG
    sig3=m3.F(1:Nchn,:);  % Signal of MEG 
end
%% Find labeles numbers 
tTime=zeros(fix(Nstr/(MM-1)),Nwrd,MM-1);
for ii=1:MM-1
   if ii==1
      Nsignal=size(timeSig1,2);
      timeSig=timeSig1;
   end
   if ii==2
      Nsignal=size(timeSig2,2);
      timeSig=timeSig2;
   end
   if ii==3
      Nsignal=size(timeSig3,2);
      timeSig=timeSig3;
   end
for i=1:fix(Nstr/(MM-1))
    for j=1:Nwrd
        jj=1;
        while jj < Nsignal+1
          if timeSig(jj) > stimulus(ii,wrd(i,j))
            break  
          end
          jj=jj+1;
        end
        tTime(i,j,ii)=jj;
    end
end
end
%% Matrix of correlation 306 24 words
dTime=1000;
sigMGG=zeros(Nchn,dTime);
corrsig=zeros(Nchn,Nchn);
corpval=corrsig;
tresh=0.7;
%%%%%%%%%%%%%%%%%%%%
jj=1;
for ii=1:MM-1

for ns=1:fix(Nstr/(MM-1)) % 1-8

for nw=1:Nwrd % 1-5
%%%    
% MEG1+GRD2+GRD3
if ii==1
for i=1:Nchn
    sigMGG(i,:)=sig1(i,tTime(ns,nw,ii):tTime(ns,nw,ii)+dTime-1);
end
end
if ii==2
for i=1:Nchn
    sigMGG(i,:)=sig2(i,tTime(ns,nw,ii):tTime(ns,nw,ii)+dTime-1);
end
end
if ii==3
for i=1:Nchn
    sigMGG(i,:)=sig3(i,tTime(ns,nw,ii):tTime(ns,nw,ii)+dTime-1);
end
end
%%% cor_MGG_MGG
for i=1:Nchn
    sigc1=sigMGG(i,:);
    for j=1:Nchn
        sigc2=sigMGG(j,:);
        [corrsig(i,j),corpval(i,j)]=corr(sigc1',sigc2');
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
end
%% Differences
ns1=[1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8];
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
    numst=strcat(numst,'MGG_MGGc',num2str(ns1(ns)),'_',num2str(nw),'.mat');
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
    name=strcat('MGG-',wrds{ns});
    title(name)
    colorbar
    name=strcat(name,'.fig');
    savefig(name)
    %close(ns)
end
%% Recognition24
ns1=[1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8];
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
        ss=strcat(numst,'MGG_MGGc',num2str(ns1(ns)),'_',num2str(nw),'.mat');
        load(ss); % corrsig    
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
  name=wrds{ii};
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