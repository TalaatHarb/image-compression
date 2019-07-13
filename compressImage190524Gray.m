function [compressedImage, sizeInBits] = compressImage190524(imagePath, rmseThreshold)
  image = imread(imagePath);
  numOfLayers = size(image, 3);
  if(numOfLayers == 3)
    [Y, CB, CR] = RGBtoYCBCR(image);
    [compressedY, sizeY] = compressLayer(double(Y) - 128 * ones(size(Y)), rmseThreshold);
    [compressedCB, sizeCB] = compressLayer(double(CB), rmseThreshold);
    [compressedCR, sizeCR] = compressLayer(double(CR), rmseThreshold);
    compressedImage = [size(image,3);size(image,1);size(image,2); compressedY; compressedCB; compressedCR];
    sizeInBits = sizeY + sizeCB + sizeCR;
  else
    Y = image;
    [compressedY, sizeY] = compressLayer(Y, rmseThreshold);
    compressedImage = [size(image,3);size(image,1);size(image,2); compressedY];
    sizeInBits = sizeY;
  end  
end

function [compressedLayer, sizeInBits] = compressLayer(layer, rmseThreshold)
  [m, n] = size(layer);
  mExtended = m + (16 - mod(m,16));
  nExtended = n + (16 - mod(n,16));
  numOfMBlocks = mExtended / 16;
  numOfNblocks = nExtended / 16;
  compressedLayer = [];
  temp = [];
  indexX = 1;
  endX = 16;
  indexY = 1;
  endY = 16;
  sizeInBits = 0;
  for y = 1:numOfNblocks
    indexY = 16 * y - 15;
    endY = indexY + 15;
    if(y == numOfNblocks)
      endY = n;
    end
    for x = 1:numOfMBlocks
      tempBlock = zeros(16, 16);
      indexX = 16 * x - 15;
      endX = indexX + 15;
      if(x == numOfMBlocks)
        endX = m;
      end
      tempBlock(1:(endX-indexX + 1), 1:(endY-indexY + 1)) = layer(indexX:endX, indexY:endY);
      
      % Possible padding
      if(x == numOfMBlocks)
        for i = 1:16
          tempBlock((endX-indexX + 2):16, i) = tempBlock((endX-indexX + 1), i) .* ones(size(tempBlock((endX-indexX + 2):16, i)));
        end
      end
      if(y == numOfNblocks)
        for i = 1:16
          tempBlock(i, (endY-indexY + 2):16) = tempBlock(i, (endY-indexY + 1)) .* ones(size(tempBlock(i, (endY-indexY + 2):16)));
        end
      end
      % TODO: Add better padding
      [blockBits, temp] = compressBlock(tempBlock, rmseThreshold);
      compressedLayer = [compressedLayer; temp];
      sizeInBits = sizeInBits + blockBits;
    end
  end
end