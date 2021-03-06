function [ HASH ] = imgToHash( imagefile )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

IMG=imread(imagefile) ;
% Arbitrary size for the image processing
AR_SIZE=512 ; 
IMG=imresize(IMG,[AR_SIZE AR_SIZE]) ; 

% We take a black and white version of the image
processedbwimg=im2bw(IMG,0.7) ;
I = (processedbwimg);
% This should be comprised between -1 and 1
J = dct2(I)/AR_SIZE;



% Take just the uppercorner 
AR_HASHSIZE=8;
uc=J(1:AR_HASHSIZE,1:AR_HASHSIZE) ; 
ucc=uc ; %imresize(J, [ AR_HASHSIZE  AR_HASHSIZE ], 'nearest') 
ucc(uc>0)=1 ;
ucc(uc<0)=0 ; 

% imshow(ucc) ; 
HASH=uint64(0) ; 
for i=1:AR_HASHSIZE
    for j=1:AR_HASHSIZE
        HASH=bitset(HASH,j+(i-1)*(AR_HASHSIZE), ucc(i,j), 'uint64' ) ;
    end
end


end

