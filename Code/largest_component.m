
function F = largest_component(E)
    [m,n] = size(E);
    % largest connected component
[L,num] = bwlabel(E);
pix = zeros(1,num);
for(i=1:m)
    for(j=1:n) 
        if(L(i,j)~=0)
            a = L(i,j);
            pix(a) = pix(a) + 1;
        end
    end
end
maximum = max(pix);
for(a = 1:num)
    if(pix(a)==maximum)
        k = a;
    end   
end
F = zeros(m,n);
for(i=1:m)
    for(j=1:n)  
        if(L(i,j)==k)
            F(i,j) = 1;
        end  
    end
end