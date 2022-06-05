{
    S2 CL final project, Life
    
    pos:
        (-1, -1), (0, -1), (1, -1)
        (-1, 0), (0, 0), (1, 0)
        (-1, 1), (0, 1), (1, 1)
    
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
{
     __       __   _______  _______ 
    |  |     |  | |   ____||   ____|
    |  |     |  | |  |__   |  |__   
    |  |     |  | |   __|  |   __|  
    |  `----.|  | |  |     |  |____ 
    |_______||__| |__|     |_______|
                                
}
program life;
uses crt;

{setting the size of the simulation}
const length = 40; height = 20;  {length and height must be an integer that is < 255}

type cellStructure = array[0..height + 1, 0..length + 1] of char;

{dont use confusing variable names, tell others what your variable is doing}
{eg. nb, rno, cont in the given code}
var	ratio : integer;
    count : word;
	picker, nearby : byte;
	i, j : byte;    x, y : shortint;{for the for loops}
	oldcell, newcell : cellStructure;
	continue, isManual, isAlive : char;

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
            if old[i ,j] = new[i, j] then
                isSame := false;
end;

procedure showGeneration(count : byte);
var temp : byte;
begin
    temp := count mod 10;
    if temp = 1 then
        writeln(count, 'st generation')
    else if temp = 2 then
        writeln(count, 'nd generation')
    else if temp = 3 then
        writeln(count, 'rd generation')
    else
        writeln(count, 'th generation');
end;

procedure printPattern(cell : cellStructure);
begin
	write('|');
    for i := 1 to length do
        write('-');
    writeln('|');
	for i := 1 to height do
	begin
	    write('|');
        textcolor(lightblue);
		for j := 1 to length do
			write(cell[i, j]);
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
	continue := 'Y';
	count := 1;
	textcolor(white);
	textmode(CO80); {refer to reference}
	
	{introduce the game to user}
	writeln('            __       __   _______  _______');
	writeln('           |  |     |  | |   ____||   ____|');
	writeln('           |  |     |  | |  |__   |  |');
	writeln('           |  |     |  | |   __|  |   __|');
	writeln('           |  `----.|  | |  |     |  |____');
	writeln('           |_______||__| |__|     |_______|');
	writeln;
	writeln;
	writeln('The Game of Life, also known simply as Life, is a cellular automaton devised by the British mathematician John Horton Conway in 1970. The "game" is a zero-player game, meaning that its evolution is determined by its initial state, requiring no further input.');
    writeln('------------------------------------------------------');
	
	{setting all the elements to be space}
	for i := 0 to height+1 do
		for j := 0 to length+1 do
			newcell[i, j] := ' ';
	
	{EXTRA: ask for generating randomly or entering themselves}
	write('Enter Y if you want to enter the seeds manually: ');
	readln(isManual);

    {EXTRA: human entering the seeds himself with validation}
	if (isManual = 'y') or (isManual = 'Y') then
	begin
	    writeln('Enter X if you want the cell to be alive, while enter O if you want it to be dead.');
	    for i := 1 to height do
	        for j := 1 to length do
	        begin
	            write('Cell[', i, ' ,', j, ']: ');
	            readln(isAlive);
	            
	            {validation}
	            while (isAlive <> 'X') and (isAlive <> 'x') and (isAlive <> 'O') and (isAlive <> 'o') do
	            begin
	                write('You did not enter a valid letter, enter again: ');
	                readln(isAlive);
	            end;
	            
	            {determine}
	            if (isAlive = 'x') or (isAlive = 'X') then
	                newcell[i, j] := 'X'
	            else
	                newcell[i, j] := ' ';
	        end;
	end
	else
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
        
        {randomly generate 'X' based on given ratio}
    	for i := 1 to height do
    		for j := 1 to length do
    		begin
    			picker := random(100);
    			if picker < ratio then
    				newcell[i, j] := 'X'
    	    end;
	end;

    {main loop}
	while (continue <> 'N') and (continue <> 'n') do
	begin
	    clrscr;
		{EXTRA: telling user how many generations have pasted}
		showGeneration(count);
        
        {EXTRA: remind user if newcell is empty}
        if isEmpty(newcell) then
            writeln('Reminder: all cells are dead, type N to leave the program')
        else if (count > 1) and isSame(oldcell, newcell) then
            writeln('Reminder: this generation is the same as the previous one');
        
	    {printing the pattern of newcell (EXTRA: with borders)}
		printPattern(newcell);
		
		{transferring newcell to oldcell}
		for i := 1 to height do
		    for j := 1 to length do
		        oldcell[i, j] := newcell[i, j];
		
		{missing code}
		{DONE: generating new generation}
		for i := 1 to height do
		begin
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
			    if (oldcell[i, j] = 'X') and (nearby < 2) then
			        newcell[i, j] := ' '
			    {DONE: check rule 3}
			    else if (oldcell[i, j] = 'X') and (nearby > 3) then
			        newcell[i, j] := ' '
			    {DONE: check rule 4}
			    else if (oldcell[i, j] = ' ') and (nearby = 3) then
			        newcell[i, j] := 'X'
			    {DONE: final case: rule 2}
			    else
			        newcell[i, j] := oldcell[i, j];
			end;
        end;
            
        inc(count);
		write('Continue (Y/N)? ');
		readln(continue);
	end;
	writeln;
	writeln('program ended');
end.
