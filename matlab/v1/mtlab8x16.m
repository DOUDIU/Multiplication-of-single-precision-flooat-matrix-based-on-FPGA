
% round(rand(4,16)*10)


A = load('origin_data_8x4.txt');
B = load('origin_data_4x16.txt');

Y = single(A);

f1 = fopen('result_data_8x4.txt','w');
[r, c] = size(Y);

% 正常存
for i = 1 : r
    for j = 1 : c
        tem = num2hex(Y(i,j));
        fprintf(f1, '%s', tem);
        fprintf(f1, ' ');
    end
    fprintf(f1, '\n');
end
fclose(f1);

Z = single(B);

f1 = fopen('result_data_4x16.txt','w');
[r, c] = size(Z);

% 正常存
for i = 1 : r
    for j = 1 : c
        tem = num2hex(Z(i,j));
        fprintf(f1, '%s', tem);
        fprintf(f1, ' ');
    end
    fprintf(f1, '\n');
end
fclose(f1);

g = Y * Z;