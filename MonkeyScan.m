I1 = imread('Monkey1.png');
I2 = imread('Monkey2.png');
I3 = imread('Monkey3.png');
skipN = 64;
Vals = floor(256 * linspace(0,1,4000));
Vals = Vals(1:end);
cameraPos = [6.57609, -4.41293, 0.61978;
    5.91998, -5.17658, 0.61978;
    5.27602, -5.92609, 0.61978];

cameraRot(1,:) = [1.456-pi/2, 0, 0.861];
cameraRot(2,:) = [1.456-pi/2, 0, 0.861];
cameraRot(3,:) = [1.456-pi/2, 0, 0.861];
Points = zeros(length(Vals(1:skipN:end)).^2, 3);
IND = 1;

for x = 1:skipN:length(Vals)
    for y = 1:skipN:length(Vals)
        I1L = (I1(:,:,1) == Vals(x) & I1(:,:,3) == Vals(y));       
        I2L =  (I2(:,:,1) == Vals(x) & I2(:,:,3) == Vals(y));
        I3L =  (I3(:,:,1) == Vals(x) & I3(:,:,3) == Vals(y));
        if(isempty(find(I1L, 1)) && isempty(find(I2L, 1)) && isempty(find(I3L, 1)))
            continue
        end
        I = {I1L, I2L, I3L};
 
        ballPos = zeros(3,2);
        pixAngles = zeros(3,2);
        cameraAngles = zeros(3,3);
        for i = 1:3
            [centerX, centerY] = find(I{i});
            ballPos(i,:) = mean([centerY, size(I{i},2)-centerX]);
            pixAngles(i,:) = pix2Angle2D(ballPos(i,:), 0.035, [0.032, 0.032], [2048 2048]);
            cameraAngles(i,:) = angleToCameraVector(cameraRot(i,:), pixAngles(i,:))';
        end
        Points(IND,:) = lineIntersect([cameraPos,cameraAngles]);
        IND = IND + 1;
    end
end

Points1 = Points;
Points1(:,IND:end);
Points1(IND:end,:);
Points1(IND:end,:);
Points1(IND:end,:) = [];
Points1(Points1(:,1) > 100,:) = [0,0,0];

figure
scatter3(Points1(:,1),Points1(:,2),Points1(:,3),3,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',[0 .75 .75])
axis equal