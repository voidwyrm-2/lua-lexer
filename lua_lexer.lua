-- TT
TT_STRING = "STRING"
TT_IDENT = "IDENT"
TT_NUM = 'NUM'
TT_ADD = 'ADD'
TT_SUB = 'SUB'
TT_MUL = 'MUL'
TT_DIV = 'DIV'
--TT_SEMICOLON = 'SEMICOLON'
TT_KEYWORD = 'KEYWORD'
TT_ASSIGN = 'ASSIGN'
TT_ILLEGAL = 'ILLEGAL'
TT_EOF = 'EOF'

---@param errtype string
---@param errdetails string
---@param ln integer?
---@param col integer?
function ShowError(errtype, errdetails, ln, col)
    local err = errtype .. ': ' .. errdetails
    if ln ~= nil then
        err = err .. ' on line ' .. tostring(ln)

        if col ~= nil then
            err = err .. ', col ' .. tostring(col)
        end
    end
    print(err)
end

---comment
---@param t string
---@param details string
---@param ln integer
---@param col integer
---@return table
function NewError(t, details, ln, col)
    return {
        ['errtype'] = t,
        ['errdetails'] = details,
        ['errln'] = ln,
        ['errcol'] = col
    }
end

---@param tok table
---@param t string?
---@param v any?
---@return boolean
function IsToken(tok, t, v)
    if t == nil and v == nil then
        return type(tok) == table
    elseif v == nil then
        return tok['type'] == t
    elseif t == nil then
        return tok['val'] == v
    end
    return tok['type'] == t and tok['val'] == v
end

function PrintTokens(toks)
    print('{')
    for _, t in pairs(toks) do
        print('(' .. t['type'] .. ', ' .. t['val'] .. ')')
    end
    print('}')
end

---@param t string
---@param value any?
---@return table
function NewToken(t, value)
    --[[
    if value == nil then
        value = ''
    end
    ]]
    return {
        ['type'] = t,
        ['val'] = value
    }
end

---@class Lexer
Lexer = {
    ['text'] = '',
    ['idx'] = 0,
    ['ln'] = 1,
    ['col'] = 1,
    ['c'] = ''
}

---@param l Lexer
function Lexer.Advance(l)
    l['idx'] = l['idx'] + 1
    local i = l['idx']
    if i > #l['text'] then
        l['c'] = nil
    else
        l['c'] = l['text']:sub(i, i)
    end

    if l['c'] == '\n' then
        l['ln'] = l['ln'] + 1
        l['col'] = 1
    else
        l['col'] = l['col'] + 1
    end
end

---@param l Lexer
---@return table
function Lexer.Tokenize(l)
    local tokens = {}

    while l['c'] ~= nil do
        local c = l['c']
        if IsDigit(c) then
            tokens[#tokens + 1] = NewToken(TT_NUM, l:GetNum())
        elseif ValidForIdent(c) then
            tokens[#tokens + 1] = NewToken(TT_IDENT, l:GetIdent())
        elseif c == '"' then
            tokens[#tokens + 1] = NewToken(TT_STRING, l:GetString())
        elseif c == '=' then
            tokens[#tokens + 1] = NewToken(TT_ASSIGN)
            l:Advance()
        elseif c == '+' then
            tokens[#tokens + 1] = NewToken(TT_ADD)
            l:Advance()
        elseif c == '-' then
            tokens[#tokens + 1] = NewToken(TT_SUB)
            l:Advance()
        elseif c == '*' then
            tokens[#tokens + 1] = NewToken(TT_MUL)
            l:Advance()
        elseif c == '/' then
            tokens[#tokens + 1] = NewToken(TT_DIV)
            l:Advance()
        else
            if c ~= '\n' and c ~= '\t' and c ~= ' ' then
                tokens[#tokens + 1] = NewToken(TT_ILLEGAL,
                    NewError('InvalidCharacterError', "invalid character '" .. c .. "'", l['ln'], l['col']))
            end
            l:Advance()
        end
    end

    tokens[#tokens + 1] = NewToken(TT_EOF)
    return tokens
end

---@param l Lexer
---@return string
function Lexer.GetString(l)
    l:Advance()
    local string_str = ''
    while l['c'] ~= nil and l['c'] ~= '"' do
        string_str = string_str .. l['c']
        l:Advance()
    end

    l:Advance()
    return string_str
end

---@param l Lexer
---@return string
function Lexer.GetIdent(l)
    local ident_str = ''
    while l['c'] ~= nil and ValidForIdent(l['c']) do
        ident_str = ident_str .. l['c']
        l:Advance()
    end

    return ident_str
end

---@param l Lexer
---@return string
function Lexer.GetNum(l)
    local num_str = ''
    local dot = false
    while l['c'] ~= nil and IsDigit(l['c']) or l['c'] == '.' do
        if l['c'] == '_' then
            if dot then
                break
            end
            dot = true
        end
        num_str = num_str .. l['c']
        l:Advance()
    end

    return num_str
end

function IsDigit(char)
    return string.byte(char) >= string.byte('0') and string.byte(char) <= string.byte('9')
end

function ValidForIdent(char)
    return (string.byte(char) >= string.byte('a') and string.byte(char) <= string.byte('z')) or
        (string.byte(char) >= string.byte('A') and string.byte(char) <= string.byte('Z')) or char == '_'
end

---@param text string
---@return Lexer
function NewLexer(text)
    local nLexer = Lexer
    nLexer['text'] = text
    nLexer:Advance()
    return nLexer
end
