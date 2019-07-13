% Test Script for functions
clc;

% Setting the threshold
rmseThreshold = 5;
disp(['Used threshold: ' num2str(rmseThreshold)]);

% Setting the image
imagePath = 'lena512.bmp';

disp(['Results for image: ' imagePath]);

disp('-----------------------------------------------------------------------');

% Loading the image
disp(' ');
OriginalGray = imread(imagePath);

disp('Image loaded');

disp('-----------------------------------------------------------------------');

% Compression
disp(' ');
disp('Compressing from Gray.....');
startTime = rem(now, 1);
[compressedLayersFromGray, sizeInBits] = compressLayers190707Gray(OriginalGray, rmseThreshold);
endTime = rem(now, 1);
disp(['Elapsed time in seconds = ' num2str((endTime - startTime) * 24 * 60 * 60)]);
disp(['Size in bits: ' num2str(sizeInBits)]);
% disp(['Original Size on disk in bits: ' num2str(dir(imagePath).bytes * 8)]);
disp(['Uncompressed size in bits: ' num2str(prod(size(OriginalGray)) * 8)]);
disp(['Compression Ratio (100 * compressed/uncompressed %): ' num2str(100 * sizeInBits/(prod(size(OriginalGray)) * 8)) '%']);

disp('-----------------------------------------------------------------------');

% Decompression
disp(' ');
disp('Decompression from Gray...');
startTime = rem(now, 1);
decompressedGray = decompressLayers190707Gray(compressedLayersFromGray);
endTime = rem(now, 1);
disp(['Elapsed time in seconds = ' num2str((endTime - startTime) * 24 * 60 * 60)]);

disp('-----------------------------------------------------------------------');

% Statistics
disp(' ');
disp(['RMSE of Whole Image: ' num2str(calculateRMSE(double(OriginalGray), double(decompressedGray)))]);
disp(' ');
disp('-----------------------------------------------------------------------');


disp(' ');
disp(['PSNR of Whole Image: ' num2str(calculatePSNR(double(OriginalGray), double(decompressedGray))) ' dB']);
disp(' ');
disp('-----------------------------------------------------------------------');

disp(' ');
disp(['Structural similarity of Whole Image: ' num2str(ssim(double(OriginalGray), double(decompressedGray)))]);
disp(' ');

% Visualization
figure('Name', 'Comparison', 'NumberTitle', 'off');
subplot(1,2,1);imshow(OriginalGray);title('Original');
subplot(1,2,2);imshow(decompressedGray);title('Decompressed (RGB)');
imwrite(decompressedGray, ['Graydecompressed_' imagePath]);
