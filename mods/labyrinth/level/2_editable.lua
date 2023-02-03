function draw()
    for y=1,3 do
        for x=2,8 do
            place(x,y,5,"glass")
        end
    end
end

function check()
    local cnt = 0
    for x=2,8 do
        for y=1,3 do
            for z=2,8 do
                if get(x,y,z) == "glass" then
                    cnt = cnt + 1
                end
            end
        end
    end
    assert(cnt == 21)
end