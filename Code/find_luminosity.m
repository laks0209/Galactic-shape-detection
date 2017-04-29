
function Luminosity = find_luminosity(Iin,centers,radii)
    [r t] = size(centers);
    Luminosity = zeros(r,1);
    for i = 1:r
        radius = uint8(radii(i));
        for j= -radius:radius
            for k = -radius:radius
                if (radius <= sqrt(double(abs(j)^2+abs(k)^2)))
                    if(((uint8(centers(i,1))-k)> 0) && ((uint8(centers(i,2))-j)> 0))
                        Luminosity(i) = Luminosity(i) + Iin(uint8(centers(i,1))-k,uint8(centers(i,2))-j);
                    end
                end
            end
        end
        Luminosity(i) = Luminosity(i)/(pi*(radii(i))^2);
    end