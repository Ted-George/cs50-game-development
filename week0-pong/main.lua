WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200


push = require 'push'




function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    largefont = love.graphics.newFont('font.ttf', 32)
    smallfont = love.graphics.newFont('font.ttf', 8)
    player1Score = 0
    player2Score = 0

    player1Y = 10
    player2Y = VIRTUAL_HEIGHT - 30

    ballX =VIRTUAL_WIDTH / 2 - 2
    ballY =VIRTUAL_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and 60 or -60
    ballDY = math.random(-30, 30)

    gameState = 'start'

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false,
    })
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true,
    })
    
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        else
            gameState = 'start'
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2
            ballDX = math.random(2) == 1 and 60 or -60
            ballDY = math.random(-30, 30)
        end

    end
end

function love.update(dt)
    --player1 controls (keyboard)
    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end
    --AI for player2(keyboard)
    if ballX > VIRTUAL_WIDTH / 2 then
        if ballY < player2Y  then
            player2Y = math.max(0, player2Y + -PADDLE_SPEED * 0.5 * dt)
          elseif ballY > player2Y + 20 then
             player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * 0.5 * dt)
        end
    end

    if gameState == 'play' then
        --ball movement
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt

        --Ball bouncing off top and bottom walls
        if ballY <= 0 then
            ballY = 0
            ballDY = -ballDY
        end
        if ballY >= VIRTUAL_HEIGHT - 4 then
            ballY = VIRTUAL_HEIGHT - 4
            ballDY = -ballDY
        end
        
        --ballbouncing off player 1 paddle
        if ballX <= 15 and ballX >= 10 and ballY + 4 >= player1Y and ballY <= player1Y + 20 then
            ballX = 15
            ballDX = -ballDX * 1.03
            ballDY = math.random(-50, 50)
        end

        --ball bouncing off player 2 paddle
        if ballX >= VIRTUAL_WIDTH - 19 and ballX <= VIRTUAL_WIDTH - 15 and ballY + 4 >= player2Y and ballY <= player2Y + 20 then
            ballX = VIRTUAL_WIDTH - 19
            ballDX = -ballDX * 1.03
            ballDY = math.random(-50, 50)
        end

        --scoring
        if ballX < 0 then
            player2Score = player2Score + 1
            gameState = 'start'
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end

        if ballX > VIRTUAL_WIDTH then
            player1Score = player1Score + 1
            gameState = 'start'
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50)
        end
    end
end


function love.draw()
    push:apply('start')
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    love.graphics.setFont(largefont)
    love.graphics.print(tostring(player1Score),VIRTUAL_WIDTH / 2 - 50,  VIRTUAL_HEIGHT / 2 - 80)
    love.graphics.print(tostring(player2Score),VIRTUAL_WIDTH / 2 + 30,  VIRTUAL_HEIGHT / 2 - 80)
    -- paddle 1
    love.graphics.rectangle('fill', 10, player1Y, 5, 20 )

    -- paddle 2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, 5, 20)

    --ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    push:apply('end')
end