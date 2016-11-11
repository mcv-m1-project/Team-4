    clear all;
    clc;
    
    [final, maskFiles] = ReadMat();
    dirname='Masks&Mat/Validation Train';
    matFiles = dir(fullfile(dirname,'*.mat')); % Get all .mat files
    mkdir('Hough');
    dirnamemask='Hough';

    for i = 1:length(final)
        %Cargamos las windows Candidates y las imágenes
        file=fullfile(dirname,final{i});
        windows=load(file); %carrega de windowsCandidate
        fileim=fullfile(dirname,maskFiles(i).name);
        im=imread(fileim);
        o=1;
        k=1;
        for j=1:length(windows.windowCandidates)
        SquareTriangle = HoughSquareTriangle(im,windows.windowCandidates(j));
        Circles=HoughCircles(im,windows.windowCandidates(j));
        if SquareTriangle == 1
            windowCandidatesReal(k)=windows.windowCandidates(j);
            k=k+1;
        elseif Circles==1
            windowCandidatesReal(k)=windows.windowCandidates(j);
            k=k+1;
        else
            windowCandidatesReal.x=0;
            windowCandidatesReal.y=0;
            windowCandidatesReal.w=0;
            windowCandidatesReal.h=0;
        end
        end
        
        clear windows
       for k=1:length(windowCandidatesReal)
       windowCandidates(k)=windowCandidatesReal(k);
       end

       %[pathstr_r,name_r,ext_r]=fileparts(maskFiles(i).name);
       %save([dirnamemask,'/',name_r,'.mat'],'windowCandidates');
       clear windowCandidatesReal;
       clear windowCandidates;
                  
    end
