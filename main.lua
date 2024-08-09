local car = {}
local obstacles = {}
local road = {}
local speed = 200
local obstacleSpeed = 300
local obstacleSpawnTime = 2
local obstacleTimer = 0
local gameWidth = 800
local gameHeight = 600

function love.load()
    love.window.setMode(gameWidth, gameHeight)

    car.width = 50
    car.height = 100
    car.x = (gameWidth / 2) - (car.width / 2)
    car.y = gameHeight - car.height - 50

    road.width = gameWidth
    road.height = gameHeight
    road.y1 = 0
    road.y2 = -road.height
end

function love.update(dt)
    if love.keyboard.isDown("left") then
        car.x = car.x - speed * dt
        if car.x < 0 then car.x = 0 end
    elseif love.keyboard.isDown("right") then
        car.x = car.x + speed * dt
        if car.x + car.width > gameWidth then car.x = gameWidth - car.width end
    end

    road.y1 = road.y1 + speed * dt
    road.y2 = road.y2 + speed * dt
    if road.y1 >= gameHeight then
        road.y1 = -road.height
    end
    if road.y2 >= gameHeight then
        road.y2 = -road.height
    end

    obstacleTimer = obstacleTimer + dt
    if obstacleTimer >= obstacleSpawnTime then
        spawnObstacle()
        obstacleTimer = 0
    end

    for i, obstacle in ipairs(obstacles) do
        obstacle.y = obstacle.y + obstacleSpeed * dt
        if obstacle.y > gameHeight then
            table.remove(obstacles, i)
        end

        if checkCollision(car, obstacle) then
            love.load()
        end
    end
end

function love.draw()
    love.graphics.setColor(0.2, 0.6, 0.2)
    love.graphics.rectangle("fill", 0, road.y1, road.width, road.height)
    love.graphics.rectangle("fill", 0, road.y2, road.width, road.height)

    love.graphics.setColor(0.9, 0.1, 0.1)
    love.graphics.rectangle("fill", car.x, car.y, car.width, car.height)

    love.graphics.setColor(0.1, 0.1, 0.9)
    for _, obstacle in ipairs(obstacles) do
        love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.width, obstacle.height)
    end
end

function spawnObstacle()
    local obstacle = {}
    obstacle.width = 50
    obstacle.height = 100
    obstacle.x = math.random(0, gameWidth - obstacle.width)
    obstacle.y = -obstacle.height
    table.insert(obstacles, obstacle)
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end
