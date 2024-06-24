% Read an example image file
imageFilePath = "C:\Users\axelp\Desktop\SEMESTER 2\CONTINETAL\test_png.png"; % Adjust the path as necessary
img = imread(imageFilePath);

% Convert the image to the encoding expected by Foxglove Studio (e.g., 'rgb8')
img = uint8(img);

% Flatten the image to a 1-D array as required by ROS image message
% Ensure img is in the correct shape [Height x Width x Channels]
imgData = typecast(reshape(permute(img, [3, 2, 1]), 1, []), 'uint8');

% Create a publisher for sending images
[imgPub, imgMsg] = rospublisher('test_image_1', 'sensor_msgs/Image');
[cameraInfoPub, cameraInfoMsg] = rospublisher('camera_info', 'sensor_msgs/CameraInfo');

% Send image in a loop
while true
    % Set Header with current time
    if isempty(imgMsg.Header)
        imgMsg.Header = rosmessage('std_msgs/Header');
    end
    imgMsg.Header.Stamp = rostime('now'); % Set current time
    
    % Image message fields
    imgMsg.Width = size(img, 2); % Set the width of the image
    imgMsg.Height = size(img, 1); % Set the height of the image
    imgMsg.Encoding = 'rgb8'; % Set the encoding of the image
    imgMsg.Step = size(img, 2) * size(img, 3); % Set the step size, which is width * number of channels
    imgMsg.Data = imgData; % Assign the flattened image data
    
% CameraInfo message fields
cameraInfoMsg.Header = imgMsg.Header; % Synchronize headers for consistent timestamps
cameraInfoMsg.Height = imgMsg.Height;
cameraInfoMsg.Width = imgMsg.Width;
cameraInfoMsg.DistortionModel = 'plumb_bob'; % Common distortion model

% Example distortion coefficients (assuming minimal distortion)
cameraInfoMsg.D = zeros(5, 1); 

% Setting focal lengths for both axes
focal_length = 1024; % Preset or calculated focal length based on your camera's specs
optical_center_x = cameraInfoMsg.Width / 2; % Assume the optical center is at the center of the image
optical_center_y = cameraInfoMsg.Height / 2;

% Configuring the intrinsic camera matrix K
cameraInfoMsg.K = [focal_length, 0, optical_center_x;
                  0, focal_length, optical_center_y;
                  0, 0, 1]; % This matrix includes non-zero focal lengths for both x and y axes

% Rectification matrix (usually the identity matrix if no rectification is applied)
cameraInfoMsg.R = eye(3); 

% Projection matrix P (can be derived from K if no additional parameters are used)
cameraInfoMsg.P = [focal_length, 0, optical_center_x, 0;
                   0, focal_length, optical_center_y, 0;
                   0, 0, 1, 0]; 

cameraInfoMsg.BinningX = 0; % Set if using binning, otherwise leave as 0
cameraInfoMsg.BinningY = 0;

    
    % Publish the image and camera info messages
    send(imgPub, imgMsg);
    send(cameraInfoPub, cameraInfoMsg);
    fprintf('Sent image and camera info at time %d.%09d\n', imgMsg.Header.Stamp.Sec, imgMsg.Header.Stamp.Nsec);

    pause(1); % Adjust the pause as necessary
    
    % Exit loop condition - include a counter or a condition to exit the infinite loop
end