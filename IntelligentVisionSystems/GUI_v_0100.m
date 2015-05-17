function varargout = GUI_v_0100(varargin)
    % GUI_V_0100 MATLAB code for GUI_v_0100.fig
    % Begin initialization code.
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @GUI_v_0100_OpeningFcn, ...
                       'gui_OutputFcn',  @GUI_v_0100_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end

% --- Executes just before GUI_v_0100 is made visible.
function GUI_v_0100_OpeningFcn(hObject, eventdata, handles, varargin)
    % Choose default command line output for GUI_v_0100.
    handles.output = hObject;
    % Update handles structure.
    guidata(hObject, handles);
    % Centre the window on the screen.
    movegui('center');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_v_0100_OutputFcn(hObject, eventdata, handles) 
    % Get default command line output from handles structure.
    varargout{1} = handles.output;

% --- Executes on button press in btnLoadImage.
function btnLoadImage_Callback(hObject, eventdata, handles)
    try
        % Open a dialog box to browse for an image.
        imgFileToProcess = uigetfile({'*.jpg'; '*.png'; '*.gif'; '*.bmp'; '*.mp4'; '*.avi'}, 'Select an image file to process'); 
        % If cancel is pressed then keep the image that is already there (if
        % exists).
        if ~isequal(imgFileToProcess, 0)
            % Check what type of file has been loaded to process - image or
            % video.
            [folder, baseFileName, extension] = fileparts(imgFileToProcess);
            if isequal(extension, '.mp4') || isequal(extension, '.avi')
                % If it's a video, run the video function.
                DetectFacesVideo(imgFileToProcess);
            else % If it's not a video.
                % Clear the axes of previous images as smaller images will show
                % larger images behind.
                cla reset;
                % Get handles for static text boxes and their String
                % components.
                get(handles.txtNoFacesDetected, 'String');
                get(handles.txtTimeTaken, 'String');
                % Reset handles
                set(handles.txtNoFacesDetected, 'String', 'Faces detected: ');
                set(handles.txtTimeTaken, 'String', 'Time taken: ');
                handles.I = imread(imgFileToProcess); % Reference to the image file.
                axes(handles.imgDisplay);    % The area to display the image.
                imshow(handles.I);    % Display the image.
                guidata(hObject, handles);
                tStart = tic;   % Start stopwatch.
                noOfFaces = DetectFacesImages(handles.I, handles.imgDisplay);
                tElapsed = toc(tStart);     % Use toc to stop stopwatch and evaluate elapsed time.

                display(noOfFaces);     % Debug: check for noOfFaces return value.
                display(tStart);        % Debug: check for tStart value.
                display(tElapsed);      % Debug: check for tElapsed value.

                % Update the String property of the two text labels
                % below line for testing exception handling.
                set(handles.txtNoFacesDetected, 'String', ['Faces detected: ' num2str(noOfFaces) '.']);
                set(handles.txtTimeTaken, 'String', ['Time taken: ' num2str(tElapsed) ' seconds.']);
                % Get handles for static text boxes and their Visibility components
                get(handles.txtNoFacesDetected, 'Visible');
                get(handles.txtTimeTaken, 'Visible');
                % Set visibility of static text boxes
                set(handles.txtNoFacesDetected, 'Visible', 'On');
                set(handles.txtTimeTaken, 'Visible', 'On');
            end
        end
    catch exception
        % If an exception occured. catch it and show a message box.
        id = exception.identifier;
        message = exception.message;
        errorMsg = [id char(10) message];
        msgbox(errorMsg, 'Error', 'error');
    end

