{
    S2 CL final project, Game of Life
    
    generation rule:
        1. Any live cell with <2 live cells -> dies (change to ' ')
        2. Any live cell with 2/3 live cells -> nothing happens
        3. Any live cell with >3 live cells -> dies (change to ' ')
        4. Any dead cell with 3 live cells -> come back to life (change to 'X')
        
    reference:
        colours: https://www.freepascal.org/docs-html/rtl/crt/index-2.html
        textmode: https://www.freepascal.org/docs-html/rtl/crt/textmode.html
        
    range of data types:
        shortint: -128 .. 127
        integer: -32768 .. 32767
        byte: 0 .. 255
        word: 0 .. 65535
}
{$mode objfpc}
program life;
uses crt;

{setting the size of the simulation}
const length = 40; height = 20;  {length and height must be an integer that is < 255}
  delay_ms = 50; {time interval between each generation, in millisecond}

type cellStructure = array[0..height + 1, 0..length + 1] of char;

{dont use confusing variable names, tell others what your variable is doing}
{eg. nb, rno, cont in the given code}
var count : Uint16;
picker, nearby : byte;
i, j : byte;    x, y : shortint;{for the for loops}
oldcell, newcell : cellStructure;
isManual, isAlive : char;

function isEmpty(var cell : cellStructure) : boolean;
begin
    isEmpty := true;
    for i := 1 to height do
        for j := 1 to length do
            if cell[i, j] = 'X' then
                isEmpty := false;
end;

function isSame(var old, new : cellStructure) : boolean;
begin
    isSame := true;
    for i := 1 to height do
        for j := 1 to length do
            if old[i ,j] <> new[i, j] then
                isSame := false;
end;

procedure randomlyGenerate(var cell : cellStructure; begin_height : byte = 1; begin_length : byte = 1);
var picker : byte;
    ratio : integer;
begin
    {ask for ratio}
    write('Enter the initial percentage of living cells (0-100) : ');
    readln(ratio);
    
    {DONE: validation of user input}
    while (ratio < 0) or (ratio > 100) do
    begin
        write('Invalid input, enter again: ');
        readln(ratio);
    end;
    
    for i := begin_height to height do
    	for j := begin_length to length do
    	begin
    		picker := random(100);
    		if picker < ratio then
    			cell[i, j] := 'X';
    	end;
end;

procedure showGeneration(count : byte);
var temp : byte;
begin
    temp := count mod 10;
    {exceptional case: 11th and 12th}
    if count = 11 then
    begin
        writeln('11th generation');
        exit;
    end;
    if count = 12 then
    begin
        writeln('12th generation');
        exit;
    end;
    
    case temp of
        1: writeln(count, 'st generation');
        2: writeln(count, 'nd generation');
        3: writeln(count, 'rd generation');
    else
        writeln(count, 'th generation');
    end;
end;

procedure printPattern(var cell : cellStructure);
begin
    write('|');
    for i := 1 to length do
        write('-');
    writeln('|');
    for i := 1 to height do
    begin
        write('|');
        for j := 1 to length do
        begin
            if cell[i, j] = 'X' then
                textcolor(lightblue)
            else if cell[i, j] = 'o' then
                textcolor(yellow);
            write(cell[i, j]);
        end;
        textcolor(white);
        writeln('│');
    end;
    write('|');
    for i := 1 to length do
        write('-');
    writeln('|');
end;

