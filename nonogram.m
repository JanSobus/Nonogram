%%% Initial Matlab implementation with 3 puzzles (simply uncomment one you want)
function nonogram()
% rows = [{[3,3]},{[2,4,2]},{[1,2,1]},{[1,1]},{[2,2]},{[3,3]},{[3,3]},{[6]},{[4]},{[2]}];

%rows = [{[2,2]},{[1,1,1,2,1]},{[2,1,6]},{[3,2,1,1]},{[1,2,2,8]},{[1,3,1,1]},...
%     {[1,2]},{[1,2]},{[2,2]},{[5,2]},{[4,4]},{[4]},{[4]},{[14]},{[15]},...
%     {[1,1,1,1,1,2]},{[1,1,1,3,1,1,2]},{[1,1,1,2,1,1,2]},...
%     {[1,1,1,3,1,1,2]},{[2,2,3,1,2]}];

% rows = [{[2]},{[6]},{[1]},{[1,1,2]},{[2,3,2]},{[6,1,3]},...
%     {[1,7]},{[1,1,5]},{[2,3,2,3]},{[6,1,8]},{[10,1]},{[7]},{[5]},{[3,1,1]},{[3,2,3,2]},...
%     {[6,1,2]},{[2,7]},{[1,5]},...
%     {[3]},{[3]}];
rows =[{[2,1,1,11]},{[2,11]},{[4,4]},{[9,1]},{[1,3,4,1]},...
    {[7,3]},{[4,4,2]},{[1,3,2]},{[3,1,3,3]},{[2,1,1,3,6]},...
    {[1,3,1,2,2]},{[6,3,1,6]},{[13,2,2]},{[13,2,2]},{[13,3,3]},...
    {[1,11,8]},{[2,2,4,2,1,6]},{[3,4,2,8]},{[4,5,4,2]},{[3,2,1,3]},...
    {[4,4]},{[1,2,1,1,3]},{[3,1,2,5,1]},{[4,1,4,3,1,1]},{[1,4,3,1,2,1,1,1]}];
nrows = length(rows);
% cols = [{5},{[2,3]},{[1,3]},{[2,3]},{[2,3]},{[2,3]},{[2,3]},{[1,3]},{[2,3]},{5}];

%cols = [{[7]},{[5,2,1]},{[2,1,10]},{[2,8,1]},{[2,12]},{[2,6]},{[4,1,2,1,2]},...
%     {[2,2,1,2,4]},{[2,3,7]},{[1,2,2]},{[1,2,3]},{[2]},{[1,1,7]},{[5,2]},...
%     {[1,2,2]},{[2,1,2]},{[2,1,2]},{[1,2,2]},{[5,2]},{[1,1,1]}];

% cols = [{[1]},{[2]},{[3]},{[2]},{[3]},{[4]},{[2,5]},...
%     {[7,2]},{[4,7]},{[1,4,1]},{[2,3,2]},{[2,3,2]},{[1,2,2,2]},{[2,3,2,3]},...
%     {[1,2,4,2,4]},{[1,6,6]},{[1,2,4,2,4]},{[1,3,3]},{[6,3]},{[3,1]}];
cols = [{[8]},{[2,4,2,4]},{[1,6,2,2]},{[11,3]},{[7,2,2]},...
{[5,4,1]},{[1,8,6,6]},{[2,1,2,7,2]},{[6,11,1]},{[1,5,8,2,2]},...
{[5,1,5,2,2]},{[4,1,2,7,2]},{[1,1,2,7,4]},{[2,1,1]},{[2,2,1]},...
{[2,1,2,6]},{[3,1,1,5,2]},{[3,2,2,1,7,2]},{[3,1,1,1,4,5]},{[7,2,1,6,2]},...
{[2,2,1,1,4,2,1,1]},{[1,3,9,2]},{[1,2,7,2,1]},{[1,2,1,1]},{[1,2,1]}];
ncols = length(cols);
sol=char(63*ones(nrows,ncols));
prows = cell(nrows,1);
pcols = cell(ncols,1);
for i=1:nrows
    prows(i) = generator(rows(i),ncols);
end
for i=1:ncols
    pcols(i) = generator(cols(i),nrows);
end
while(sum(sum(ismember(sol,'?'))) > 0)
    for i=1:nrows
        prows(i) = deleter(prows(i),sol(i,:));
        sol(i,:) = inserter(prows(i),sol(i,:));
        printer(sol);
    end
    for i=1:ncols
        pcols(i) = deleter(pcols(i),sol(:,i));
        sol(:,i) = inserter(pcols(i),sol(:,i));
        printer(sol);
    end
    %sol


end

end

function output = generator(input,len)
vector = input{1};
n_mid_spaces = length(vector)-1;
free_spaces = len-sum(vector)-n_mid_spaces;
if (free_spaces > 0)
    perm_free_spaces = sb(free_spaces,length(vector)+1);
    spaces = perm_free_spaces + ones(size(perm_free_spaces,1),1)*[0,ones(1,n_mid_spaces),0];
else
    spaces = [0,ones(1,n_mid_spaces),0];
end
output= char(zeros(size(spaces,1),len));
vector=[vector,0];
for i=1:size(spaces,1)
    row=[];
    for j=1:size(spaces,2)
        row=[row,char([88*ones(1,spaces(i,j)),66*ones(1,vector(j))])];
    end
    output(i,:)=row;
end
output = {output};
end

%Borrowed function
function conf = sb (nmar,nbin)
% Returns the position of nmar in nbin, allowing the marbles to be in the same bin.

% This is standard stars and bars.
numsymbols = nbin+nmar-1;
stars = nchoosek (1:numsymbols, nmar);

% Star labels minus their consecutive position becomes their index
% position!
idx = bsxfun (@minus, stars, [0:nmar-1]);

% Manipulate indices into the proper shape for accumarray.
nr = size (idx, 1);
a = repmat ([1:nr], nmar, 1);
b = idx';
conf = [a(:), b(:)];
conf = accumarray (conf, 1);
end

function cleaned = deleter(raw,ref)
raw=raw{1};
drows=[];
for i=1:size(raw,1)
    for j=1:length(ref)
        if (raw(i,j) == 'B' && ref(j) == 'X')
            drows=[drows,i];
        elseif (raw(i,j) == 'X' && ref(j) == 'B')
            drows=[drows,i];
        end
    end
end
raw(drows,:) = [];
cleaned = {raw};
end

function new_sol = inserter(poss,old_sol)
poss=poss{1};
for i=1:length(old_sol)
    u=unique(poss(:,i));
    if (length(u) == 1 && u == 'X' && old_sol(i) == '?')
    old_sol(i) = 'X';
    elseif (length(u) == 1 && u == 'B' && old_sol(i) == '?')
        old_sol(i) = 'B';
    end
end
new_sol=old_sol;
end
function printer(sol)
sol(sol(:,:) == 'X') = '0';
sol(sol(:,:) == '?') = '1';
sol(sol(:,:) == 'B') = '2';
sol=num2cell(sol);
sol=cellfun(@str2num,sol);
clims=[0,2];
imagesc(sol,clims);
pause(0.05);
end
