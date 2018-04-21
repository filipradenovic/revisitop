function im = crop_qim(im, bbx)
% CROP_QIM crops query image with defined bounding box.
%
%   IM = crop_qim(IM, BBX)  Crop IM with BBX.
%   

    bbx = uint32(bbx + 1); % gnd bbx is zero-based, matlab is one-based
    im = im(bbx(2):min(bbx(4),size(im,1)), bbx(1):min(bbx(3),size(im,2)), :); 