% Face Detection code for images
% - facesDetectedImage: return variable with amount of faces detected
% - Detects faces with a yellow box
% - Detects points on faces with red crosses
function facesDetectedImage = DetectFacesImages(I, handles)
    % If the image is in colour.
    if size(I, 3) == 3
        img = rgb2gray(I); % Convert image to grayscale.
    else
        img = I;
    end
    % this is a well commented line of code
    faceDetector = vision.CascadeObjectDetector; % Create face detection object.
    axes(handles); % Access the axes object where the image is.
    bboxes = step(faceDetector, img); % Detect faces.
    facesDetectedImage = size(bboxes, 1); % Count how many faces are detected.
    if facesDetectedImage > 0
        points = detectMinEigenFeatures(img, 'ROI', bboxes(1, :)); % Run min eigen inside the first bounding box.
        imgP = insertMarker(I, points.Location, '+', 'Color', 'red'); % Insert a red plus for each feature min eigen detected.
        for i = 2: size(bboxes, 1) %Run min eigen on any other bounding boxes.
            points = detectMinEigenFeatures(img, 'ROI', bboxes(i, :));
            imgP = insertMarker(imgP, points.Location, '+', 'Color', 'red'); % Insert a red plus for each feature min eigen detected.
        end
        imshow(imgP); % Show the image.
        hold on
        for i = 1: size(bboxes, 1)
            % Draw yellow boxes around every detected face.
            rectangle('position', bboxes(i, :), 'Linewidth', 2, 'Linestyle', '-', 'Edgecolor', 'y');
        end
    else
        % Run min eigen on the image with any bounding boxes.
        % Get the image size.
        imgSize = size(img);
        % Create a bounding box for the whole image.
        sizeArr = [1 1 (imgSize(2) - 1) (imgSize(1) - 1)];
        % Run min eigen in the bounding box.
        points = detectMinEigenFeatures(img, 'ROI', sizeArr);
        % Insert a red plus for each feature min eigen detected.
        imgP = insertMarker(I, points.Location, '+', 'Color', 'red');
        % Show the image.
        imshow(imgP);
        % Tell the user that no faces were detected.
        msgbox('No faces detected.', 'Face Detection', 'warn');
    end

