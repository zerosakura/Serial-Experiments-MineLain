function draw()
    for y=1,3 do
        for x=2,8 do
            place(x,y,5,"glass")
        end
    end
end

--Modifying this code will results in the error
--修改该段代码将导致错误
--{
function verify()
    return check("glass", 21, function (a, b)
            return a == b
    end)
end
--}