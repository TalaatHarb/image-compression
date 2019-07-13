function generatedMatrix = decompressBlock190524Color(n, coffiecents)
  generatedMatrix = zeros(n);
  coffCount = length(coffiecents);
  if(coffCount == 3)
    order = 1;
  elseif(coffCount == 6)
    order = 2;
  else
    return;
  end
  
  temp = ones(size(coffiecents));
  % Fill in the matrix_type
  for x = (-n/2):(n/2-1)
    % [1 x y x^2 y^2 x*y]
    temp(2, 1) = x;
    if(order == 2)
      temp(4, 1) = x * x;
    end
    for y = (-n/2):(n/2-1)
      temp(3, 1) = y;
      if(order == 2)
        temp(5, 1) = y * y;
        temp(6, 1) = x * y;
      end
      generatedMatrix((x + n/2) + 1, (y + n/2) + 1) = round(sum(temp .* coffiecents));
    end
  end   
end