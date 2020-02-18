function [V] = angleToCameraVector(cameraAngle, pixAngles)
rotMat = getXYZRot(cameraAngle);
Vcam = cross([-cos(pixAngles(1)) sin(pixAngles(1)) 0 ],[0 -sin(pixAngles(2)) cos(pixAngles(2))]);
Vcam = Vcam / norm(Vcam);
V = rotMat * Vcam';
end