% Face detection code for video
% - facesDetectedVideo: return variable with amount of frames that a face
% was detected
% - Detects faces in frames with a yellow box
function facesDetectedVideo = DetectFacesVideo(movieFullFileName)
    videoObject = VideoReader(movieFullFileName);
    % Determine how many frames there are.
    numberOfFrames = videoObject.NumberOfFrames;
    % Get the frame rate of the video.
    frameRate = videoObject.FrameRate;
    % Ask the user if they want to save all face detected frames into a
    % video.
    promptMessage = sprintf('Do you want to save a MP4 file with the detected faces?');
    button = questdlg(promptMessage, 'Save video?', 'Yes', 'No', 'Yes');
    writeToDisk = false;
    % Get the folder, the file name and the extension of the video file.
    [folder, baseFileName, extension] = fileparts(movieFullFileName);
    % If the user said yes.
    if strcmp(button, 'Yes')
        % Set boolean value to true.
        writeToDisk = true;
        % Create a new file name based on the original one.
        % test.mp4 > test_face.mp4
        outputBaseFileName = sprintf([baseFileName '_face.mp4']);
        % Place the file name in the folder.
        % E.g. N:/MATLAB/test_face.mp4
        outputFullFileName = fullfile(folder, outputBaseFileName);
        % Create the video writer.
        vidWrite = VideoWriter(outputFullFileName, 'MPEG-4');
        % Set the frame rate of the new video to be the same as the
        % original.
        vidWrite.FrameRate = frameRate;
        % Set video compression to be at 100% quality.
        vidWrite.Quality = 100;
        % Open the video writer.
        open(vidWrite);
        % Display a progress bar.
        h = waitbar(0, 'Saving MP4...');
    end
    % If the user doesn't want to save a video.
    if ~writeToDisk
        display('Opening video...');
        % Read in all the frames of the video into an array.
        frames = read(videoObject);
        display(['Loaded ' num2str(numberOfFrames) ' frames.']);
        % Duplicate the array for grayscale versions of each frame.
        % This is for the face detector which only expects 1 channel
        % images.
        framesGray = frames;
        % If the video is in colour then convert every frame to grayscale and store them in an array.
        if size(frames(:, :, :, 1), 3) == 3
            display('Converting each frame to grayscale...');
            % Loop through all the frames and convert them to grayscale.
            for frame = 1 : numberOfFrames
                framesGray(:, :, 1, frame) = rgb2gray(frames(:, :, :, frame));
            end
            display('Done.');
        end
        % Show the figure.
        figure('name', baseFileName);
        title(baseFileName);
    end
    % Start a timer to find out how long it took to get through the video.
    wStart = tic;
    % Initialise the face detector.
    faceDetector = vision.CascadeObjectDetector;
    detectedFrames = 0;
    % Loop through all the frames of the video.
    for frame = 1 : numberOfFrames
        % If the user wants to save a video.
        if writeToDisk
            % Read in the frame from the video file.
            imgC = read(videoObject, frame);
            % Convert the frame to grayscale.
            % This is for the face detector which only expects 1 channel
            % images.
            img = rgb2gray(imgC);
            % Run the face detector.
            % This will return an array of bounding boxes.
            % E.g. [1, 1, 10, 10] > A box at (1, 1) which is size (10, 10).
            bboxes = step(faceDetector, img);
            if size(bboxes, 1) > 0
                % For every bounding box the face detector gives.
                for i = 1:size(bboxes, 1)
                    % Insert a yellow rectangle around each face.
                    imgC = insertShape(imgC, 'rectangle', bboxes(i, :), 'Color', 'yellow', 'LineWidth', 2, 'SmoothEdges', false);
                end
                detectedFrames = detectedFrames + 1;
            end
            % Write the image to the video being saved.
            writeVideo(vidWrite, imgC);
            % Update progress bar.
            waitbar(frame / numberOfFrames);
            % Clear variables to save memory.
            clear img;
            clear bboxes;
        else
            % Start a timer for measuring frames per second (FPS).
            tStart = tic;
            % Refresh the figure window.
            drawnow;
            % Get the colour frame from the frame array.
            imgC = frames(:, :, :, frame);
            % Get the grayscale frame.
            img = framesGray(:, :, 1, frame);
            % Clear the frames in the arrays to save memory.
            clear frames(:, :, :, frame);
            clear framesGray(:, :, 1, frame);
            % Run the face detector on the grayscale frame.
            bboxes = step(faceDetector, img);
            % If there are any faces detected.
            if size(bboxes, 1) > 0
                % Loop through all the faces.
                for i = 1:size(bboxes, 1)
                    % Insert a yellow rectangle around each face.
                    imgC = insertShape(imgC, 'rectangle', bboxes(i, :), 'Color', 'yellow', 'LineWidth', 2, 'SmoothEdges', false);
                end
                % Show the modified image in the figure.
                imshow(imgC);
                detectedFrames = detectedFrames + 1;
            else
                % Show the unmodified image in the figure.
                imshow(imgC);
            end
            % Stop the timer and get the time elapsed.
            tElapsed = toc(tStart);
            % The timer returns the time elapsed in seconds.
            % Divide 1 by the time elapsed.
            % E.g. 1 / 0.33 = 3 fps.
            fps = 1 / tElapsed;
            % Put the current frame and the FPS in the title of the figure.
            titleS = [num2str(frame) '/' num2str(numberOfFrames) '  FPS: ' num2str(fps)];
            % Update the figure title.
            title(titleS);
            % Clear all the variables to save memory.
            clear imgC;
            clear img;
            clear bboxes;
            clear fps;
            clear titleS;
        end
    end
    % Get the time it took to go through the video.
    wElapsed = toc(wStart);
    % Calculate the percentage of frames that had a detected face in.
    percent = detectedFrames / numberOfFrames;
    if writeToDisk
        % Close the video writer.
        close(vidWrite);
        % Close the progress window.
        close(h);
        % Show a message box saying what file was saved.
        msgbox(['Saving took ' num2str(wElapsed) ' seconds. Video saved as ' outputFullFileName '. ' num2str(percent) '% of frames had a detected face.'], 'Video', 'custom', imgC);
    else
        % Show a message box saying how long the video took and the
        % percentage of frames that had a detected face.
        msgbox(['Video took ' num2str(wElapsed) ' seconds. ' num2str(percent) '% of frames had a detected face.']);
    end
    % Return the percentage of detected faces.
    facesDetectedVideo = detectedFrames / numberOfFrames;
