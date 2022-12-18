stimuls=m1.Events(1).times;
behavir=m1.Events(2).times(1,2:end);
firstEl=m1.Time(1);
wrds={'zavitoy';
      'kudryav';
      'petlaus';
      'kurchav';
      'vyazany';
      'pleteny';
      'volnist';
      'kruchen'};
swrd=wrds;  % sort words
%% 1-3->0 +3
wrd=[1,1,7,12,14,16;
     2,6,24,33,37,39;
     3,2,11,20,25,40;
     4,3,9,26,34,35;
     5,4,13,18,19,30;
     6,5,17,27,32,38;
     7,8,10,22,23,36;
     8,15,21,28,29,31];
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
%%
mtime=mean(dtime,2); % mean behavioral response time
[tmn,imn]=sort(mtime); % sort of mean
bar(tmn)
%%
for i=1:Nstr
    swrd{i,1}=wrds{imn(i),1};
end
%%