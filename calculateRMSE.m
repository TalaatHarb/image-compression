function rmse = calculateRMSE(otherMatrix, matrix)
  [m, n] = size(matrix);
  diff = matrix(:) - otherMatrix(:);
  diffSquared = diff .* diff;
  rmse = sqrt(sum(diffSquared(:)) / (m*n));
  if(size(matrix, 3) == 3)
    rmse = rmse / sqrt(3);
  end
end