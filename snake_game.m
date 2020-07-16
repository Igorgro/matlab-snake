clc; clear; close all force;

global dir_up;
dir_up = [0 1];
global dir_right;
dir_right = [1 0];
global dir_down;
dir_down = [0 -1];
global dir_left;
dir_left = [-1 0];

global xmax;
xmax = 18;
global ymax;
ymax = 15;

global current_dir;
current_dir = dir_right;

global game_state;
game_state = 0;
global food;

f = figure(1);
hold on;
snake = createSnake();

food = createFood();
xlim([0 xmax]);
ylim ([0 ymax]);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'XColor', 'none','YColor','none')
set(f,'KeyPressFcn', @onkeyboard);

while game_state == 0
    snake = game_step(snake);
    pause(0.1);
end
if game_state == 2
    msgbox('Game Over!');
else
    close all;
end    


function snake = createSnake()
    snake = [];
    for i = 1:5
        snake = [snake plot(3+i, 5, '.', 'MarkerSize', 30, 'Color', '#77AC30')];
    end
end
function food = createFood()
    food = plot(randi([1 9]), randi([1 9]), '.', 'MarkerSize', 30, 'Color', '#A2142F');
end
function food = reCreateFood(snake)
    global food;
    global xmax;
    global ymax;
    food.XData = randi([1 xmax-1]);
    food.YData = randi([1 ymax-1]);
    % generate food again if it has generated inside snake
    while inSnake(food.XData, food.YData, snake, 0) == 1
        food.XData = randi([1 xmax-1]);
        food.YData = randi([1 ymax-1]);
    end
end

function new_snake = game_step(snake)
    global current_dir;
    global game_state;
    global food;
    global xmax;
    global ymax;
    if snake(end).XData+current_dir(1) == food.XData & snake(end).YData+current_dir(2) == food.YData %check if food in the fron of snake head
        item = plot(snake(end).XData+current_dir(1), snake(end).YData+current_dir(2), '.', 'MarkerSize', 30, 'Color', '#77AC30');
        snake = [snake item];
        reCreateFood(snake);
    else
        % check if snake will intersect itself
        flag = inSnake(snake(end).XData + current_dir(1), snake(end).YData + current_dir(2), snake, 2);
        if flag == 0
            % move snake
            for i = 1:(length(snake)-1)
               snake(i).XData = snake(i+1).XData;
               snake(i).YData = snake(i+1).YData;
            end
            snake(end).XData = snake(end).XData + current_dir(1);
            snake(end).YData = snake(end).YData + current_dir(2);
            if snake(end).XData == 0 | snake(end).XData == xmax | snake(end).YData == 0 | snake(end).YData == ymax
                game_state = 2;
            end
        else
            game_state = 2;
        end
    end
    new_snake = snake;
end

% check if coordinates belongs to snake, except k elements from head
function res = inSnake(x, y, snake, k)
    res = 0;
    for i = 1:(length(snake)-k)
       if x == snake(i).XData & y == snake(i).YData
           res = 1;
           break;
       end
    end
end

function onkeyboard(src, event)
    global dir_up;
    global dir_right;
    global dir_down;
    global dir_left;
    global current_dir;
    global game_state
    switch (event.Key)
        case 'uparrow'
            if current_dir ~= dir_down
                current_dir = dir_up;
            end
        case 'rightarrow'
            if current_dir ~= dir_left
                current_dir = dir_right;
            end
        case 'downarrow'
            if current_dir ~= dir_up
                current_dir = dir_down;
            end
        case 'leftarrow'
            if current_dir ~= dir_right
                current_dir = dir_left;
            end
        otherwise
            game_state = 1;
    end
end



