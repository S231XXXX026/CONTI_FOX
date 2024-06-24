fprintf('\n');

% Create a publisher for the 'visualization_msgs/Marker'
markerPub = rospublisher('/visualization_marker', 'visualization_msgs/Marker');

% Constants for marker types
MESH_RESOURCE = 10;  % Typically, the enumeration value for MESH_RESOURCE is 10

% Send marker in a loop
counter = 0;
while true
    % Create the 'Marker' message
    markerMsg = rosmessage(markerPub);

    % Common settings for Marker
    markerMsg.Header.FrameId = 'world';  % use an appropriate frame ID
    markerMsg.Header.Stamp = rostime('now');
    markerMsg.Ns = 'my_namespace';
    markerMsg.Id = counter;
    markerMsg.Type = MESH_RESOURCE;  % Use the constant for MESH_RESOURCE
    markerMsg.Action = markerMsg.ADD;
    markerMsg.Pose.Position.X = 0.0;
    markerMsg.Pose.Position.Y = 0.0;
    markerMsg.Pose.Position.Z = 0.0;
    markerMsg.Pose.Orientation.W = 1.0;  % Neutral orientation
    markerMsg.Scale.X = 1.0;  % Adjust scale if necessary
    markerMsg.Scale.Y = 1.0;
    markerMsg.Scale.Z = 1.0;
    markerMsg.Color.A = 1.0;  % Fully opaque
    markerMsg.Color.R = 1.0;  % Full red
    markerMsg.Color.G = 0.0;
    markerMsg.Color.B = 0.0;

    % Path to the 3D model file, this must be accessible from where your ROS environment runs
    markerMsg.MeshResource = 'file:///C:\Users\axelp\Desktop\SEMESTER 2\CONTINETAL\Messages_to_test\Ros_markers\uploads_files_2787791_Mercedes+Benz+GLS+580.obj';
    markerMsg.MeshUseEmbeddedMaterials = true;

    % Publish the Marker message
    send(markerPub, markerMsg);
    fprintf('Sent marker message at time %d.%09d\n', markerMsg.Header.Stamp.Sec, markerMsg.Header.Stamp.Nsec);

    pause(1); % Adjust the pause as necessary
    
    % Increment counter and potentially add an exit condition
    counter = counter + 1;
    if counter >= 1000 % example exit condition
        break;
    end
end
