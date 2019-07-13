% Test Script for functions
clc;

% Setting the threshold
rmseThreshold = 5;
disp(['Used threshold: ' num2str(rmseThreshold)]);

% Setting the image
imagePath = 'lena256color.bmp';
% imagePath = 'Butterfly.bmp';

disp(['Results for image: ' imagePath]);

disp('-----------------------------------------------------------------------');

% Loading the image in both RGB and YCBCR
disp(' ');
originalRGB = imread(imagePath);
originalR = originalRGB(:, :, 1);
originalG = originalRGB(:, :, 2);
originalB = originalRGB(:, :, 3);
[originalY, originalCB, originalCR] = RGBtoYCBCR(originalRGB);
originalYCBCR = uint8(zeros(size(originalRGB)));
originalYCBCR(:, :, 1) = originalY;
originalYCBCR(:, :, 2) = originalCB;
originalYCBCR(:, :, 3) = originalCR;
disp('Image loaded');

disp('-----------------------------------------------------------------------');

% Compression
disp(' ');
disp('Compressing from RGB.....');
startTime = rem(now, 1);
[compressedLayersFromRGB, sizeInBits] = compressLayers190524Color(originalRGB, rmseThreshold);
endTime = rem(now, 1);
disp(['Elapsed time in seconds = ' num2str((endTime - startTime) * 24 * 60 * 60)]);
disp(['Size in bits: ' num2str(sizeInBits)]);
% disp(['Original Size on disk in bits: ' num2str(dir(imagePath).bytes * 8)]);
disp(['Uncompressed size in bits: ' num2str(prod(size(originalRGB)) * 8)]);
disp(['Compression Ratio (100 * compressed/uncompressed %): ' num2str(100 * sizeInBits/(prod(size(originalRGB)) * 8)) '%']);

disp('-----------------------------------------------------------------------');

disp(' ');
disp('Compressing from YCBCR.....');
startTime = rem(now, 1);
[compressedLayersFromYCBCR, sizeInBits] = compressLayers190524Color(originalYCBCR, rmseThreshold);
endTime = rem(now, 1);
disp(['Elapsed time in seconds = ' num2str((endTime - startTime) * 24 * 60 * 60)]);
disp(['Size in bits: ' num2str(sizeInBits)]);
% disp(['Original Size on disk in bits: ' num2str(dir(imagePath).bytes * 8)]);
disp(['Uncompressed size in bits: ' num2str(prod(size(originalYCBCR)) * 8)]);
disp(['Compression Ratio (100 * compressed/uncompressed %): ' num2str(100 * sizeInBits/(prod(size(originalRGB)) * 8)) '%']);

disp('-----------------------------------------------------------------------');

% Decompression
disp(' ');
disp('Decompression from RGB...');
startTime = rem(now, 1);
decompressedRGB = decompressLayers190524Color(compressedLayersFromRGB);
endTime = rem(now, 1);
disp(['Elapsed time in seconds = ' num2str((endTime - startTime) * 24 * 60 * 60)]);

disp('-----------------------------------------------------------------------');

disp(' ');
disp('Decompression from YCBCR...');
startTime = rem(now, 1);
decompressedYCBCR = decompressLayers190524Color(compressedLayersFromYCBCR);
endTime = rem(now, 1);
disp(['Elapsed time in seconds = ' num2str((endTime - startTime) * 24 * 60 * 60)]);

disp('-----------------------------------------------------------------------');

% Pre-processing for statistics and visualization
disp(' ');
disp('Pre-processing...');
decompressedY = decompressedYCBCR(:, :, 1);
decompressedCB = decompressedYCBCR(:, :, 2);
decompressedCR = decompressedYCBCR(:, :, 3);

decompressedR = decompressedRGB(:, :, 1);
decompressedG = decompressedRGB(:, :, 2);
decompressedB = decompressedRGB(:, :, 3);

decompressedRGBfromYCBCR = uint8(zeros(size(originalRGB)));
[decompressedRfromYCBCR, decompressedGfromYCBCR, decompressedBfromYCBCR] = YCBCRtoRGB(decompressedYCBCR);
decompressedRGBfromYCBCR(:, :, 1) = decompressedRfromYCBCR;
decompressedRGBfromYCBCR(:, :, 2) = decompressedGfromYCBCR;
decompressedRGBfromYCBCR(:, :, 3) = decompressedBfromYCBCR;

