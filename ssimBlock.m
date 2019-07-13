function ssim = ssimBlock(matrix, otherMatrix)
  matrix = double(matrix);
  otherMatrix = double(otherMatrix);

  ux = mean(matrix(:));
  uy = mean(otherMatrix(:));
  vx = var(matrix(:));
  vy = var(otherMatrix(:));
  k1 = 0.01;
  k2 = 0.03;
  L = 255;
  covXY = mean(matrix(:).*otherMatrix(:))-ux.*uy;
  c1 = (k1 .* L).^2;
  c2 = (k2 .* L).^2;
  
  ssim = (2 .* ux .* uy + c1).*(2 .* covXY(1) + c2)./((ux .^2 + uy .^ 2 + c1).*(vx + vy + c2));
end