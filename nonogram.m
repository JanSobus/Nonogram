%%% Initial Matlab implementation with 3 puzzles (simply uncomment one you want)
function nonogram()
%%% 3 Puzzles for testing included below, pretty rough format so far.
%%% Included as vectors of single cells with arrays inside - TODO, better format.
%%% Simply uncomment a pair of rows and cols variables to give
%%% the main function something to chew on.

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
%%% Apart from graphical representation, there is also ASCII representation.
%%% First I create the empty solution matrix of proper dimentions, filled with "?"
sol=char(63*ones(nrows,ncols));
%%% Also create cells that will hold potential solutions for each row and column
prows = cell(nrows,1);
pcols = cell(ncols,1);
%%% Use "generator" function to populate potential solution cells with
%%% all mathematically allowed ones
for i=1:nrows
    prows(i) = generator(rows(i),ncols);
end

for i=1:ncols
    pcols(i) = generator(cols(i),nrows);
end
%%% As long as there are unknown spaces in the puzzle the loop will run over
%%% Rows and columns and apply 2 functions
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
end

end

%%% Function generating all possible solution vectors at the beggining of
%%% the puzzle for a given row column.
function output = generator(input,len)
  vector = input{1}; %Unwrap the input vector
  n_mid_spaces = length(vector)-1; %Number of spots for spaces between colored blocks
  free_spaces = len-sum(vector)-n_mid_spaces; %Number of "free" spaces that can be put in any space block
  %I want to create spaces array with vectors that shows number of spaces at the beginning/end
  % of the row and between colored blocks.
  % If there are no free spaces, there will there will be 0 spaces at the beginning/end
  % of the row and 1 between each of the blocks
  if (free_spaces > 0)
    % If there are free space, I create all the combinations of assigning them to empty spots as a matrix
    perm_free_spaces = sb(free_spaces,length(vector)+1);
    spaces = perm_free_spaces + ones(size(perm_free_spaces,1),1)*[0,ones(1,n_mid_spaces),0];
  else
    spaces = [0,ones(1,n_mid_spaces),0];
  end
  % The number of possible solutins will be determined by the number of free spaces combinations
  output= char(zeros(size(spaces,1),len));
  %Generating the potential row/column solutions using initial vector and spaces array
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

% Borrowed function used for creating combinations of free spaces.
% In the initial description it simply generates all combinations
% of putting nmar marbles in nbin bins.
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

% Function that deletes possible solutions from the raw/column (raw) solution space
% if they are incompatible with current state of total solution
function cleaned = deleter(raw,ref)
  raw=raw{1};
  drows=[];
  for i=1:size(raw,1)
    for j=1:length(ref)
        % If there is a contradiction between proposed and real solution,
        % delete row from proposed solution space
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


% Function that insert the markings we are sure about
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

%Function showing solution in a graphical form using updating plot as an animation.

function printer(sol)
  %Decoding ASCII solution into numbers
  sol(sol(:,:) == 'X') = '0';
  sol(sol(:,:) == '?') = '1';
  sol(sol(:,:) == 'B') = '2';
  sol=num2cell(sol);
  sol=cellfun(@str2num,sol);
  clims=[0,2];
  imagesc(sol,clims);
  pause(0.05);
end