decompressedYCBCRfromRGB = uint8(zeros(size(originalYCBCR)));
[decompressedYfromRGB, decompressedCBfromRGB, decompressedCRfromRGB] = RGBtoYCBCR(decompressedRGB);
decompressedYCBCRfromRGB(:, :, 1) = decompressedYfromRGB;
decompressedYCBCRfromRGB(:, :, 2) = decompressedCBfromRGB;
decompressedYCBCRfromRGB(:, :, 3) = decompressedCRfromRGB;

disp('-----------------------------------------------------------------------');

% Statistics
disp(' ');
disp('RMSE of Whole Image');
disp(['YCBCR RMSE from YCBCR compression: ' num2str(calculateRMSE(double(originalYCBCR), double(decompressedYCBCR)))]);
disp(['YCBCR RMSE from RGB compression: ' num2str(calculateRMSE(double(originalYCBCR),double(decompressedYCBCRfromRGB)))]);
disp(['RGB RMSE from RGB compression: ' num2str(calculateRMSE(double(originalRGB), double(decompressedRGB)))]);
disp(['RGB RMSE from YCBCR compression: ' num2str(calculateRMSE(double(originalRGB), double(decompressedRGBfromYCBCR)))]);

disp(' ');
disp('Per layer RMSE');
disp(['RMSE Y (From RGB compression) : ' num2str(calculateRMSE(double(originalY), double(decompressedYfromRGB)))]);
disp(['RMSE Y (From YCBCR compression) : ' num2str(calculateRMSE(double(originalY), double(decompressedY)))]);
disp(['RMSE CB (From RGB compression) : ' num2str(calculateRMSE(double(originalCB), double(decompressedCBfromRGB)))]);
disp(['RMSE CB (From YCBCR compression) : ' num2str(calculateRMSE(double(originalCB), double(decompressedCB)))]);
disp(['RMSE CR (From RGB compression) : ' num2str(calculateRMSE(double(originalCR), double(decompressedCRfromRGB)))]);
disp(['RMSE CR (From YCBCR compression) : ' num2str(calculateRMSE(double(originalCR), double(decompressedCR)))]);

disp(['RMSE R (From RGB compression) : ' num2str(calculateRMSE(double(originalR), double(decompressedR)))]);
disp(['RMSE R (From YCBCR compression) : ' num2str(calculateRMSE(double(originalR), double(decompressedRfromYCBCR)))]);
disp(['RMSE G (From RGB compression) : ' num2str(calculateRMSE(double(originalG), double(decompressedG)))]);
disp(['RMSE G (From YCBCR compression) : ' num2str(calculateRMSE(double(originalG), double(decompressedGfromYCBCR)))]);
disp(['RMSE B (From RGB compression) : ' num2str(calculateRMSE(double(originalB), double(decompressedB)))]);
disp(['RMSE B (From YCBCR compression) : ' num2str(calculateRMSE(double(originalB), double(decompressedBfromYCBCR)))]);

disp('-----------------------------------------------------------------------');


disp(' ');
disp('PSNR of Whole Image');
disp(['YCBCR PSNR from YCBCR compression: ' num2str(calculatePSNR(double(originalYCBCR), double(decompressedYCBCR))) ' dB']);
disp(['YCBCR PSNR from RGB compression: ' num2str(calculatePSNR(double(originalYCBCR), double(decompressedYCBCRfromRGB))) ' dB']);
disp(['RGB PSNR from RGB compression: ' num2str(calculatePSNR(double(originalRGB),double(decompressedRGB))) ' dB']);
disp(['RGB PSNR from YCBCR compression: ' num2str(calculatePSNR(double(originalRGB), double(decompressedRGBfromYCBCR))) ' dB']);

