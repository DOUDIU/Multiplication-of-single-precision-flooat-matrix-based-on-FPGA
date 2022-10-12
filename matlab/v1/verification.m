

Y = load('origin_data_4x4.txt');

Z = single(Y);
f1 = fopen('result_data_4x4.txt','w');
[r, c] = size(Z);

for i = 1 : r
    for j = 1 : c
        tem = num2hex(Z(i,j));
        fprintf(f1, '%s', tem);
        fprintf(f1, ' ');
    end
    fprintf(f1, '\n');
end

pod = Z * Z';

fclose(f1);





