fprintf('\n');

% Read an example image file
imageFilePath = "C:\Users\axelp\Desktop\SEMESTER 2\CONTINETAL\test_png.png"; % Adjust the path as necessary
img = imread(imageFilePath);

% Convert the image to the encoding expected by Foxglove Studio (e.g., 'rgb8')
img = uint8(img);

% Flatten the image to a 1-D array as required by ROS image message
% Ensure img is in the correct shape [Height x Width x Channels]
imgData = typecast(reshape(permute(img, [3, 2, 1]), 1, []), 'uint8');

% Create a publisher for sending images
[rospub, msg] = rospublisher('test_image', 'foxglove_msgs/RawImage');

% Send image in a loop
while true
    % Assign message fields based on the provided 'foxglove_msgs/RawImage' structure
    msg.Timestamp = rostime('now'); % Set current time
    msg.FrameId = ''; % Set the frame ID to a meaningful value or leave as an empty string
    msg.Width = size(img, 2); % Set the width of the image
    msg.Height = size(img, 1); % Set the height of the image
    msg.Encoding = 'rgb8'; % Set the encoding of the image
    msg.Step = size(img, 2) * size(img, 3); % Set the step size, which is width * number of channels
    msg.Data = imgData; % Assign the flattened image data
    
   % Publish the image message
   send(rospub, msg);
   fprintf('Sent image at time %d.%09d\n', msg.Timestamp.Sec, msg.Timestamp.Nsec);


    pause(1); % Adjust the pause as necessary
    
    % Exit loop condition - include a counter or a condition to exit the infinite loop
end
