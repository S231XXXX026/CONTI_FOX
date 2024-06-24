fprintf('\n');

% Create a publisher for the 'sensor_msgs/PointCloud2'
pcPub = rospublisher('/point_cloud', 'sensor_msgs/PointCloud2');

% Create the 'PointCloud2' message
pcMsg = rosmessage(pcPub);

% Define the properties of the point cloud
numPoints = 100;  % number of points in the point cloud
data = rand(numPoints, 10); % random x, y, z coordinates and intensity (4th dimension)
data(:, 10) = data(:, 10) * 100; % scale intensity for better visibility

% Configure PointCloud2 message fields
pcMsg.Header.FrameId = 'map'; % use an appropriate frame ID
pcMsg.Header.Stamp = rostime('now');
pcMsg.Height = 1; % Point cloud is unordered
pcMsg.Width = numPoints;

% Set the point format fields
pcMsg.PointStep = 16; % Each point takes 16 bytes: 3 floats for XYZ, 1 float for intensity
pcMsg.RowStep = pcMsg.PointStep * numPoints;

% Convert data to row-major format
pcData = data';
pcData = typecast(pcData(:), 'uint8');

% Fill the data
pcMsg.Data = pcData;

% Fields setup
fieldNames = {'x', 'y', 'z', 'intensity'};
offsets = [0, 4, 8, 12]; % Offsets for each field in bytes
dataTypes = [7, 7, 7, 7]; % 7 corresponds to FLOAT32 in ROS
count = [1, 1, 1, 1]; % one of each per point

% Configure fields
for i = 1:length(fieldNames)
    field = rosmessage('sensor_msgs/PointField');
    field.Name = fieldNames{i};
    field.Offset = offsets(i);
    field.Datatype = dataTypes(i);
    field.Count = count(i);
    pcMsg.Fields(i) = field;
end

% Send point cloud in a loop
counter = 0;
while true
    % Update timestamp each iteration
    pcMsg.Header.Stamp = rostime('now');
    
    % Publish the point cloud message
    send(pcPub, pcMsg);
    fprintf('Sent point cloud at time %d.%09d\n', pcMsg.Header.Stamp.Sec, pcMsg.Header.Stamp.Nsec);

    pause(1); % Adjust the pause as necessary
    
    % Increment counter and potentially add an exit condition
    counter = counter + 1;
    if counter >= 1000 % example exit condition
        break;
    end
end