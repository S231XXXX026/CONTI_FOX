fprintf('\n');

% Create a publisher for the 'geometry_msgs/PolygonStamped' message
polygonPub = rospublisher('/polygon', 'geometry_msgs/PolygonStamped');

% Define a simple square polygon as an example
squareVertices = [0 0; 1 0; 1 1; 0 1]; % 4 vertices (x, y) of a square

% Send polygon in a loop
counter = 0;
while true
    % Create the 'PolygonStamped' message
    polygonMsg = rosmessage(polygonPub);

    % Assign the frame ID and current time to the header
    polygonMsg.Header.FrameId = 'map'; % Use an appropriate frame ID
    polygonMsg.Header.Stamp = rostime('now');

    % Assign the vertices to the polygon message
    for i = 1:size(squareVertices, 1)
        pointMsg = rosmessage('geometry_msgs/Point32');
        pointMsg.X = squareVertices(i, 1);
        pointMsg.Y = squareVertices(i, 2);
        pointMsg.Z = 0; % Assuming a flat polygon on the ground plane

        % Append the point to the Polygon message
        polygonMsg.Polygon.Points(i) = pointMsg;
    end

    % Publish the polygon message
    send(polygonPub, polygonMsg);
    fprintf('Sent polygon message at time %d.%09d\n', polygonMsg.Header.Stamp.Sec, polygonMsg.Header.Stamp.Nsec);

    pause(1); % Adjust the pause as necessary
    
    % Increment counter and potentially add an exit condition
    counter = counter + 1;
    if counter >= 1000 % example exit condition
        break;
    end
end