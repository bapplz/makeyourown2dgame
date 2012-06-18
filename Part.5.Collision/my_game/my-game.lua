PADDLE_START_X = 0
PADDLE_START_Y = 400

PADDLE_WIDTH = 40
PADDLE_HEIGHT = 10

BRICK_WIDTH = 40
BRICK_HEIGHT = 10

BALL_START_X = 50
BALL_START_Y = 200

BALL_WIDTH = 16
BALL_HEIGHT = 16

WINDOW_WIDTH = config.sizes[config.device][1]
WINDOW_HEIGHT = config.sizes[config.device][2]

paddle = RNFactory.createImage("my_game/paddle.png")
ball = RNFactory.createImage("my_game/ball.png")

bricks = {}

function positionObject(object, x, y)
	object.x = x
	object.y = y
end

function onTouchEventHandler(event)
	if event.phase == "began" or event.phase == "moved" then
		paddle.x = event.x
	end
end

function initBricks()
	local padding = 10
	local color = 1
	for col = 0, 5, 1 do
		for row = 0, 4, 1 do
			local brick = RNFactory.createImage("my_game/brick" .. color .. ".png")
			brick.row = row
			brick.col = col
			brick.y = 50 + padding + (row * 10 + padding * row)
			brick.x = 25 + padding + (col * 40 + padding * col)
			bricks[string.format("%s%s", row, col)] = brick
		end
		color = color + 1
		if (color > 3) then
			color = 1
		end
	end
end

function initBall()
	positionObject(ball, BALL_START_X, BALL_START_Y)
	direction = round(math.random() * 1)
	ball.speed = 2
	
	if (direction == 1) then
		angle = 45
	else 
		angle = 135
	end
	
	ball.xspeed = ball.speed * math.cos(angle * math.pi / 180)
	ball.yspeed = ball.speed * math.sin(angle * math.pi / 180)
	
end

function round(number)
	if number >= 0 then
		return math.floor(number + .5)
	else
		return math.ceil(number - 0.5)
	end
end

function ballCollidesWithPaddle()
	if (ball.y >= paddle.y - PADDLE_HEIGHT and ball.y <= paddle.y)
		and
		(ball.x >= paddle.x - (PADDLE_WIDTH / 2) and ball.x <= paddle.x + (PADDLE_WIDTH / 2)) then
		return true
	else
		return false
	end
end

function ballCollidesWithBrick()
	for col = 0, 5, 1 do
		for row = 0, 4, 1 do
			local brick = bricks[string.format("%s%s", row, col)]
			if brick ~= nil then
				if(ball.y + (BALL_HEIGHT / 2) >= brick.y - (BRICK_HEIGHT / 2)
					and
					ball.y - (BALL_HEIGHT / 2) <= brick.y + (BRICK_HEIGHT / 2))
					and
					(ball.x + (BALL_WIDTH / 2) >= brick.x - (BRICK_WIDTH / 2)
					and ball.x - (BALL_WIDTH / 2) <= brick.x + (BRICK_WIDTH / 2)) then
						return true, brick
					end
			end
		end
	end
	return false, nil
end

function onUpdateFrameHandler(event)
	ball.x = ball.x + ball.xspeed
	ball.y = ball.y + ball.yspeed
	
	if ball.x <= 5 or ball.x >= WINDOW_WIDTH then
		ball.xspeed = -ball.xspeed
	end
	
	if ball.y <= 5 or ballCollidesWithPaddle() then
		ball.yspeed = -ball.yspeed
	end
	
	local collidesWithBrick, brick = ballCollidesWithBrick()
	if collidesWithBrick then
		bricks[string.format("%s%s", brick.row, brick.col)] = nil
		brick:setAlpha(0)
		ball.yspeed = -ball.yspeed
	end
	
	if ball.y > WINDOW_HEIGHT then
		initBall()
	end
end

function initGame()
	initBall()
	positionObject(paddle, PADDLE_START_X, PADDLE_START_Y)
	initBricks()
	backgroundImage = RNFactory.createImage("my_game/background-blue.png")
	backgroundImage:sendToBottom()
	RNListeners:addEventListener("enterFrame", onUpdateFrameHandler)
	RNListeners:addEventListener("touch", onTouchEventHandler)
end

initGame()

