function [R, G, B] = YCBCRtoRGB(image)
  y = double(image(:,:,1));
  [m,n] = size(y);
  cb_ = double(image(:,:,2)) - 128*ones(m, n);
  cr_ = double(image(:,:,3)) - 128*ones(m, n);
  
  R = uint8(zeros(m, n));
  G = uint8(zeros(m, n));
  B = uint8(zeros(m, n));
  
  temp = zeros(3, n);
  
  A = [1 0 1.402;1 -0.344136 -0.714136;1 1.772 0];
  
  for x = 1:m
    temp = A * [y(x, :); cb_(x, :); cr_(x, :)];
    R(x, :) = uint8(min(255, max(0, round(temp(1, :)))));
    G(x, :) = uint8(min(255, max(0, round(temp(2, :)))));
    B(x, :) = uint8(min(255, max(0, round(temp(3, :)))));
  end 
end