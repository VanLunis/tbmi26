%% Choose an action, make the action and update Q

function Q = findgoal(Q,k)
 eps = 0.5;
 gwinit(k);
for counter = 1:40000000
    sPrev = gwstate();
    actions = [1 2 3 4];
    prob_a = [1 1 1 1]; %all actions are chosen with the same probability
    eps = eps - 0.001; % Random action with probability eps, greedy action with probability 1-eps
    if eps < 0
        eps = 0;
    end
    [action, opt_action] = chooseaction(Q, sPrev.pos(1), sPrev.pos(2), actions, prob_a, eps);
    sNew = gwaction(action); %new position
    
    if (sNew.isterminal == 1) %check if we have reached the goal
        break;
    end
    
    alpha = 0.1; %learning rate
    gamma = 0.9;
    maxQ = max(Q, [], 3);
    maxQVal = maxQ(sNew.pos(1), sNew.pos(2));
    newQVal = (1 - alpha) * Q(sPrev.pos(1), sPrev.pos(2), action) + alpha * (sPrev.feedback + gamma*maxQVal); 
    
    Q(sPrev.pos(1), sPrev.pos(2), action) = newQVal;
    %gwdraw();
    %gwplotallarrows(Q);
    %pause(0.5);
end

return;
end