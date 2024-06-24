% Path to the MP4 video file
videoFilePath = 'C:\Users\axelp\Desktop\SEMESTER 2\CONTINETAL\Messages_to_test\Image\SKY\5 Second Video Watch the Milky Way Rise.mp4';

% Folder path to store the JPEG images
jpegFolderPath = 'C:\Users\axelp\Desktop\SEMESTER 2\CONTINETAL\Messages_to_test\Image\SKY\FRAMES';

% Create a video reader object
vidReader = VideoReader(videoFilePath);

% Check if the folder exists, if not, create it
if ~exist(jpegFolderPath, 'dir')
    mkdir(jpegFolderPath);
end

% Read and save each frame as a JPEG
frameNumber = 0;
while hasFrame(vidReader)
    frame = readFrame(vidReader);
    frameNumber = frameNumber + 1;
    jpegFilePath = fullfile(jpegFolderPath, sprintf('frame_%04d.jpg', frameNumber));
    imwrite(frame, jpegFilePath);
end

fprintf('All frames have been extracted and saved.\n');