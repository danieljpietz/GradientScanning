function I = lineIntersect(PV)
n = size(PV,1);
M = zeros(3*(n*(n-1)/2),3);
V = zeros(size(M,1),1);
count = 1;
for i = 1:n
    for j = 1:i-1
        for k = 1:3
            M(count,i) = PV(i,k+3);
            M(count,j) = -PV(j,k+3);
            V(count) = PV(j,k) - PV(i,k);
            count = count+1;
        end
    end
end
T = (M'*M)^-1 * M' * V;
I = mean(PV(:,1:3) + PV(:,4:6) .* T);
end

