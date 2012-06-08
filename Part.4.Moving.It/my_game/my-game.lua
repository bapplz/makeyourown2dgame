PADDLE_START_X = 0
PADDLE_START_Y = 400

BALL_START_X = 50
BALL_START_Y = 200

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
		angle = 135
	else 
		angle = 45
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

function onUpdateFrameHandler(event)
	ball.x = ball.x + ball.xspeed
	ball.y = ball.y + ball.yspeed
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

