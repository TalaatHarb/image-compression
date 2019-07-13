function [compressedLayers, sizeInBits] = compressLayers(image, rmseThreshold)
  numOfLayers = size(image, 3);
  if(numOfLayers == 3)
    [compressed1, size1] = compressLayer(double(image(:, :, 1)), rmseThreshold);
    [compressed2, size2] = compressLayer(double(image(:, :, 2)), rmseThreshold);
    [compressed3, size3] = compressLayer(double(image(:, :, 3)), rmseThreshold);
    compressedLayers = [size(image,3);size(image,1);size(image,2); compressed1; compressed2; compressed3];
    sizeInBits = size1 + size2 + size3 + 3 * 32;
  else
    [compressed1, size1] = compressLayer(image, rmseThreshold);
    compressedLayers = [size(image,3);size(image,1);size(image,2); compressed1];
    sizeInBits = size1 + 3 * 32;
  end  
end

function [compressedLayer, sizeInBits] = compressLayer(layer, rmseThreshold)
  [m, n] = size(layer);
  if(mod(m, 16) == 0)
    mExtended = m;
  else
    mExtended = m + (16 - mod(m,16));
  end
  if(mod(n, 16) == 0)
    nExtended = n;
  else
    nExtended = n + (16 - mod(n,16));
  end
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
      if(x == numOfMBlocks && (endX-indexX) > -1)
        for i = 1:16
          tempBlock((endX-indexX + 2):16, i) = tempBlock((endX-indexX + 1), i) .* ones(size(tempBlock((endX-indexX + 2):16, i)));
        end
      end
      if(y == numOfNblocks && (endY-indexY) > -1)
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