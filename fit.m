function coeff = fit(x, y, p)

switch(p)
  case 'poly1'
    coeff = fitN(x, y, 1);
  case 'poly2'
    coeff = fitN(x, y, 2);
  case 'poly3'
    coeff = fitN(x, y, 3);
  case 'poly4'
    coeff = fitN(x, y, 4);
  case 'poly5'
    coeff = fitN(x, y, 5);
  case 'poly6'
    coeff = fitN(x, y, 6);
  case 'poly7'
    coeff = fitN(x, y, 7);
  case 'poly8'
    coeff = fitN(x, y, 8);
  case 'poly9'
    coeff = fitN(x, y, 9);
  otherwise
    disp(['error: undefined model name: ' p]);
    coeff = NaN;
end
  
end

function coeff = fitN(x, y, n)
  num = length(x);
  coeff = zeros(n + 1, 1);
  A = zeros(num, n + 1);
  
  for pointCounter = 1:num
    temp = ones(1, n + 1);
    for coeffCounter = 2:(n+1)
      temp(1, coeffCounter) = x(pointCounter) * temp(1, coeffCounter - 1);
    end
    A(pointCounter, :) = temp;
  end
  coeff = (pinv(A) * y.');
end
