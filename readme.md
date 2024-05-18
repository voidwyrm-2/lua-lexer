# Lua Lexer
A simple lexer written in Lua

This is mostly for learning purposes, but I also just like lexers

<br>

To run the lexer on a file, download or clone this repo, and run the [run.lua](./run.lua) file

<br>

For example, running the [example.txt](./example.txt) file through the lexer outputs:
```
(IDENT, 'var')
(IDENT, 'x')
(ASSIGN, 'nil')
(STRING, 'Hello, Catdog!')
(IDENT, 'var')
(IDENT, 'y')
(ASSIGN, 'nil')
(NUM, '10')
(IDENT, 'puts')
(IDENT, 'x')
(EOF, 'nil')
```

I do *not* recommend writing a entire language in Lua, as it's a bit cumbersome, but I'm probably just not that experianced with working in Lua

<br><br>


**This Repository is licensed under the MIT license**<br>
(tl;dr, do whatever the heck you want with the code)