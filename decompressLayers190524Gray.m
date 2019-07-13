function decompressedLayers = decompressLayers190524Gray(compressedLayers)
  numOfLayers = compressedLayers(1);
  m = compressedLayers(2);
  n = compressedLayers(3);
  decompressedLayers = zeros(m, n, numOfLayers);
  counter = 4;
  for i = 1:numOfLayers
    [lastIndex, temp] = decompressLayer(counter, compressedLayers);
    decompressedLayers(:, :, i) = temp;
    counter = lastIndex;
  end
  decompressedLayers = uint8(decompressedLayers);
end

function [lastIndex, decompressedLayer] = decompressLayer(counter, compressedLayers)
  m = compressedLayers(2);
  n = compressedLayers(3);
  mExtended = m + (16 - mod(m,16));
  nExtended = n + (16 - mod(n,16));
  decompressedLayer = zeros(mExtended, nExtended);
  w = 1;
  h = 1;
  while(h < n)
    while(w < m)
      [tempBlock, lastIndex] = reconstructBlock190524Gray(counter, compressedLayers);
      counter = lastIndex;
      decompressedLayer(w:(w+15), h:(h+15)) = tempBlock;
      w = w + 16;
    end
    w = 1;
    h = h + 16;
  end
  decompressedLayer = decompressedLayer(1:m, 1:n);
end
