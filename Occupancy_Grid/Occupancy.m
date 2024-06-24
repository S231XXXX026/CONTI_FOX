fprintf('\n');

% Create a publisher for the 'nav_msgs/OccupancyGrid' message
occupancyGridPub = rospublisher('/map', 'nav_msgs/OccupancyGrid');

% Define the properties of the grid
gridWidth = 100; % example grid width
gridHeight = 100; % example grid height
resolution = 0.1; % grid resolution in meters per cell

% Create an example occupancy grid with all cells set to 'unknown' (-1)
occupancyData = -1 * ones(gridWidth * gridHeight, 1, 'int8');

% Optionally, you can set some cells to 'occupied' (100) or 'free' (0)
% For example, creating a diagonal line from top-left to bottom-right
for i = 1:min(gridWidth, gridHeight)
    occupancyData((i-1) * gridWidth + i) = 100;
end

% Send occupancy grid in a loop
counter = 0;
while true
    % Create the 'OccupancyGrid' message
    occupancyGridMsg = rosmessage(occupancyGridPub);

    % Set the header with the current time
    occupancyGridMsg.Header.FrameId = 'map'; % Use an appropriate frame ID
    occupancyGridMsg.Header.Stamp = rostime('now');

    % Set the metadata of the occupancy grid
    occupancyGridMsg.Info.Width = gridWidth;
    occupancyGridMsg.Info.Height = gridHeight;
    occupancyGridMsg.Info.Resolution = resolution;
    
    % You may need to set the origin of the grid in the Info.MapLoadTime
    % and Info.Origin fields, depending on your use case.

    % Assign the flattened occupancy data to the Data field
    occupancyGridMsg.Data = occupancyData;
    
    % Publish the occupancy grid message
    send(occupancyGridPub, occupancyGridMsg);
    
    % Print the time the message was sent
    fprintf('Sent occupancy grid at time %d.%09d\n', occupancyGridMsg.Header.Stamp.Sec, occupancyGridMsg.Header.Stamp.Nsec);

    pause(1); % Adjust the pause as necessary
    
    % Increment counter and potentially add an exit condition
    counter = counter + 1;
    if counter >= 1000 % example exit condition
        break;
    end
end