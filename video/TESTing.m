% Path to the video file
videoFilePath = 'C:\\Users\\axelp\\Desktop\\SEMESTER 2\\CONTINETAL\\Messages_to_test\\video\\5 Second Video Watch the Milky Way Rise.mp4';

% Create a video reader
vidReader = VideoReader(videoFilePath);

% Create a publisher for the 'foxglove_msgs/CompressedVideo'
videoPub = rospublisher('/compressed_video', 'foxglove_msgs/CompressedVideo');

% Define a temporary file path for the JPEG frame
tempJpegFilePath = 'C:\\Users\\axelp\\Desktop\\SEMESTER 2\\CONTINETAL\\Messages_to_test\\video\\temp_frame.jpg';

% Read and publish each frame in a loop
while hasFrame(vidReader)
    % Read one frame from the video
    frame = readFrame(vidReader);
    
    % Write the frame to a JPEG file
    imwrite(frame, tempJpegFilePath, 'jpg');

    % Read the JPEG file back into a byte array
    fileID = fopen(tempJpegFilePath, 'r');
    if fileID == -1
        error('Cannot open JPEG file for reading.');
    end
    frameJPG = fread(fileID, 'uint8')';
    fclose(fileID);

    % Create the 'CompressedVideo' message
    videoMsg = rosmessage(videoPub);
    
    % Set properties for CompressedVideo
    videoMsg.Timestamp = rostime('now');
    videoMsg.FrameId = 'camera_link';  % Use an appropriate frame ID
    videoMsg.Data = frameJPG;
    videoMsg.Format = 'jpeg';  % Indicate the format of the compression

    % Publish the CompressedVideo message
    send(videoPub, videoMsg);
    
    fprintf('Sent video frame at time %d.%09d\n', videoMsg.Timestamp.Sec, videoMsg.Timestamp.Nsec);

    % Pause slightly to simulate real-time video streaming
    pause(1/vidReader.FrameRate);  % Pause based on the frame rate of the video
end

% Clean up
clear vidReader;
delete(tempJpegFilePath);  % Remove temporary file after use