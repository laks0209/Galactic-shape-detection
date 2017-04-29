function T=gbt(Ix)

p=length(Ix);
T=Ix(randi(p-1));
T0=0;

t1=Ix<=T;
t2=Ix>T;
m1=sum(Ix(t1))/sum(t1);
m2=sum(Ix(t2))/sum(t2);

while abs(T-T0)>10^-8
    T0=T;
    T=(m1+m2)/2;
    t1=Ix<T;
    t2=Ix>T;
    m1=sum(Ix(t1))/sum(t1);
    m2=sum(Ix(t2))/sum(t2);
end

 
 