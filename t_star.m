

xmesh =linspace(0,10,20);

solinit = bvpinit (xmesh, @guess);

sol = bvp5c (@bvpfcn, @bcfcn, solinit)

plot(sol.x, sol.y)

function dydx = bvpfcn(x,y)
Pr = 100;
dydx = [y(2)
        y(3)
        -0.5*y(1)*y(3)
        y(5)
        -Pr/2*y(1)*y(5)];
    
end

function res = bcfcn (ya, yb)
res = [ya(1)
        ya(2)
        yb(2)-1
        ya(4)
        yb(4)-1];
end

function g = guess(x)
g = [0
     0
     0
     0
     0];
end