{main program}
begin
    {initialize the program}
    randomize;
    count := 1;
    textcolor(white);
    textmode(CO80); {refer to reference}
    
    {setting all the elements to be space}
    for i := 0 to height+1 do
        for j := 0 to length+1 do
            newcell[i, j] := ' ';
    
    {introduce the game to user}
    writeln('            __       __   _______  _______');
    writeln('           |  |     |  | |   ____||   ____|');
    writeln('           |  |     |  | |  |__   |  |');
    writeln('           |  |     |  | |   __|  |   __|');
    writeln('           |  `----.|  | |  |     |  |____');
    writeln('           |_______||__| |__|     |_______|');
    writeln;
    writeln;
    writeln('The Game of Life, also known simply as Life, is a cellular automation devised by the British mathematician John Horton Conway in 1970. The "game" is a zero-player game, meaning that its evolution is determined by its initial state, requiring no further input.');
    writeln('------------------------------------------------------');
    
    
    {EXTRA: ask for generating randomly or entering themselves}
    write('Enter Y to enter the seeds manually, enter N to automatically generate the seed:');
    readln(isManual);
    
    {EXTRA: validate isManual}
    while (isManual <> 'y') and (isManual <> 'Y') and (isManual <> 'n') and (isManual <> 'N') do
    begin
        write('Invalid input! Enter again: ');
        readln(isManual);
    end;
    
    clrscr;
    {EXTRA: human entering the seeds himself with validation}
    if (isManual = 'y') or (isManual = 'Y') then
    begin
        writeln('Enter X for alive cell, enter O for dead cell.');
        writeln('Enter R if you want to randomly generate for the rest of the cells');
        for i := 1 to height do
            for j := 1 to length do
            begin
                write('Cell[', i, ' ,', j, ']: ');
                readln(isAlive);
                
                {validation}
                while (isAlive <> 'X') and (isAlive <> 'x') and (isAlive <> 'O') and (isAlive <> 'o') and (isAlive <> 'R') and (isAlive <> 'r') do
                begin
                    write('You did not enter a valid option, enter again: ');
                    readln(isAlive);
                end;
                
                {determine}
                if (isAlive = 'x') or (isAlive = 'X') then
                    newcell[i, j] := 'X'
                else if (isAlive = 'o') or (isAlive = 'O') then
                    newcell[i, j] := ' '
                else
                    randomlyGenerate(newcell, i, j);
            end;
    end
    else
        {randomly generate 'X' based on the ratio asked inside the procedure}
        randomlyGenerate(newcell);

    {main loop}
    while not keypressed do
    begin
        clrscr;
        
        {EXTRA: telling user how many generations have pasted}
        showGeneration(count);
        
        {EXTRA: remind user if newcell is empty}
        if isEmpty(newcell) then
            write('Reminder: all cells are dead, ')
        {EXTRA: remind user if there are no change between 2 generations}
        else if (count > 1) and isSame(oldcell, newcell) then
            write('Reminder: this generation is the same as the previous one, ');
        
        {giving instrctions on how to stop}
        writeln('press any key to stop');
        
        {printing the pattern of newcell (EXTRA: with borders)}
        printPattern(newcell);
        
        {transferring newcell to oldcell}
        for i := 1 to height do
            for j := 1 to length do
            begin
                oldcell[i, j] := newcell[i, j];
                if oldcell[i, j] = 'o' then
                    oldcell[i, j] := ' ';
            end;
    	
        {missing code}
        {DONE: generating new generation}
        for i := 1 to height do
            for j := 1 to length do
            begin
                {DONE: check nearby live cell amount}
                nearby := 0;
                for x := -1 to 1 do
                    for y := -1 to 1 do
                    begin
                        {skip the original cell itself so that it wont be counted}
                        if (i + x = i) and (j + y = j) then 
                            system.Continue;
                        if oldcell[i + x, j + y] = 'X' then
                            inc(nearby);
                    end;

                {DONE: check rule 1}
                if ((oldcell[i, j] = 'X') or (oldcell[i, j] = 'o')) and (nearby < 2) then
                    newcell[i, j] := 'o'
                {DONE: check rule 3}
                else if ((oldcell[i, j] = 'X') or (oldcell[i, j] = 'o')) and (nearby > 3) then
                    newcell[i, j] := 'o'
                {DONE: check rule 4}
                else if (oldcell[i, j] = ' ') and (nearby = 3) then
                    newcell[i, j] := 'X'
                {DONE: final case: rule 2}
                else
                    newcell[i, j] := oldcell[i, j];
            end;
        
        inc(count);
        delay(delay_ms);
    end;
    writeln;
    writeln('program ended');
end.
