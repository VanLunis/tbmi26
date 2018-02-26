%%Main program

k = 3;
gwinit(k);
gwdraw();
s = gwstate();
Q = rand(s.xsize, s.ysize, 4);
Q(1,:,2) = -inf; %up
Q(s.xsize, :, 1) = -inf; %down
Q(:, 1, 4) = -inf; %left
Q(:, s.ysize, 3) = -inf; %right

oldQ = zeros(size(Q));
newQ = Q;
counter = 0;
while ~(isequal(oldQ, newQ))
    oldQ = newQ;
    newQ = findgoal(newQ,k);
    counter = counter +1;
    %display((isequal(oldQ, newQ)))
    %display(counter)
end
display(counter)
gwdraw();
gwplotallarrows(newQ);
