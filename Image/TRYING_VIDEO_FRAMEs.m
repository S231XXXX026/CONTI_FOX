% Directory containing the images
imageDirPath = "C:\Users\axelp\Desktop\SEMESTER 2\CONTINETAL\Messages_to_test\Image\SKY\FRAMES"; % Adjust the path as necessary

% List all JPEG files in the directory (adjust the file type if needed)
imageFiles = dir(fullfile(imageDirPath, '*.jpg')); % List JPEG files; change the pattern for different file types

% Create publishers for sending images and camera calibration data
[imgPub, imgMsg] = rospublisher('test_image_1', 'sensor_msgs/Image');
[cameraInfoPub, cameraInfoMsg] = rospublisher('camera_calibration', 'sensor_msgs/CameraInfo');

% Assuming the first image to set up camera info (adjust if the images vary in size)
exampleImage = imread(fullfile(imageFiles(1).folder, imageFiles(1).name));

% Configure Camera Calibration message
cameraInfoMsg.Height = size(exampleImage, 1);
cameraInfoMsg.Width = size(exampleImage, 2);
cameraInfoMsg.DistortionModel = 'plumb_bob';
cameraInfoMsg.D = [0.1, -0.025, 0.0005, 0, 0];  % Distortion coefficients
cameraInfoMsg.K = reshape([1000, 0, size(exampleImage,2)/2; 0, 1000, size(exampleImage,1)/2; 0, 0, 1]', [1, 9]);
cameraInfoMsg.R = reshape(eye(3)', [1, 9]);
cameraInfoMsg.P = reshape([1000, 0, size(exampleImage,2)/2, 0; 0, 1000, size(exampleImage,1)/2, 0; 0, 0, 1, 0]', [1, 12]);

% Set Header properties for camera info
cameraInfoMsg.Header.FrameId = 'camera_frame';

% Send each image and camera info in a loop
for idx = 1:length(imageFiles)
    % Read an image from the folder
    imgFilePath = fullfile(imageFiles(idx).folder, imageFiles(idx).name);
    img = imread(imgFilePath);

    % Convert the image to the encoding expected by Foxglove Studio (e.g., 'rgb8')
    img = uint8(img);  % Ensure img is in the correct format

    % Flatten the image to a 1-D array as required by ROS image message
    imgData = typecast(reshape(permute(img, [3, 2, 1]), 1, []), 'uint8');

    % Set Header with current time for both image and camera info
    currentTime = rostime('now');
    imgMsg.Header.Stamp = currentTime;
    imgMsg.Header.FrameId = 'camera_frame';
    cameraInfoMsg.Header.Stamp = currentTime;

    % Image message fields
    imgMsg.Width = size(img, 2);
    imgMsg.Height = size(img, 1);
    imgMsg.Encoding = 'rgb8';
    imgMsg.Step = size(img, 2) * size(img, 3);
    imgMsg.Data = imgData;

    % Publish the image and camera info messages
    send(imgPub, imgMsg);
    send(cameraInfoPub, cameraInfoMsg);
    fprintf('Sent image and camera info at time %d.%09d\n', imgMsg.Header.Stamp.Sec, imgMsg.Header.Stamp.Nsec);

    pause(0.033); % Adjust the pause as necessary (30fps)
    % Optionally add exit condition to break the loop after all images are sent
    if idx == length(imageFiles)
        break;
    end
end