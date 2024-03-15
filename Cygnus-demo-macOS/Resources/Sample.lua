--
-- Lua script sample
--
-- @2024 Enchan1207.
--

-- 矩形の位置とサイズ
x = 200
y = 200
w = 20
h = 20

-- 移動速度
vx = 0
vy = 0

-- This is setup function. Run once.
function setup()
    size(400, 400)
    fill("#FF0000")
    stroke("#0000")

    -- 移動速度の設定
    vx = getInitialVelocity()
    vy = getInitialVelocity()
end

-- This is main loop. Run repeatedly.
function draw()
    -- 背景を塗りつぶす
    background("#444")

    -- 円を描画する
    ellipse(x - w / 2, y - h / 2, w, h)

    -- 速度に従って移動する ぶつかったら跳ね返る
    x = x + vx
    y = y + vy
    if(x < w / 2 or x > (width - w / 2)) then
        vx = -vx
    end
    if(y < h / 2 or y > (height - h / 2)) then
        vy = -vy
    end
end

-- 初期速度を生成する
function getInitialVelocity()
    -- -1.0 ~ +1.0
    local base = (math.random() - 0.5) * 2.0

    if base > 0 then
        base = base + 0.5
    else
        base = base - 0.5
    end
    return base
end
