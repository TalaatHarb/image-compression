function decompressedImage = decompressImage190524Gray(compressedImage)
  numOfLayers = compressedImage(1);
  m = compressedImage(2);
  n = compressedImage(3);
  decompressedImage = zeros(m, n, numOfLayers);
  counter = 4;
  for i = 1:numOfLayers
    [lastIndex, temp] = decompressLayer(counter, compressedImage);
    decompressedImage(:, :, i) = temp;
    counter = lastIndex;
  end
  decompressedImage(:, :, 1) = decompressedImage(:, :, 1) + 128 * ones(m, n);
  if(numOfLayers == 3)
    [R, G, B] = YCBCRtoRGB(uint8(decompressedImage));
    decompressedImage(:, :, 1) = R;
    decompressedImage(:, :, 2) = G;
    decompressedImage(:, :, 3) = B;
  end
  decompressedImage = uint8(decompressedImage);
end

function [lastIndex, decompressedLayer] = decompressLayer(counter, compressedImage)
  m = compressedImage(2);
  n = compressedImage(3);
  mExtended = m + (16 - mod(m,16));
  nExtended = n + (16 - mod(n,16));
  decompressedLayer = zeros(mExtended, nExtended);
  w = 1;
  h = 1;
  while(h < n)
    while(w < m)
      [tempBlock, lastIndex] = reconstructBlock(counter, compressedImage);
      counter = lastIndex;
      decompressedLayer(w:(w+15), h:(h+15)) = tempBlock;
      w = w + 16;
    end
    w = 1;
    h = h + 16;
  end
  decompressedLayer = decompressedLayer(1:m, 1:n);
end
