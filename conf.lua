WINDOW_W = 320
WINDOW_H = 240
CONSOLE = os.getenv("CONSOLE") == "true"

function love.conf(t)
    t.window.resizable = true
    t.console = CONSOLE
    t.window.width = WINDOW_W*2
    t.window.height = WINDOW_H*2
end