% Clear the workspace and command window
clc;
clear;

% Define initial parameters
robot_pos = [0,0]; % Initial robot position (x, y)
robot_orientation = 0; % Initial orientation of the robot
target = [8, 8]; % Target position (x, y)
obstacles = [2 2; 4 5; 6 3]; % Obstacles positions (x, y)

% Step 1: Load the FIS (replace with your saved FIS file name)
fis = readfis('ObstacleAvoidanceFIS');

% Simulation parameters
dt = 0.1; % Time step for simulation
maxSteps = 200; % Maximum number of simulation steps

% Main simulation loop
for step = 1:maxSteps
% Calculate the distance to the closest obstacle
distances = vecnorm(obstacles - robot_pos, 2, 2); % Euclidean distance to each obstacle
[min_distance, idx] = min(distances); % Closest obstacle distance and index

% Calculate the distances for front, left, and right (example calculation, adjust based on your setup)
distanceFront = min_distance; % Front distance (for simplicity, using the closest obstacle as front)
distanceLeft = distances(1); % Distance to the left (example)
distanceRight = distances(2); % Distance to the right (example)

% Step 2: Define the input data
inputData = [distanceFront, distanceLeft, distanceRight];
% Step 3: Run the FIS to get outputs (left and right wheel velocities)
output = evalfis(fis, inputData);
leftWheelVelocity = output(1);
rightWheelVelocity = output(2);
% Step 4: Update robot orientation and position based on left/right velocities
angular_velocity = (rightWheelVelocity - leftWheelVelocity) / 2; % Example calculation
linear_velocity = (rightWheelVelocity + leftWheelVelocity) / 2; % Example calculation

% Update robot orientation and position
robot_orientation = robot_orientation + angular_velocity * dt; % Update orientation
robot_pos = robot_pos + linear_velocity * [cos(robot_orientation), sin(robot_orientation)] * dt; % Update position

% Update robot orientation and position
robot_orientation = robot_orientation + angular_velocity * dt; % Update orientation
robot_pos = robot_pos + linear_velocity * [cos(robot_orientation), sin(robot_orientation)] * dt; % Update position
% Plot environment
clf;
hold on;
grid on;
plot(obstacles(:,1), obstacles(:,2), 'ks', 'MarkerSize', 10, 'DisplayName', 'Obstacles', 'MarkerFaceColor', 'k'); % Obstacles
plot(target(1), target(2), 'gx', 'MarkerSize', 15, 'DisplayName', 'Target', 'LineWidth', 2); % Target
plot(robot_pos(1), robot_pos(2), 'bo', 'MarkerSize', 8, 'DisplayName', 'Robot', 'LineWidth', 2); % Robot
xlim([-5 10]);
ylim([-5 10]);
xlabel('x (m)');
ylabel('y (m)');
legend();
pause(0.05);

% Check if robot reached the target
if norm(robot_pos - target) < 0.2
disp('Target reached!');
break;
end
end

disp('Simulation complete.');
