fid=fopen('a.txt','rt');
[A,count]=fscanf(fid,'%x ',[1,inf]);
test = dec2hex(A);

f1 = fopen('a.coe','w');

fprintf(f1, 'memory_initialization_radix=Hex;\n');
fprintf(f1, 'memory_initialization_vector=\n');

for i = 1 : count - 1
    fprintf(f1, '%s', dec2hex(A(i)));
    fprintf(f1, ',\n');
end

fprintf(f1, '%s', dec2hex(A(count)));
fprintf(f1, ';');
    
fclose(f1);
    



