PADDLE_START_X = 0
PADDLE_START_Y = 400

BALL_START_X = 50
BALL_START_Y = 200

paddle = RNFactory.createImage("my_game/paddle.png")
ball = RNFactory.createImage("my_game/ball.png")



function positionObject(object, x, y)
	object.x = x
	object.y = y
end

function onTouchEventHandler(event)
	if event.phase == "began" or event.phase == "moved" then
		paddle.x = event.x
	end
end

function initGame()
	positionObject(ball, BALL_START_X, BALL_START_Y)
	positionObject(paddle, PADDLE_START_X, PADDLE_START_Y)
	backgroundImage = RNFactory.createImage("my_game/background-blue.png")
	backgroundImage:sendToBottom()
	RNListeners:addEventListener("touch", onTouchEventHandler)
end

initGame()

