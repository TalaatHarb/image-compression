function [Y, CB, CR] = RGBtoYCBCR(image)
  r = double(image(:,:,1));
  g = double(image(:,:,2));
  b = double(image(:,:,3));
  
  [m,n] = size(r);
  
  Y = uint8(zeros(m, n));
  CB = uint8(zeros(m, n));
  CR = uint8(zeros(m, n));
  
  temp = zeros(3, n);
  allOnes = ones(1, n);
  
  A = [0 0.299 0.587 0.114; 128 -0.168736 -0.331264 0.5; 128 0.5 -0.418688 -0.081312];
  
  for x = 1:m
    temp = A * [allOnes; r(x, :); g(x, :); b(x, :)];
    Y(x, :) = uint8(min(255, max(0, round(temp(1, :)))));
    CB(x, :) = uint8(min(255, max(0, round(temp(2, :)))));
    CR(x, :) = uint8(min(255, max(0, round(temp(3, :)))));
  end 
end