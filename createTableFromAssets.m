
% Builds the Hashtable 
files=dir('assets/*.png') ; 
HashTable=struct('File', {}, 'Hash', {}) ; 
i=1 ; 
for file = files'
   HashTable(i).File=strcat('./assets/',file.name) ; 
   HashTable(i).Hash=imgToHash(strcat('./assets/',file.name)) ;
   i=i+1  
    % Do some stuff
end

%% Computes the distances between "Original"

L=size(HashTable', 1) ;
IntraDistances=zeros(L,L) ; 
for i=1:L 
    HI=HashTable(i).Hash ; 
    for j=1:L
         HJ=HashTable(j).Hash ; 
         D=bitxor(HI,HJ,'uint64') ; 
         
         n=sum(dec2bin(D)-'0')  ; 
         IntraDistances(i,j)=n ; 
    end
end




% La table des distances permet de voir que les images ont toutes un hash 
% diff?rent. La distance minimale r?duite est de 0.17
% En dessous de ce seuil, on pourra imaginer que c'est bon
% 0.05 ?


%% Candidates
files=dir('candidates/*.jpg') ; 
CandidateTable=struct('File', {}, 'Hash', {}) ; 
i=1 ; 
for file = files'
   CandidateTable(i).File=strcat('./candidates/',file.name) ; 
   CandidateTable(i).Hash=imgToHash(strcat('./candidates/',file.name)) ;
   i=i+1  
end

%% Computes the distance table btw Candidates and Original
L=size(HashTable', 1) ;
C=size(CandidateTable', 1) ; 
InterDistances=zeros(L,C) ; 
for i=1:L 
    HI=HashTable(i).Hash ; 
    for j=1:C
         HJ=CandidateTable(j).Hash ; 
         D=bitxor(HI,HJ,'uint64') ; 
         n=sum(dec2bin(D)-'0')  ; 
         InterDistances(i,j)=n ; 
    end
end


%% Displays the matches
for i=1:C
    F=CandidateTable(i).File ; 
    Res=HashTable((1-InterDistances(:,i)/64)>0.8) ; 
    fprintf('Candidate File:\t%s\n', F) ;
    % We recompute hash because i'm lazy
         HI=CandidateTable(i).Hash ;
  if (size(Res')>0)
      fprintf('Similar to:') ;
      for R = Res'
          HJ=R.Hash ; 
         D=bitxor(HI,HJ,'uint64') ; 
         n=sum(dec2bin(D)-'0')  ; 
         fprintf('\t%s(%.0f%%)', R.File, 100-n*100/64) 
      end
  else
      fprintf('No Match.') ;
  end
  
    fprintf('\n') 
end


