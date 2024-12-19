'----------------------------------------------------------------
'   TITLE: File Input and Output
'   AUTHOR: n00b
'   DATE: Dec 13, 2024
'
'   DESCRIPTION: File I/O Example
'----------------------------------------------------------------

'Open a file and write it
f = OpenFile("test.txt", TEXT_OUTPUT_PLUS)

WriteLine(f, "Hello World")
WriteLine(f, "This is line 2")

'Its important to close files once you are done
CloseFile(f)

'Read From the file and output it to the screen
f = OpenFile("test.txt", TEXT_INPUT)

s$ = ""

i = 1 'We will use this to keep track of the line number

'Read each line until the end of file is reached
While Not EOF(f)
	s$ = ReadLine(f)
	Print "Line #";i;" = ";s$
Wend

CloseFile(f)
