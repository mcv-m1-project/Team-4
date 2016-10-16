function createValidationMask(struct, dirname, dirname_new, pixel_method)
    % createMask
    % Generate a mask for RGB, HSV & LAB space and and save each mask in a new directory
    %
    %    Parameter name      Value
    %    --------------      -----
    %    'struct'           Matrix struct of A, B, C, D, E or F type
    %    'dirname'          Current directory of each struct signl type
    %    'dirname_new'      New directory to copy the new split array
    
    dirname_new = ['validation_split/mask/' dirname_new];
    [s, mess, messid] = mkdir(dirname_new);
    j = ( length(struct) - round(0.3*length(struct)) ) + 1;

    for i = j:length(struct)
        toSplit = strsplit(struct{i}.name,{'gt.','.txt'}); %struct{i}.name
        im = imread(fullfile(dirname, strjoin([toSplit(2) '.jpg'],'')));
        switch pixel_method

            case 'RGB'
            im_R = im(:,:,1); % channel red
            im_G = im(:,:,2); % channel green
            im_B = im(:,:,3); % channel blue

            % Otsu's Method: 
            thresh_R = multithresh(im_R,2);
            thresh_G = multithresh(im_G,2); 
            thresh_B = multithresh(im_B,2); 

            % RGB space
            red1 = (im_R > thresh_R(1)) & (im_B < thresh_G(1)) & (im_G < thresh_B(1)); % red mask
            blue1 = (im_R < thresh_R(1)) & (im_B < thresh_G(1)) & (im_G > thresh_B(1)); % blue mask

            mask_rgb = red1 | blue1; 

            imwrite(mask_rgb, strjoin([dirname_new '/mask.' toSplit(2) '.RGB.png'],''));

         case 'HSV'
            % HSV space 
            im_hsv = rgb2hsv(im);
            im_H = im_hsv(:,:,1);
            im_S = im_hsv(:,:,2);
            im_V = im_hsv(:,:,3);

            red_H = [0.092 0.877];
            red_S = [0.604 1];
            red_V = [0.15 0.9];
            red2 = (im_H <= red_H(1) | im_H >= red_H(2)) & (im_S >= red_S(1) & im_S <= red_S(2)) & (im_V >= red_V(1) & im_V <= red_V(2));

            blue_H = [0.501 0.791];
            blue_S = [0.5 1];
            blue_V = [0.15 0.9];
            blue2 = (im_H >= blue_H(1) & im_H <= blue_H(2)) & (im_S >= blue_S(1) & im_S <= blue_S(2)) & (im_V >= blue_V(1) & im_V <= blue_V(2));

            mask_hsv = red2 | blue2;

            imwrite(mask_hsv, strjoin([dirname_new '/mask.' toSplit(2) '.HSV.png'],''));

        case 'Lab'
            % L lightness (luminance) (darkest black = 0 and brightest white at 100)
            % a (red positive values and  green negative values) (-128 a 128)
            % b (yellow positive values and blue negative values) (-128 a 128)
            
            %Lab space
            im_lab = rgb2lab(im);
            im_L = im_lab(:,:,1);
            im_a = im_lab(:,:,2);
            im_b = im_lab(:,:,3);

            red_L = [5 50]; % 47
            red_a = [7 36]; % 68
            red_b = [0 25]; % 48
            red3 = (im_L >= red_L(1) & im_L <= red_L(2)) & (im_a >= red_a(1) & im_a <= red_a(2)) & (im_b >= red_b(1) & im_b <= red_b(2));

            blue_L = [0 70]; %  24
            blue_a = [0 65]; %  17
            blue_b = [-90 -20]; % -46
            blue3 = (im_L >= blue_L(1) & im_L <= blue_L(2)) & (im_a >= blue_a(1) & im_a <= blue_a(2)) & (im_b >= blue_b(1) & im_b <= blue_b(2));

            mask_lab = red3 | blue3;

            imwrite(mask_lab, strjoin([dirname_new '/mask.' toSplit(2) '.LAB.png'],''));
        end   
    end
end