local car = {}
local obstacles = {}
local laneWidth = 150
local laneCount = 3
local gameWidth = laneWidth * laneCount
local gameHeight = 600
local speed = 200
local obstacleSpeed = 300
local obstacleSpawnTime = 2
local obstacleTimer = 0
local score = 0
local gameOver = false
local backgroundLines = {}
local backgroundSpeed = 400

function love.load()
    love.window.setMode(gameWidth, gameHeight)
    
    car.width = 50
    car.height = 100
    car.lane = 2
    car.x = (car.lane - 1) * laneWidth + (laneWidth / 2) - (car.width / 2)
    car.y = gameHeight - car.height - 50

    for i = 1, 10 do
        table.insert(backgroundLines, { y = (i - 1) * 100 })
    end
end

function love.update(dt)
    if not gameOver then
        handleInput()
        moveBackground(dt)
        spawnAndMoveObstacles(dt)
        checkCollisions()
        increaseDifficulty(dt)
    elseif love.keyboard.isDown("r") then
        restartGame()
    end
end

function love.draw()
    drawBackground()
    
    if gameOver then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("GAME OVER", 0, gameHeight / 2 - 50, gameWidth, "center")
        love.graphics.printf("Press 'R' to Restart", 0, gameHeight / 2, gameWidth, "center")
        love.graphics.printf("Score: " .. score, 0, gameHeight / 2 + 50, gameWidth, "center")
    else
        love.graphics.setColor(0.9, 0.1, 0.1)
        love.graphics.rectangle("fill", car.x, car.y, car.width, car.height)
        
        love.graphics.setColor(0.1, 0.1, 0.9)
        for _, obstacle in ipairs(obstacles) do
            love.graphics.rectangle("fill", obstacle.x, obstacle.y, obstacle.width, obstacle.height)
        end

        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: " .. score, 10, 10)
    end
end

function handleInput()
    if love.keyboard.isDown("left") then
        car.lane = math.max(1, car.lane - 1)
        car.x = (car.lane - 1) * laneWidth + (laneWidth / 2) - (car.width / 2)
    elseif love.keyboard.isDown("right") then
        car.lane = math.min(laneCount, car.lane + 1)
        car.x = (car.lane - 1) * laneWidth + (laneWidth / 2) - (car.width / 2)
    end
end

function moveBackground(dt)
    for _, line in ipairs(backgroundLines) do
        line.y = line.y + backgroundSpeed * dt
        if line.y > gameHeight then
            line.y = -100
        end
    end
end

function drawBackground()
    love.graphics.setColor(0.2, 0.2, 0.2)
    love.graphics.rectangle("fill", 0, 0, gameWidth, gameHeight)

    love.graphics.setColor(1, 1, 1)
    for _, line in ipairs(backgroundLines) do
        love.graphics.rectangle("fill", gameWidth / 2 - 5, line.y, 10, 50)
    end
end

function spawnAndMoveObstacles(dt)
    obstacleTimer = obstacleTimer + dt
    if obstacleTimer >= obstacleSpawnTime then
        spawnObstacle()
        obstacleTimer = 0
    end

    for i, obstacle in ipairs(obstacles) do
        obstacle.y = obstacle.y + obstacleSpeed * dt
        if obstacle.y > gameHeight then
            table.remove(obstacles, i)
            score = score + 1
        end
    end
end

function spawnObstacle()
    local obstacle = {}
    obstacle.width = laneWidth - 20
    obstacle.height = 100
    obstacle.lane = math.random(1, laneCount)
    obstacle.x = (obstacle.lane - 1) * laneWidth + (laneWidth / 2) - (obstacle.width / 2)
    obstacle.y = -obstacle.height
    table.insert(obstacles, obstacle)
end

function checkCollisions()
    for _, obstacle in ipairs(obstacles) do
        if checkCollision(car, obstacle) then
            gameOver = true
        end
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

function increaseDifficulty(dt)
    obstacleSpeed = obstacleSpeed + 10 * dt
    backgroundSpeed = backgroundSpeed + 10 * dt
end

function restartGame()
    car.lane = 2
    car.x = (car.lane - 1) * laneWidth + (laneWidth / 2) - (car.width / 2)
    obstacles = {}
    obstacleSpeed = 300
    backgroundSpeed = 400
    score = 0
    gameOver = false
end
