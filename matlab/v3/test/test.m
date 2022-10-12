for i = 1 : 4
    m = round(rand(1,1)*14)+1;
    n = round(rand(1,1)*14)+1;
    l = round(rand(1,1)*14)+1;
    fs = fopen('size.txt','at+');
    s = n + l * 16^2 + m * 16^4;
    fprintf(fs, '0%X ', s);
    fclose(fs);
    
    a = round(rand(m, l)*10);
    b = round(rand(n, l)*10);     % B矩阵存入时转置
    mul = a * b';
    
    fa = fopen('a.txt','at+');
    for x = 1 : m
        for y = 1 : l
            fprintf(fa, '%tx ', a(x,y));
        end
    end
    fclose(fa);
    
    fb = fopen('b.txt','at+');
    for j = 1 : n
        for k = 1 : l
            fprintf(fb, '%tx ', b(j,k));
        end
    end
    fclose(fb);
    
    fm = fopen('mul.txt','at+');
    for g = 1 : m
        for h = 1 : n
            fprintf(fm, '%d\t', roundn(mul(g, h),-4));
        end
        fprintf(fm, '\n');  % 每行后换行
    end
    fprintf(fm, '\n');  % 矩阵之间空一行
    fclose(fm);
end


fid=fopen('a.txt','rt');
[A,count]=fscanf(fid,'%x ',[1,inf]);
test1 = dec2hex(A);
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
fclose(fid);


fid=fopen('b.txt','rt');
[B,count]=fscanf(fid,'%x ',[1,inf]);
test2 = dec2hex(B);
f2 = fopen('b.coe','w');
fprintf(f2, 'memory_initialization_radix=Hex;\n');
fprintf(f2, 'memory_initialization_vector=\n');
for i = 1 : count - 1
    fprintf(f2, '%s', dec2hex(B(i)));
    fprintf(f2, ',\n');
end
fprintf(f2, '%s', dec2hex(B(count)));
fprintf(f2, ';');
fclose(f2);
fclose(fid);


fid=fopen('size.txt','rt');
[C,count]=fscanf(fid,'%x ',[1,inf]);
test3 = dec2hex(C);
f3 = fopen('size.coe','w');
fprintf(f3, 'memory_initialization_radix=Hex;\n');
fprintf(f3, 'memory_initialization_vector=\n');
for i = 1 : count - 1
    fprintf(f3, '%s', dec2hex(C(i)));
    fprintf(f3, ',\n');
end
fprintf(f3, '%s', dec2hex(C(count)));
fprintf(f3, ';');
fclose(f3);
fclose(fid);