function psnr = calculatePSNR(otherMatrix, matrix)
  psnr = 20*log10(255/calculateRMSE(otherMatrix, matrix));
end