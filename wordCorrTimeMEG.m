%stimuls=zav.Events(1).times;
%behavir=zav.Events(2).times(1,2:end);
m=m1;
firstEl=m.Time(1);
stimuls=m1.Events(1).times;
behavir=m1.Events(2).times(1,2:end);
%%
Nstr=8;
Nwrd=5;
%%
wrd=[1,1,7,12,14,16;
     2,6,24,33,37,39;
     3,2,11,20,25,40;
     4,3,9,26,34,35;
     5,4,13,18,19,30;
     6,5,17,27,32,38;
     7,8,10,22,23,36;
     8,15,21,28,29,31];
%% Number of combination
iii=1;
for ii=1:Nwrd
    jjj=ii+1;
    for jj=jjj:Nwrd 
        iii=iii+1;
    end
end
%%
Nstr=8;
Nwrd=5;
dtime=zeros(Nstr,Nwrd); % delta time
ttime=dtime; % start time
for j=1:Nstr
    for i=1:Nwrd
        k=wrd(j,i+1)+3;
        dtime(j,i)=behavir(1,k)-stimuls(1,k);
        ttime(j,i)=behavir(1,k);
    end
end
Ncmb=iii-1;
%%
Nper=1000;
Nchn=306;
sige=zeros(Nwrd,Nper); % 
icor=zeros(Nstr,Ncmb);
istr=zeros(Nchn,Nstr);
jstr=zeros(Nchn,Nstr);
for i=1:Nchn
    for j=1:Nstr
        for k=1:Nwrd
            itime=int32((ttime(j,k)-firstEl)*1000);
            sige(k,:)=m.F(i,itime:itime+Nper-1);
        end
        iii=1;
        for ii=1:Nwrd
            jjj=ii+1;
            for jj=jjj:Nwrd 
                sig1=sige(ii,:);
                sig2=sige(jj,:);
                icor(j,iii)=corr(sig1',sig2');
                iii=iii+1;
            end
        end
    end
    for j=1:Nstr
       jstr(i,j)=mean(icor(j,:)); % mean of correlation
    end
    i
end
contourf(icor)