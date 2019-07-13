function [sizeInBits, coefficients] = compressBlock190707Gray(matrix, rmseThreshold)
  
  % Size 16 block
  n = 16;
  
  % First order approximation
  [order, coefficients] = compress1st(matrix);
  sizeInBits = 2 + order * 3 * 32;
  
  if(calculateRMSE(decompressBlock190707Gray(n, coefficients), matrix) > rmseThreshold)
    % Second order approximation
    [order, coefficients] = compress2nd(matrix);
    sizeInBits = 2 + order * 3 * 32;
    
    if(calculateRMSE(decompressBlock190707Gray(n, coefficients), matrix) > rmseThreshold)
      % Split matrix
      % Size 8 block
      n = 8;
      blocks = zeros(n, n, 4);
      blocks(:, :, 1) = matrix(1:n, 1:n);
      blocks(:, :, 2) = matrix(1:n, (n+1):(2*n));
      blocks(:, :, 3) = matrix((n+1):(2*n), 1:n);
      blocks(:, :, 4) = matrix((n+1):(2*n), (n+1):(2*n));
      coefficients = [];
      temp = [];
      sizeInBits = 0;
      tempSize = 0;
      for i = 1:4
        % First order approximation
        [order, temp] = compress1st(blocks(:, :, i));
        tempSize = 2 + order * 3 * 32;
        if(calculateRMSE(decompressBlock190707Gray(n, temp), blocks(:, :, i)) > rmseThreshold)
          % Second order approximation
          [order, temp] = compress2nd(blocks(:, :, i));
          tempSize = 2 + order * 3 * 32;
          temp = [3;temp];
        else
          temp = [2;temp];
        end
        sizeInBits = sizeInBits + tempSize;
        coefficients = [coefficients;temp];
      end      
    else
      coefficients = [1;coefficients];
    end
  else
    coefficients = [0;coefficients];
  end
end

function [order, coefficients] = compress1st(matrix)
  n = size(matrix, 1);
  coefficients = zeros(3,1);
  A = zeros(n*n, 3);
  temp = ones(3,1);
  for x = (-n/2):(n/2-1)
    % [1 x y]
    temp(2, 1) = x;
    for y = (-n/2):(n/2-1)
      temp(3, 1) = y;
      A((y + n/2) + n * (x + n/2) + 1, :) = temp;
    end
  end
  coefficients = pinv(A) * matrix(:);
  order = 1;
end

function [order, coefficients] = compress2nd(matrix)
  n = size(matrix, 1);
  coefficients = zeros(6,1);
  A = zeros(n*n, 6);
  temp = ones(6,1);
  for x = (-n/2):(n/2-1)
    % [1 x y x^2 y^2 xy]
    temp(2, 1) = x;
    temp(4,1) = x*x;
    for y = (-n/2):(n/2-1)
      temp(3, 1) = y;
      temp(5, 1) = y * y;
      temp(6, 1) = x * y;
      A((y + n/2) + n * (x + n/2) + 1, :) = temp;
    end
  end
  coefficients = pinv(A) * matrix(:);
  order = 2;
end