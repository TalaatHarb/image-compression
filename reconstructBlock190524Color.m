function [block, lastIndex] = reconstructBlock190524Color(index, coefficients)
  counter = index;
  if(coefficients(counter) == 0)
    lastIndex = counter + 4;
    block = decompressBlock190524Color(16, coefficients((counter+1):(lastIndex-1)));
  elseif(coefficients(counter) == 1)
    lastIndex = counter + 7;
    block = decompressBlock190524Color(16, coefficients((counter+1):(lastIndex-1)));
  elseif(coefficients(counter) > 1)
    blocks = zeros(8, 8, 4);
    for i = 1:4
      if(coefficients(counter) == 2)
        lastIndex = counter + 4;
        blocks(:, :, i) = decompressBlock190524Color(8, coefficients((counter+1):(lastIndex-1))).';
        counter = lastIndex;
      elseif(coefficients(counter) == 3)
        lastIndex = counter + 7;
        blocks(:, :, i) = decompressBlock190524Color(8, coefficients((counter+1):(lastIndex-1))).';
        counter = lastIndex;
      end
    end    
    block = [[blocks(:, :, 1) blocks(:, :, 2)];[blocks(:, :, 3) blocks(:, :, 4)]];    
  end

end