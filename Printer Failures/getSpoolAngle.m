function angle = getSpoolAngle(I)
markerLoc = BlueMarkerMask(I);
markerLoc = medfilt2(markerLoc, [20, 20]);
markerLoc = bwareaopen(markerLoc, 500);
measurementsMarker = regionprops(markerLoc, 'Area','Circularity', 'Centroid');
for i = 1:length(measurementsMarker)
    if(measurementsMarker(i).Circularity > 0)
        markerXY = measurementsMarker(i).Centroid;
        break;
    end
end
if(~exist('markerXY', 'var'))
    angle = 'UNABLE TO FIND MARKER';
    return
end
centerLoc = SpoolCenterMask(I);
centerLoc = medfilt2(centerLoc, [20, 20]);
measurementsCenter = regionprops(centerLoc, 'Area', 'Centroid');
centerXY = measurementsCenter(1).Centroid;
angle = atan2(markerXY(2) - centerXY(2), markerXY(1) - centerXY(1));
end

