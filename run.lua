require('lua_lexer')


---@param file_name string
---@return nil | string
function ReadFile(file_name)
    local file = io.open(file_name, "r")  -- Open file in read mode
    if file then
        local content = file:read("*all") -- Read all content
        io.close(file)                    -- Close the file
        return content
    else
        return nil -- File not found
    end
end

---@param text string
---@param showTokens boolean?
function RunLuaScript(text, showTokens)
    if showTokens == nil then
        showTokens = false
    end
    local aLexer = NewLexer(text)

    Tokens = aLexer:Tokenize()

    if showTokens then
        for _, t in pairs(Tokens) do
            if IsToken(t, TT_ILLEGAL) then
                ShowError(t['val']['errtype'], t['val']['errdetails'], t['val']['errln'], t['val']['errcol'])
            else
                print("(" .. t['type'] .. ", '" .. tostring(t['val']) .. "')")
            end
        end
    end
end

function Main()
    print("Simple Terminal Interface")
    print("Type 'quit' to exit.")
    print("Type 'run <file>' to run a file.")

    while true do
        io.write("> ")            -- Prompt for input
        local command = io.read() -- Read user input
        if command == "quit" then
            print("Exiting program...")
            break
        elseif command:sub(1, 4) == "run " then
            local file_name = command:sub(5) -- Extract file name
            local content = ReadFile(file_name)
            if content then
                RunLuaScript(content, true)
            else
                print("File '" .. file_name .. "' not found.")
            end
        else
            print("Command not recognized.")
        end
    end
end

Main()
