fprintf('\n');

% Create a publisher for the 'foxglove_msgs/SceneEntity'
sceneEntityPub = rospublisher('/scene_entity', 'foxglove_msgs/SceneEntity');

% Send scene entity in a loop
counter = 0;
while true
    % Create the 'SceneEntity' message
    sceneEntityMsg = rosmessage(sceneEntityPub);

    % Set common properties for SceneEntity
    sceneEntityMsg.Timestamp = rostime('now');
    sceneEntityMsg.Lifetime = rosduration(0, 500000000);  % 0.5 seconds
    sceneEntityMsg.FrameId = 'world';
    sceneEntityMsg.Id = sprintf('entity_%d', counter);
    sceneEntityMsg.FrameLocked = false;

    % Set up a cube primitive
    cubeMsg = rosmessage('foxglove_msgs/CubePrimitive');
    cubeSize = rosmessage('geometry_msgs/Vector3');
    cubeSize.X = 1.0;  % Width of the cube
    cubeSize.Y = 1.0;  % Height of the cube
    cubeSize.Z = 1.0;  % Depth of the cube
    cubeMsg.Size = cubeSize;
    cubeMsg.Color.R = 1.0;  % Red
    cubeMsg.Color.G = 0.0;
    cubeMsg.Color.B = 0.0;
    cubeMsg.Color.A = 1.0;  % Fully opaque
    cubeMsg.Pose.Position.X = 2.0;
    cubeMsg.Pose.Position.Y = 2.0;
    cubeMsg.Pose.Position.Z = 0.5;
    cubeMsg.Pose.Orientation.W = 1.0;  % Neutral orientation
    sceneEntityMsg.Cubes = cubeMsg;

    % Set up a sphere primitive
    sphereMsg = rosmessage('foxglove_msgs/SpherePrimitive');
    sphereMsg.Color.R = 0.0;
    sphereMsg.Color.G = 0.0;
    sphereMsg.Color.B = 1.0;  % Blue
    sphereMsg.Color.A = 1.0;
    % sphereMsg.Radius = 0.5;  % Radius of the sphere
    sphereMsg.Pose.Position.X = -2.0;
    sphereMsg.Pose.Position.Y = -2.0;
    sphereMsg.Pose.Position.Z = 0.5;
    sphereMsg.Pose.Orientation.W = 1.0;
    sceneEntityMsg.Spheres = sphereMsg;

    % Publish the SceneEntity message
    send(sceneEntityPub, sceneEntityMsg);
    fprintf('Sent SceneEntity message at time %d.%09d\n', sceneEntityMsg.Timestamp.Sec, sceneEntityMsg.Timestamp.Nsec);

    pause(1);  % Adjust the pause as necessary
    
    % Increment counter and potentially add an exit condition
    counter = counter + 1;
    if counter >= 1000 % example exit condition
        break;
    end
end
