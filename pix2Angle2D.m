function [angle] = pix2Angle2D(pix, fl, S, im)
angle = [-atan(((2*fl*im(1))/(S(1)*(im(1) - 2*pix(1))))^-1), -atan(((2*fl*im(2))/(S(2)*(im(2) - 2*pix(2))))^-1);];
end
