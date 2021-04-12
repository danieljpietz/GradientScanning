function [ratio,weight] = getRemainingFiliment(spoolSide,FilimentMaskFunction, spoolEmptySize, spoolFullSize, spoolFullWeight)
spoolSideFiltered = FilimentMaskFunction(spoolSide);
spoolSideFiltered = medfilt2(spoolSideFiltered, [50, 50]);
info = regionprops(spoolSideFiltered,'Area','BoundingBox');
boundBox = info(1).BoundingBox;
pixSize = boundBox(4);
ratio = (pixSize^2 - spoolEmptySize^2) / (spoolFullSize^2 - spoolEmptySize^2);
weight = ratio * spoolFullWeight;
end

