'---------------------------------------------------------
'Gui Demo
'by n00b on rcbasic forums
'@n00b on rcbasic.freeforums.net
'
'This demo uses the gui library written in RCBasic by n00b
'
'Press Esc to exit.

'This was coded in RCBasic
'http://www.rcbasic.com

'--------------------------------------------------------  

Include "gui.bas" 'include the gui library

win = Gui_WindowOpen("Test Gui", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480) 'open a window

'example_panel1 (tab 1)
example_button = Gui_CreateButton("Test Button", 100, 20) 'Create a button
example_checkbox = Gui_CreateCheckBox(16,16) 'Create a Checkbox
example_panel1 = Gui_CreatePanel(300, 300) 'Create a panel
Gui_Panel_AddObject(example_panel1, example_checkbox, 20, 20) 'Add checkbox to panel at (x = 20, y = 20)
Gui_Panel_AddObject(example_panel1, example_button, 20, 100) 'Add button to panel at (x = 20, y = 100)
Gui_Window_AddPanel(win, example_panel1, 150, 70) 'Add panel to window at (x = 150, y = 50)

'example_panel2 (tab 2)
example_dropdown = Gui_CreateDropDown(200, 32)
Gui_DropDown_AddItem(example_dropdown, "Item #1")
Gui_DropDown_AddItem(example_dropdown, "Item #2")
Gui_DropDown_AddItem(example_dropdown, "Item #3")
Gui_DropDown_AddItem(example_dropdown, "Item #4")
example_panel2 = Gui_CreatePanel(300, 300)
Gui_Panel_AddObject(example_panel2, example_dropdown, 20, 20)
Gui_Window_AddPanel(win, example_panel2, 150, 70)

'Tabs
tab_group = Gui_CreateTabGroup(600, 32)

tab1 = Gui_TabGroup_AddTab(tab_group, "Tab 1")
tab2 = Gui_TabGroup_AddTab(tab_group, "Tab 2")
tab3 = Gui_TabGroup_AddTab(tab_group, "Tab 3")

Gui_TabGroup_Tab_AddObject(tab_group, tab1, example_panel1)
Gui_TabGroup_Tab_AddObject(tab_group, tab2, example_panel2)

Gui_Window_AddTabGroup(win, tab_group, 20, 20)

While (Not Key(K_ESCAPE)) And WindowExists(win)
	'Check for Events
	If Gui_Button_Clicked(example_button) Then
		win2 = Gui_WindowOpen("TEST 2", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480)
		Gui_SetWindowActive(win2)
		example_panel3 = Gui_CreatePanel(640, 480) 'Create a panel
		Print "Panel Created"
		Gui_Window_AddPanel(win2, example_panel3, 0, 0)
		Print "Panel Added"
		b = Gui_CreateButton("EXIT", 100, 20)
		print "button = ";b
		Gui_Panel_AddObject(example_panel3, b, 50, 50)
		Print "Button done"
		
		While Not Key(K_ESCAPE)
			If Gui_Button_Clicked(b) Then
				Exit While
			End If
			Gui_Update
		Wend
		Gui_SetWindowActive(win)
		Gui_WindowClose(win2)
	End If
	
	'Update events and draw gui
	Gui_Update() 'update must be called at the end of the main loop
Wend

Gui_WindowClose(win) 'closes the window
