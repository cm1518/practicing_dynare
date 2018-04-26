% Copyright (C) 2001 Michel Juillard
%
function dynatype (s,var_list)
% DYNATYPE :	DYNATYPE ( [ 'filename' ] )
%		This optional command saves the simulation
%		results in a text file. The name of each 
%		variable preceeds the corresponding results.
%		This command must follow SIMUL.

global lgy_ lgx_ y_ endo_nbr

%fid=fopen([s,'.m'],'w') ;
sm=[s,'.m'];
fid=fopen(sm,'w') ;

n = size(var_list,1);
if n == 0
  n = endo_nbr;
  ivar = [1:n]';
  var_list = lgy_;
else
  ivar=zeros(n,1);
  for i=1:n
    i_tmp = strmatch(var_list(i,:),lgy_,'exact');
    if isempty(i_tmp)
      error (['One of the specified variables does not exist']) ;
    else
      ivar(i) = i_tmp;
    end
  end
end


for i = 1:n
	fprintf(fid,[lgy_(ivar(i),:), '=['],'\n') ;
	fprintf(fid,'\n') ;
	fprintf(fid,'%15.8g\n',y_(ivar(i),:)') ;
   	fprintf(fid,'\n') ;
   	fprintf(fid,'];\n') ;
  	fprintf(fid,'\n') ;
end
fclose(fid) ;

return ;
