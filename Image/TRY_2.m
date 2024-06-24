% Read an example image file
imageFilePath = "C:\Users\axelp\Desktop\SEMESTER 2\CONTINETAL\test_png.png"; % Adjust the path as necessary
img = imread(imageFilePath);

% Convert the image to the encoding expected by Foxglove Studio (e.g., 'rgb8')
img = uint8(img);

% Flatten the image to a 1-D array as required by ROS image message
% Ensure img is in the correct shape [Height x Width x Channels]
imgData = typecast(reshape(permute(img, [3, 2, 1]), 1, []), 'uint8');

% Create publishers for sending images and camera calibration data
[imgPub, imgMsg] = rospublisher('test_image_1', 'sensor_msgs/Image');
[cameraInfoPub, cameraInfoMsg] = rospublisher('camera_calibration', 'foxglove_msgs/CameraCalibration');

% Configure Camera Calibration message
cameraInfoMsg.FrameId = 'camera_frame';
cameraInfoMsg.Width = size(img, 2);
cameraInfoMsg.Height = size(img, 1);
cameraInfoMsg.DistortionModel = 'plumb_bob';
cameraInfoMsg.D = [0.1, -0.025, 0.0005, 0, 0];  % Distortion coefficients
cameraInfoMsg.K = reshape([1000, 0, 960; 0, 1000, 540; 0, 0, 1]', [1, 9]);
cameraInfoMsg.R = reshape(eye(3)', [1, 9]);
cameraInfoMsg.P = reshape([1000, 0, 960, 0; 0, 1000, 540, 0; 0, 0, 1, 0]', [1, 12]);

% Send image and camera info in a loop
while true
    % Set Header with current time
    currentTime = rostime('now');
    imgMsg.Header.Stamp = currentTime;
    cameraInfoMsg.Timestamp = currentTime;

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

    pause(1); % Adjust the pause as necessary
    % Exit loop condition - include a counter or a condition to exit the infinite loop
end