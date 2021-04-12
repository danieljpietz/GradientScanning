function [Height] = getPrintHeadHeight(Capture, FilimentMask)
Marker = PinkMarkerMask(Capture);
Marker = medfilt2(Marker,[25, 25]);

info = regionprops(Marker,'Area','BoundingBox');
if(length(info) < 1)
    Height = ('Marker Lost');
else
    boundBox = info(1).BoundingBox;
    lowestVal = boundBox(2) + boundBox(4);
end

Filiment = FilimentMask(Capture(1:round(end*0.75), :, :));
Filiment = medfilt2(Filiment,[1, 1]);
imshow(Filiment)

info = regionprops(Filiment,'Area','BoundingBox');
if(length(info) < 1)
    Height = ('Filiment Lost');
else
    boundBox = info(1).BoundingBox;
    highestVal = boundBox(2);
end


Height = highestVal-lowestVal;
end