disp(' ');
disp('Per layer PSNR');
disp(['PSNR Y (From RGB compression) : ' num2str(calculatePSNR(double(originalY), double(decompressedYfromRGB))) ' dB']);
disp(['PSNR Y (From YCBCR compression) : ' num2str(calculatePSNR(double(originalY),double(decompressedY))) ' dB']);
disp(['PSNR CB (From RGB compression) : ' num2str(calculatePSNR(double(originalCB), double(decompressedCBfromRGB))) ' dB']);
disp(['PSNR CB (From YCBCR compression) : ' num2str(calculatePSNR(double(originalCB), double(decompressedCB))) ' dB']);
disp(['PSNR CR (From RGB compression) : ' num2str(calculatePSNR(double(originalCR), double(decompressedCRfromRGB))) ' dB']);
disp(['PSNR CR (From YCBCR compression) : ' num2str(calculatePSNR(double(originalCR), double(decompressedCR))) ' dB']);

disp(['PSNR R (From RGB compression) : ' num2str(calculatePSNR(double(originalR), double(decompressedR))) ' dB']);
disp(['PSNR R (From YCBCR compression) : ' num2str(calculatePSNR(double(originalR), double(decompressedRfromYCBCR))) ' dB']);
disp(['PSNR G (From RGB compression) : ' num2str(calculatePSNR(double(originalG), double(decompressedG))) ' dB']);
disp(['PSNR G (From YCBCR compression) : ' num2str(calculatePSNR(double(originalG), double(decompressedGfromYCBCR))) ' dB']);
disp(['PSNR B (From RGB compression) : ' num2str(calculatePSNR(double(originalB), double(decompressedB))) ' dB']);
disp(['PSNR B (From YCBCR compression) : ' num2str(calculatePSNR(double(originalB), double(decompressedBfromYCBCR))) ' dB']);

disp('-----------------------------------------------------------------------');

disp(' ');
disp('Structural similarity of Whole Image');
disp(['YCBCR Structural similarity from YCBCR compression: ' num2str(ssim(originalYCBCR, decompressedYCBCR))]);
disp(['YCBCR Structural similarity from RGB compression: ' num2str(ssim(originalYCBCR, decompressedYCBCRfromRGB))]);
disp(['RGB Structural similarity from RGB compression: ' num2str(ssim(originalRGB, decompressedRGB))]);
disp(['RGB Structural similarity from YCBCR compression: ' num2str(ssim(originalRGB, decompressedRGBfromYCBCR))]);

disp(' ');
disp('Per layer Structural similarity');
disp(['Structural similarity Y (From RGB compression) : ' num2str(ssim(originalY, decompressedYfromRGB))]);
disp(['Structural similarity Y (From YCBCR compression) : ' num2str(ssim(originalY, decompressedY))]);
disp(['Structural similarity CB (From RGB compression) : ' num2str(ssim(originalCB, decompressedCBfromRGB))]);
disp(['Structural similarity CB (From YCBCR compression) : ' num2str(ssim(originalCB, decompressedCB))]);
disp(['Structural similarity CR (From RGB compression) : ' num2str(ssim(originalCR, decompressedCRfromRGB))]);
disp(['Structural similarity CR (From YCBCR compression) : ' num2str(ssim(originalCR, decompressedCR))]);

disp(['Structural similarity R (From RGB compression) : ' num2str(ssim(originalR, decompressedR))]);
disp(['Structural similarity R (From YCBCR compression) : ' num2str(ssim(originalR, decompressedRfromYCBCR))]);
disp(['Structural similarity G (From RGB compression) : ' num2str(ssim(originalG, decompressedG))]);
disp(['Structural similarity G (From YCBCR compression) : ' num2str(ssim(originalG, decompressedGfromYCBCR))]);
disp(['Structural similarity B (From RGB compression) : ' num2str(ssim(originalB, decompressedB))]);
disp(['Structural similarity B (From YCBCR compression) : ' num2str(ssim(originalB, decompressedBfromYCBCR))]);

% Visualization
figure('Name', 'Comparison', 'NumberTitle', 'off');
subplot(2,2,1);imshow(originalRGB);title('Original');
subplot(2,2,2);imshow(decompressedRGB);title('Decompressed (RGB)');
subplot(2,2,3);imshow(decompressedRGBfromYCBCR);title('Decompressed (YCBCR)');

imwrite(decompressedRGB, ['RGBdecompressed_' imagePath]);
imwrite(decompressedRGBfromYCBCR, ['YCBCRdecompressed_' imagePath]);