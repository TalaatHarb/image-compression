function rmse = calculateRMSE(otherMatrix, matrix)
  diff = matrix(:) - otherMatrix(:);
  diffSquared = diff .* diff;
  rmse = sqrt(sum(diffSquared(:))) / sqrt(prod(size(matrix)));
end