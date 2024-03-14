--
-- Lua script sample
--
-- @2024 Enchan1207.
--

-- This is setup function. Run once.
function setup()
    size(400, 400)
    fill("#FF0000")
    stroke("#0000")
end

-- 矩形の位置とサイズ
x = 200
y = 200
w = 20
h = 20

-- 移動速度
vx = (math.random() + 1.0) * 2.0
vy = (math.random() + 1.0) * 2.0

-- This is main loop. Run repeatedly.
function draw()
    -- 背景を塗りつぶす
    background("#ccc")

    -- 矩形を描画する
    rect(x - w / 2, y - h / 2, w, h)

    -- 速度に従って移動する ぶつかったら跳ね返る
    x = x + vx
    y = y + vy
    if(x < w / 2 or x > (400.0 - w / 2)) then
        vx = -vx
    end
    if(y < h / 2 or y > (400.0 - h / 2)) then
        vy = -vy
    end
end
