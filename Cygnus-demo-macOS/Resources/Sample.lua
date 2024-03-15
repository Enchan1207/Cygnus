--
-- Lua script sample
--
-- @2024 Enchan1207.
--

-- This is setup function. Run once.
function setup()
    size(400, 400)
end

-- This is main loop. Run repeatedly.
function draw()
    --Fill background
    background("#222")
    
    -- Get current time
    local currentTime = os.date("*t")
    local hour = currentTime.hour
    local minute = currentTime.min
    local second = currentTime.sec
    
    -- Convert time to angle
    local secondAngle = second * 6.0
    local minuteAngle = minute * 6.0 + second / 10.0
    local hourAngle = hour * 30.0 + minute / 2.0
    
    -- Draw frame
    drawClockFrame()
    
    -- Draw time text
    drawTimeInfo()
    
    -- Draw second hand
    drawHand(3, "#A00", secondAngle, 150)
    
    -- Draw minute hand
    drawHand(5, "#DDD", minuteAngle, 100)
    
    -- Draw hour hand
    drawHand(7, "#EEE", hourAngle, 80)
end

-- Draw time information text
function drawTimeInfo()
    local currentDateString = os.date("%Y/%m/%d")
    local currentTimeString = os.date("%H:%M:%S")
    stroke("#666")
    textSize(30)
    textAlign("center")
    text(200, 130, currentDateString)
    text(200, 270, currentTimeString)
end

-- Draw clock hand
function drawHand(weight, color, angle, length)
    saveTransform()
    strokeWeight(weight)
    stroke(color)
    translate(200, 200)
    rotate(math.rad(angle - 180))
    line(0, length, 0, -20)
    restoreTransform()
end

-- Draw clock frame
function drawClockFrame()
    -- Draw outer frame
    strokeWeight(5)
    stroke("#CCC")
    ellipse(20, 20, 360, 360)
    strokeWeight(2)
    stroke("#DDD")
    ellipse(30, 30, 340, 340)
    
    -- Draw dial
    for angle = 0, 359, 30 do
        -- Modify style each dial line
        local lineWeight = 4
        local lineColor = "#AAA"
        local lineLength = 20
        
        if angle % 90 == 0 then
            lineWeight = 5
            lineColor = "#EEE"
            lineLength = 30
        end
        
        -- Switch transformation and draw one dial line
        saveTransform()
        strokeWeight(lineWeight)
        stroke(lineColor)
        translate(200, 200)
        rotate(math.rad(angle - 90))
        translate(0, 160 - lineLength)
        line(0, 0, 0, lineLength)
        restoreTransform()
    end

end
