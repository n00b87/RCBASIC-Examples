'Open a file and write it
f = FreeFile
FileOpen(f, "test.txt", TEXT_OUTPUT_PLUS)
WriteLine(f, "Hello World\n")
WriteLine(f, "This is line 2")
FileClose(f)

'Read From the file and output it to the screen
f = FreeFile
FileOpen(f, "test.txt", TEXT_INPUT)

s$ = ""

i = 1 'We will use this to keep track of the line number

'Read each line until the end of file is reached
While Not EOF(f)
	s$ = ReadLine(f)
	Print "Line #";i;" = ";s$
Wend

FileClose(f)
