'n00b Game Engine Gui Library
'Written by Rodney Cunningham aka n00b

'Defaults
BACK_COLOR = RGB(64,64,64)
FOR_COLOR = RGB(180,180,180)
TEXT_COLOR = RGB(255,255,255)
CHECKBOX_FILL_COLOR = RGB(0,200,0)
CHECKBOX_NULL_COLOR = RGB(255,255,255)

'GUI Stuff
DROPDOWN_STATE_CHANGE = 0
'GUI_CURRENT_EVENT = 1 FOR DROPDOWN
'GUI_CURRENT_EVENT = 2 FOR TEXTFIELD
GUI_CURRENT_EVENT = 0
ACTIVE_TEXTFIELD_PANEL = -1
ACTIVE_TEXTFIELD = -1
DROPDOWN_STATE_SCROLLDOWN = 0
DROPDOWN_STATE_SCROLLUP = 0

'CONSTANTS
MAX_PANELS = 50
MAX_BUTTONS = 50
MAX_DROPDOWNS = 50
MAX_CHECKBOXES = 50
MAX_TEXTFIELDS = 50
MAX_LISTBOXES = 50

'Canvas References
CANVAS_MAIN = 0
CANVAS_PANEL = 1
CANVAS_BITMAP = 2
CANVAS_OVERLAY = 3
CANVAS_ACTIVE = -1

'Panel Presets
PANEL_IMAGE = 0
PANEL_MIN_WIDTH = 20
PANEL_MIN_HEIGHT = 20

'DropDown Selection Stuff
DROPDOWN_IMAGE_SLOT = 1
DROPDOWN_SELECT_IMAGE_SLOT = 2

'ListBox Selection Stuff
LISTBOX_IMAGE_SLOT = 1
LISTBOX_SELECT_IMAGE_SLOT = 2

'BitmapSurface Crap
BITMAP_TMP_IMAGE = 3

'ColorSelector Stuff
CS_COLS = 11
CS_ROWS = 2

'Scrollbar
SCROLLBAR_WIDTH = 20
SCROLLBAR_HEIGHT = 20

'Types
TYPE_BUTTON = 1
TYPE_DROPDOWN = 2
TYPE_PANEL = 3
TYPE_CHECKBOX = 4
TYPE_TEXTFIELD = 5
TYPE_LISTBOX = 6
TYPE_LISTBOX_SCROLLDOWN = 7
TYPE_LISTBOX_SCROLLUP = 8
TYPE_LISTBOX_OPTION = 9
TYPE_DROPDOWN_SCROLLDOWN = 10
TYPE_DROPDOWN_SCROLLUP = 11
TYPE_DROPDOWN_OPTION = 12
TYPE_COLORSELECTOR = 13
TYPE_BITMAPSURFACE = 14
TYPE_BITMAPSURFACE_SCROLLDOWN = 15
TYPE_BITMAPSURFACE_SCROLLUP = 16
TYPE_BITMAPSURFACE_SCROLLLEFT = 17
TYPE_BITMAPSURFACE_SCROLLRIGHT = 18
TYPE_IMAGECLIP = 19
TYPE_LABEL = 20

'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
'Status = 4 for option click
'Status = 5 for option release
STATUS_NULL = 0
STATUS_HOVER = 1
STATUS_PRESS = 2
STATUS_RELEASE = 3
STATUS_OPTION_PRESS = 4
STATUS_OPTION_RELEASE = 5

'Events
EVENT_BUTTON_CLICK = 1
EVENT_DROPDOWN_SELECT = 2
EVENT_CHECKBOX_SELECT = 3
EVENT_TEXTFIELD_FOCUS = 4
EVENT_LISTBOX_SELECT = 5
EVENT_ID = 0

'Fonts
GUI_FONT = 0
Font_Directory$ = "font/"
FONT_CHAR_WIDTH = 1
FONT_CHAR_HEIGHT = 1

'Each Widget will be assigned a unique Id from 0 to whatever
Id_Count = 0
NumButtons = 0
NumDropDowns = 0
NumPanels = 0
NumCheckBoxes = 0
NumTextFields = 0
NumListBoxes = 0
NumGuiWindows = 0
NumColorSelectors = 0
NumBitmapSurfaces = 0
NumImageClips = 0
NumLabels = 0

'Images
CurrentImage = 10

'Buttons
Dim Button_Id[50]
Dim Button_Name$[50]
Dim Button_Pos[50,2]
Dim Button_Size[50,2]
'Type = 0 for text
'Type = 1 for image
Dim Button_Type[50]
Dim Button_Text$[50]
Dim Button_Image[50]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
Dim Button_Status[50]
Dim Button_Color[50,3]
Dim Button_Text_Size[50,2]
Dim Button_Panel[50]
Button_Event = -1

'Labels
Dim Label_Id[50]
Dim Label_Pos[50,2]
Dim Label_Size[50,2]
Dim Label_Text$[50]
Dim Label_Image[50]
Dim Label_Panel[50]

'DropDown Boxes
Dim DropDown_Id[50]
Dim DropDown_Name$[50]
Dim DropDown_Pos[50,2]
Dim DropDown_Size[50,2]
'DropDown Options are seperated by ;
Dim DropDown_Options$[50]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
'Status = 4 for option click
'Status = 5 for option release
Dim DropDown_Status[50]
'State = 0 for closed
'State = 1 for open
Dim DropDown_State[50]
'Selected will initially be set to -1
Dim DropDown_Selected[50]
Dim DropDown_Option_Index[50]
Dim DropDown_Selected_Text$[50,5]
Dim DropDown_Image[50,5]
Dim DropDown_Image_Pos[50,2]
Dim DropDown_Image_Size[50,2]
Dim DropDown_NumOptions[50]
Dim DropDown_Scroll[50]
Dim DropDown_Color[50,3]
Dim DropDown_ScrollBar_Pos[50,4]
Dim DropDown_ScrollBar_Size[50,2]
Dim DropDown_ScrollBar_Status[50,2]
Dim DropDown_Hover_Option[50]
Dim DropDown_Panel[50]

'Panel
Dim Panel_Id[50]
Dim Panel_Pos[50,2]
Dim Panel_Size[50,2]
Dim Panel_Title$[50]
Dim Panel_Scroll[50,2]
Dim Panel_Color[50,2]
Dim Panel_isVisible[50]
'Id for the widgets in the panel
Dim Panel_Widget[50,100]
Dim Panel_Widget_Type[50,100]
Dim Panel_Widget_Count[50]
Dim Panel_Scroll_Size[50,2]
Dim Panel_Window[50]

'CheckBoxes
Dim CheckBox_Id[50]
Dim CheckBox_Name$[50]
Dim CheckBox_Pos[50,2]
Dim CheckBox_Size[50,2]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
Dim CheckBox_Status[50]
'State = 0 for inactive
'State = 1 for active
Dim CheckBox_State[50]
Dim CheckBox_Panel[50]

'TextFields
Dim TextField_Id[50]
Dim TextField_Name$[50]
Dim TextField_Pos[50,2]
Dim TextField_Size[50,2]
Dim TextField_Font[50]
Dim TextField_Text$[50]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
Dim TextField_Status[50]
'State = 0 for no focus
'State = 1 for focus
Dim TextField_State[50]
Dim TextField_Scroll[50,2]
Dim TextField_ScrollBar_Active[50]
Dim TextField_ScrollBar_Pos[50,2]
Dim TextField_ScrollBar_Size[50,2]
Dim TextField_ScrollBar_Status[50]
Dim TextField_Flag[50]
Dim TextField_Cursor[50]
Dim TextField_Panel[50]

'ListBoxes
Dim ListBox_Id[50]
Dim ListBox_Name$[50]
Dim ListBox_Pos[50,2]
Dim ListBox_Size[50,2]
'ListBox Options are seperated by ;
Dim ListBox_Options$[50]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
'Status = 4 for option click
'Status = 5 for option release
Dim ListBox_Status[50]
'State = 0 for closed
'State = 1 for open
Dim ListBox_State[50]
'Selected will initially be set to -1
Dim ListBox_Selected[50]
Dim ListBox_Option_Index[50]
Dim ListBox_Selected_Text$[50,30]
Dim ListBox_Image[50,10]
Dim ListBox_Image_Pos[50,2]
Dim ListBox_Image_Size[50,2]
Dim ListBox_NumOptions[50]
Dim ListBox_NumListed[50]
Dim ListBox_Scroll[50]
Dim ListBox_Color[50,3]
Dim ListBox_ScrollBar_Pos[50,4]
Dim ListBox_ScrollBar_Size[50,2]
Dim ListBox_ScrollBar_Status[50,2]
Dim ListBox_Hover_Option[50]
Dim ListBox_Highlight[50]
Dim ListBox_Highlight_Text$[50]
Dim ListBox_Panel[50]

'BitmapSurfaces
Dim BitmapSurface_Id[50]
Dim BitmapSurface_Name$[50]
Dim BitmapSurface_Size[50,2]
'Image = Image Slot bitmap surface saves to or displays
Dim BitmapSurface_Image[50]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
Dim BitmapSurface_Status[50]
'State = 0 for no focus
'State = 1 for focus
Dim BitmapSurface_State[50]
Dim BitmapSurface_ClearColor[50]
Dim BitmapSurface_ScrollBar_Pos[50,8]
Dim BitmapSurface_ScrollBar_Size[50,4]
Dim BitmapSurface_ScrollBar_Status[50,4]
Dim BitmapSurface_Viewport_Pos[50,2]
Dim BitmapSurface_Viewport_Size[50,2]
Dim BitmapSurface_Offset[50,2]
Dim BitmapSurface_Panel[50]
Dim BitmapSurface_Mouse[50,2]
Dim BitmapSurface_DrawCommand[100]
Dim BitmapSurface_Arg_n[100,10]
Dim BitmapSurface_Arg_s$[100,10]
BitmapSurface_NumCommands = 0

Dim BitmapSurface2_DrawCommand[100]
Dim BitmapSurface2_Arg_n[100,10]
Dim BitmapSurface2_Arg_s$[100,10]
BitmapSurface2_NumCommands = 0

Active_BitmapSurface = -1
BitmapSurface_Event = -1

'ImageClip
Dim ImageClip_Id[50]
Dim ImageClip_Pos[50,2]
Dim ImageClip_Size[50,2]
Dim ImageClip_Image[50]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
Dim ImageClip_Status[50]
Dim ImageClip_Border[50]
Dim ImageClip_Mouse[50,2]
Dim ImageClip_Panel[50]
ImageClip_Event = -1

'ColorSelector
Dim ColorSelector_Id[50]
Dim ColorSelector_Name$[50]
Dim ColorSelector_Pos[50,2]
Dim ColorSelector_Size[50,2]
Dim ColorSelector_Rows[50]
Dim ColorSelector_Cols[50]
Dim ColorSelector_Color[50,20*20]
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
Dim ColorSelector_Status[50]
Dim ColorSelector_Selected[50]
Dim ColorSelector_Image[50]
Dim ColorSelector_Image_Pos[50,2]
Dim ColorSelector_Image_Size[50,2]
Dim ColorSelector_Panel[50]

'TileSelector
Dim TileSelector_Id
Dim TileSelector_Name$
Dim TileSelector_Pos[2]
Dim TileSelector_Size[2]
Dim TileSelector_TileSize[2]
Dim TileSelector_TileFrame[50*50]
Dim TileSelector_Rows
Dim TileSelector_Cols
Dim TileSelector_Image
'Status = 0 for no interaction
'Status = 1 for mouse hover
'Status = 2 for mouse click
'Status = 3 for mouse release
Dim TileSelector_Status
Dim TileSelector_Selected
Dim TileSelector_Panel[50]

Dim GuiWindow_isOpen[8]
Dim GuiWindow_Size[8,2]
Dim GuiWindow_Panel[8,50]
Dim NumGuiPanels[8]
Dim GuiWindow_Mouse[8,5]
CurrentWindow = 0
Active_Panel = -1

Sub Gui_Init()
	For i = 0 to 7
		GuiWindow_isOpen[i] = false
	Next
	For i = 0 to MAX_PANELS-1
		Panel_Id[i] = -1
	Next
	For i = 0 to MAX_BUTTONS-1
		Button_Status[i] = -1
	Next
	LoadFont(GUI_FONT, Font_Directory$ + "FreeMono.ttf", 12)
	Dim cw
	Dim ch
	GetTextSize(GUI_FONT, "A", cw, ch)
	FONT_CHAR_WIDTH = cw
	FONT_CHAR_HEIGHT = ch
End Sub

Function GetFocusWindow()
	For i = 0 to 7
		If WindowExists(i) Then
			If WindowHasMouseFocus(i) Then
				Return i
			End If
		End If
	Next
	Return -1
End Function

Function Gui_CreatePanel(win_num, title$, x, y, w, h)
	If w < PANEL_MIN_WIDTH Then
		w = PANEL_MIN_WIDTH
	End If
	If h < PANEL_MIN_HEIGHT Then
		h = PANEL_MIN_HEIGHT
	End If
	p_num = NumPanels
	NumPanels = NumPanels + 1
	Panel_Id[p_num] = Id_Count
	Id_Count = Id_Count + 1
	Panel_Title$[p_num] = title$
	Panel_Pos[p_num,0] = x
	Panel_Pos[p_num,1] = y
	Panel_Size[p_num,0] = w
	Panel_Size[p_num,1] = h
	Panel_Scroll[p_num,0] = 0
	Panel_Scroll[p_num,1] = 0
	Panel_Scroll_Size[p_num,0] = w
	Panel_Scroll_Size[p_num,1] = h
	Panel_Color[p_num,0] = RGB(64, 64, 64)
	Panel_Color[p_num,1] = RGB(128, 128, 128)
	GuiWindow_Panel[win_num,NumGuiPanels[win_num]] = p_num
	NumGuiPanels[win_num] = NumGuiPanels[win_num] + 1
	Panel_Window[p_num] = win_num
	Return Panel_Id[p_num]
End Function

Sub Gui_Window_AddPanel(win_num, p_id)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return
	End If
	GuiWindow_Panel[win_num,NumGuiPanels[win_num]] = p_num
	NumGuiPanels[win_num] = NumGuiPanels[win_num] + 1
	Panel_Window[p_num] = win_num
End Sub

Sub Gui_SetPanelColor(p_id, p_for_color, p_back_color)
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			Panel_Color[i,0] = p_back_color
			Panel_Color[i,1] = p_for_color
			Return
		End If
	next
End Sub

Sub Gui_ShowPanel(p_id)
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			Panel_isVisible[i] = True
			Return
		End If
	Next
End Sub

Sub Gui_HidePanel(p_id)
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			Panel_isVisible[i] = False
			Return
		End If
	Next
End Sub

Sub Gui_SetPanelScrollSize(p_id, w, h)
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			Panel_Scroll_Size[i,0] = w
			Panel_Scroll_Size[i,1] = h
			Return
		End If
	Next
End Sub

Sub Gui_SetPanelCanvasSize(win, w, h)
	CanvasClose(CANVAS_PANEL)
	win_width = 0
	win_height = 0
	Window(win)
	GetWindowSize(win, win_width, win_height)
	CanvasOpen(CANVAS_PANEL, w, h, 0, 0, win_width, win_height, 1)
	If CurrentWindow <> -1 Then
		Window(CurrentWindow)
	End If
End Sub

Function Gui_CreateButton(p_id, text$, x, y, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If

	b_num = NumButtons
	NumButtons = NumButtons + 1
	Button_Id[b_num] = Id_Count
	Id_Count = Id_Count + 1
	Button_Panel[b_num] = p_num
	Button_Text$[b_num] = text$
	Button_Status[b_num] = STATUS_NULL
	Button_Pos[b_num,0] = x
	Button_Pos[b_num,1] = y
	Button_Size[b_num,0] = w
	Button_Size[b_num,1] = h
	Button_Color[b_num,0] = BACK_COLOR
	Button_Color[b_num,1] = FOR_COLOR
	Button_Color[b_num,2] = TEXT_COLOR
	Font(GUI_FONT)
	SetColor(Button_Color[b_num,2])
	text_width = 0
	text_height = 0
	GetTextSize(GUI_FONT, text$, text_width, text_height)
	Button_Text_Size[b_num,0] = text_width
	Button_Text_Size[b_num,1] = text_height
	If Button_Size[b_num,1] < text_height+2 Then
		Button_Size[b_num,1] = text_height + 2
	End If
	RenderText(CurrentImage, text$)
	Button_Image[b_num] = CurrentImage
	CurrentImage = CurrentImage + 1
	If x+w > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w
	End If
	If y+h > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h
	End If
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = b_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_BUTTON
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	Return Button_Id[b_num]
End Function

Function Gui_CreateLabel(p_id, text$, x, y)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If

	l_num = NumLabels
	NumLabels = NumLabels + 1
	Label_Id[l_num] = Id_Count
	Id_Count = Id_Count + 1
	Label_Panel[l_num] = p_num
	Label_Text$[l_num] = text$
	Label_Pos[l_num,0] = x
	Label_Pos[l_num,1] = y
	Font(GUI_FONT)
	SetColor(RGB(5,5,5))
	RenderText(CurrentImage, text$)
	Label_Image[l_num] = CurrentImage
	CurrentImage = CurrentImage + 1
	Dim w
	Dim h
	GetTextSize(GUI_FONT, text$, w, h)
	If x+w > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w
	End If
	If y+h > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h
	End If
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = l_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_LABEL
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	Return Label_Id[l_num]
End Function

Sub Gui_Label_SetText(id, text$)
	l_num = -1
	For i = 0 to NumLabels-1
		If Label_Id[i] = id Then
			l_num = i
			Exit For
		End If
	Next
	If l_num = -1 Then
		Return
	End If

	Label_Text$[l_num] = text$
	DeleteImage(Label_Image[l_num])
	Font(GUI_FONT)
	SetColor(RGB(5,5,5))
	RenderText(Label_Image[l_num], text$)
End Sub

Function Gui_CreateImageClip(p_id, x, y, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If

	i_num = -1
	If NumImageClips > 0 Then
		For i = 0 To NumImageClips-1
			If ImageClip_Id[i] = -1 Then
				i_num = i
				Exit For
			End If
		Next
	End If

	If i_num < 0 Then
		i_num = NumImageClips
		NumImageClips = NumImageClips + 1
	End If

	ImageClip_Id[i_num] = Id_Count
	Id_Count = Id_Count + 1
	ImageClip_Panel[i_num] = p_num
	ImageClip_Status[i_num] = STATUS_NULL
	ImageClip_Pos[i_num,0] = x
	ImageClip_Pos[i_num,1] = y
	ImageClip_Size[i_num,0] = w
	ImageClip_Size[i_num,1] = h
	ImageClip_Border[i_num] = False

	ImageClip_Image[i_num] = CurrentImage
	CurrentImage = CurrentImage + 1

	If x+w > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w
	End If
	If y+h > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h
	End If

	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = i_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_IMAGECLIP
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	Return ImageClip_Id[i_num]
End Function

Sub Gui_DeleteImageClip(id)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		Return
	End If
	If ImageExists(ImageClip_Image[i_num]) Then
		DeleteImage(ImageClip_Image[i_num])
	End If
	p_num = ImageClip_Panel[i_num]
	ImageClip_Panel[i_num] = -1
	For i = 0 to Panel_Widget_Count[p_num]-1
		If Panel_Widget[p_num, i] = i_num Then
			Panel_Widget[p_num, i] = -1
			Panel_Widget_Type[p_num, i] = -1
		End If
	Next
	ImageClip_Id[i_num] = -1
End Sub

Sub Gui_ImageClip_ShowBorder(id)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		Return
	End If
	ImageClip_Border[i_num] = True
End Sub

Sub Gui_ImageClip_HideBorder(id)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		Return
	End If
	ImageClip_Border[i_num] = False
End Sub

Sub Gui_ImageClip_Load(id, img_file$)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		Return
	End If
	If ImageExists(ImageClip_Image[i_num]) Then
		DeleteImage(ImageClip_Image[i_num])
	End If

	LoadImage(CurrentImage, img_file$)
	src_w = 1
	src_h = 1
	GetImageSize(CurrentImage, src_w, src_h)
	Canvas(CANVAS_OVERLAY)
	ClearCanvas()
	DrawImage_Blit_Ex(CurrentImage, 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1], 0, 0, src_w, src_h)
	CanvasClip(ImageClip_Image[i_num], 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1],1)
	Canvas(CANVAS_PANEL)
	DeleteImage(CurrentImage)
End Sub

Sub Gui_ImageClip_Grab(id, img, src_x, src_y, src_w, src_h)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		Return
	End If
	If ImageExists(ImageClip_Image[i_num]) Then
		DeleteImage(ImageClip_Image[i_num])
	End If
	Canvas(CANVAS_OVERLAY)
	ClearCanvas()
	DrawImage_Blit_Ex(img, 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1], src_x, src_y, src_w, src_h)
	CanvasClip(ImageClip_Image[i_num], 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1],1)
	Canvas(CANVAS_PANEL)
End Sub

Sub Gui_ImageClip_Copy(id, img)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		Return
	End If
	If ImageExists(ImageClip_Image[i_num]) Then
		DeleteImage(ImageClip_Image[i_num])
	End If
	src_w = 1
	src_h = 1
	GetImageSize(img, src_w, src_h)
	Canvas(CANVAS_OVERLAY)
	ClearCanvas()
	DrawImage_Blit_Ex(img, 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1], 0, 0, src_w, src_h)
	CanvasClip(ImageClip_Image[i_num], 0, 0, ImageClip_Size[i_num,0], ImageClip_Size[i_num,1],1)
	Canvas(CANVAS_PANEL)
End Sub

Function Gui_ImageClip_Clicked(id)
	If ImageClip_Event = id Then
		Return True
	Else
		Return False
	End If
End Function

Sub Gui_ImageClip_GetMouse(id, ByRef x, ByRef y)
	i_num = -1
	For i = 0 to NumImageClips-1
		If ImageClip_Id[i] = id Then
			i_num = i
			Exit For
		End If
	Next
	If i_num = -1 Then
		x = -1
		y = -1
		Return
	End If
	x = ImageClip_Mouse[i_num,0]
	y = ImageClip_Mouse[i_num,1]
End Sub

Function Gui_LoadImage(img_file$)
	img = CurrentImage
	LoadImage(img, img_file$)
	If Not ImageExists(img) Then
		Return -1
	End If
	CurrentImage = CurrentImage + 1
	Return img
End Function

Sub Gui_DeleteImage(img)
	DeleteImage(img)
End Sub

Function Gui_CreateGraphicButton(p_id, img_file$, x, y, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If

	b_num = NumButtons
	NumButtons = NumButtons + 1
	Button_Id[b_num] = Id_Count
	Id_Count = Id_Count + 1
	Button_Panel[b_num] = p_num
	Button_Status[b_num] = STATUS_NULL
	Button_Pos[b_num,0] = x
	Button_Pos[b_num,1] = y
	Button_Size[b_num,0] = w
	Button_Size[b_num,1] = h
	Button_Color[b_num,0] = BACK_COLOR
	Button_Color[b_num,1] = FOR_COLOR
	Button_Color[b_num,2] = TEXT_COLOR

	Button_Image[b_num] = CurrentImage
	CurrentImage = CurrentImage + 1

	LoadImage(Button_Image[b_num], img_file$)
	ColorKey(Button_Image[b_num], -1)
	img_w = 0
	img_h = 0
	GetImageSize(Button_Image[b_num], img_w, img_h)

	If Button_Size[b_num,0] < img_w+2 Then
		Button_Size[b_num,0] = img_w + 2
	End If

	If Button_Size[b_num,1] < img_h+2 Then
		Button_Size[b_num,1] = img_h + 2
	End If

	If x+Button_Size[b_num,0] > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+Button_Size[b_num,0]
	End If
	If y+Button_Size[b_num,1] > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+Button_Size[b_num,1]
	End If
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = b_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_BUTTON
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	Return Button_Id[b_num]
End Function

Function Gui_CreateBitmapSurface(p_id, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If

	b_num = NumBitmapSurfaces
	NumBitmapSurfaces = NumBitmapSurfaces + 1
	BitmapSurface_Id[b_num] = Id_Count
	Id_Count = Id_Count + 1
	BitmapSurface_Panel[b_num] = p_num
	BitmapSurface_Image[b_num] = CurrentImage
	CurrentImage = CurrentImage + 1

	If Panel_Size[p_num,0] > w Then
		Panel_Size[p_num,0] = w
	End If

	If Panel_Size[p_num,1] > h Then
		Panel_Size[p_num,1] = h
	End If

	If w > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = w
	End If
	If h > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = h
	End If
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = b_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_BITMAPSURFACE
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	Return BitmapSurface_Id[b_num]
End Function

Sub ColorSelector_SetColors_Image(c_num)
	If ImageExists(ColorSelector_Image[c_num]) Then
		DeleteImage(ColorSelector_Image[c_num])
	End If
	w = ColorSelector_Size[c_num,0]
	h = ColorSelector_Size[c_num,1]
	color_w = Int(w / 11)
	color_h = Int(h / 2)
	ColorSelector_Image_Size[c_num,0] = color_w
	ColorSelector_Image_Size[c_num,1] = color_h
	color_index = 0
	Canvas(CANVAS_OVERLAY)
	For y = 0 To 1
		For x = 0 To 10
			SetColor(ColorSelector_Color[c_num, color_index])
			RectFill( (x*color_w), (y*color_h), color_w, color_h)
			color_index = color_index + 1
		Next
	Next
	CanvasClip(ColorSelector_Image[c_num], 0, 0, w-2, h-2, 1)
	Canvas(CANVAS_PANEL)
End Sub

Function Gui_CreateColorSelector(p_id, x, y, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If

	c_num = NumColorSelectors
	NumColorSelectors = NumColorSelectors + 1
	ColorSelector_Id[c_num] = Id_Count
	Id_Count = Id_Count + 1
	ColorSelector_Panel[c_num] = p_num
	ColorSelector_Status[c_num] = STATUS_NULL
	ColorSelector_Pos[c_num,0] = x
	ColorSelector_Pos[c_num,1] = y
	ColorSelector_Size[c_num,0] = w
	ColorSelector_Size[c_num,1] = h
	ColorSelector_Image[c_num] = CurrentImage
	CurrentImage = CurrentImage + 1
	ColorSelector_Image_Pos[c_num,0] = x+1
	ColorSelector_Image_Pos[c_num,1] = y+1

	ColorSelector_Color[c_num,0] = RGB(5,5,5)
	ColorSelector_Color[c_num,1] = RGB(128,128,128)
	ColorSelector_Color[c_num,2] = RGB(255,0,0)
	ColorSelector_Color[c_num,3] = RGB(255,128,0)
	ColorSelector_Color[c_num,4] = RGB(255,255,0)
	ColorSelector_Color[c_num,5] = RGB(0,255,0)
	ColorSelector_Color[c_num,6] = RGB(0,255,255)
	ColorSelector_Color[c_num,7] = RGB(0,0,255)
	ColorSelector_Color[c_num,8] = RGB(255,0,255)
	ColorSelector_Color[c_num,9] = RGB(255,128,128)
	ColorSelector_Color[c_num,10] = RGB(255,128,255)
	ColorSelector_Color[c_num,11] = RGB(255,255,255)
	ColorSelector_Color[c_num,12] = RGB(192,192,192)
	ColorSelector_Color[c_num,13] = RGB(128,0,0)
	ColorSelector_Color[c_num,14] = RGB(128,64,0)
	ColorSelector_Color[c_num,15] = RGB(128,128,0)
	ColorSelector_Color[c_num,16] = RGB(0,128,0)
	ColorSelector_Color[c_num,17] = RGB(0,128,128)
	ColorSelector_Color[c_num,18] = RGB(0,0,128)
	ColorSelector_Color[c_num,19] = RGB(128,0,128)
	ColorSelector_Color[c_num,20] = RGB(128,128,255)
	ColorSelector_Color[c_num,21] = RGB(255,255,128)

	ColorSelector_SetColors_Image(c_num)

	If x+w+5 > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w+5
	End If
	If y+h+5 > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h+5
	End If
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = c_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_COLORSELECTOR
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	Return ColorSelector_Id[c_num]
End Function

Sub SelectDropDownOption(d_num, opt_num)
	DropDown_Selected[d_num] = opt_num
	If DropDown_Selected[d_num] >= DropDown_NumOptions[d_num] Then
		DropDown_Selected[d_num] = DropDown_NumOptions[d_num] - 1
		opt_num = DropDown_NumOptions[d_num] - 1
	ElseIf DropDown_Selected[d_num] < 0 Then
		DropDown_Selected[d_num] = 0
		opt_num = 0
	End If
	opt_index = 0
	d_index = 0
	n = 0
	start_index = 0
	For i = 0 to Length(DropDown_Options$[d_num]) - 1
		If opt_index >= DropDown_NumOptions[d_num] Then
			Exit For
		End If
		If Mid$(DropDown_Options$[d_num], i, 1) = ";" Then
			'Print "Opt[" + opt_index + "]: " + Mid$(DropDown_Options$[d_num], start_index, n)
			If opt_index >= opt_num Then
				DropDown_Selected_Text$[d_num, d_index] = Mid$(DropDown_Options$[d_num], start_index, n)
				RenderText(CurrentImage, DropDown_Selected_Text$[d_num, d_index])
				CurrentImage = CurrentImage + 1
				d_index = d_index + 1
				If d_index = 5 Then
					Exit For
				End If
			End If
			start_index = i + 1
			opt_index = opt_index + 1
			n = 0
		Else
			n = n + 1
		End If
	Next

	If d_index < 5 Then
		For i = d_index to 4
			DropDown_Selected_Text$[d_num, i] = ""
		Next
	End If


End Sub

Sub SelectListBoxOption(l_num, opt_num)
	ListBox_Selected[l_num] = opt_num
	If ListBox_Selected[l_num] >= ListBox_NumOptions[l_num] Then
		ListBox_Selected[l_num] = ListBox_NumOptions[l_num] - 1
		opt_num = ListBox_NumOptions[l_num] - 1
	ElseIf ListBox_Selected[l_num] < 0 Then
		ListBox_Selected[l_num] = 0
		opt_num = 0
	End If
	opt_index = 0
	l_index = 0
	n = 0
	start_index = 0

	'Print "LB_Debug 1: " + ListBox_Selected[l_num]
	For i = 0 to Length(ListBox_Options$[l_num]) - 1
		'Print "LB Debug 2: " + opt_index
		'Print "LB Debug 2: " + ListBox_NumOptions[l_num]
		If opt_index >= ListBox_NumOptions[l_num] Then
			Exit For
		End If
		'Print "LB Debug 3: [" + ListBox_Options$[l_num] + "]"
		If Mid$(ListBox_Options$[l_num], i, 1) = ";" Then
			'Print "Opt[" + opt_index + "]: " + Mid$(DropDown_Options$[d_num], start_index, n)
			'Print "LB Debug 4: " + opt_num
			If opt_index >= opt_num Then
				ListBox_Selected_Text$[l_num, l_index] = Mid$(ListBox_Options$[l_num], start_index, n)
				'Print "LTEXT[" + l_index + "] = " + ListBox_Selected_Text$[l_num, l_index]
				'RenderText(CurrentImage, ListBox_Selected_Text$[l_num, l_index])
				'CurrentImage = CurrentImage + 1
				l_index = l_index + 1
				'Print "l_index: " + l_index
				'Print "NumListed = " + ListBox_NumListed[l_num]
				If l_index = ListBox_NumListed[l_num] Then
					Exit For
				End If
			End If
			start_index = i + 1
			opt_index = opt_index + 1
			n = 0
		Else
			n = n + 1
		End If
	Next
	'Print "LB Exit For"
	If l_index < ListBox_NumListed[l_num] Then
		'Print "Balls: " + l_index
		'Print "Sack: " + ListBox_NumListed[l_num]-1
		For i = l_index to ListBox_NumListed[l_num]-1
			ListBox_Selected_Text$[l_num, i] = ""
		Next
	End If


End Sub

Function Gui_CreateListBox(p_id, options$, x, y, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If
	l_num = NumListBoxes
	NumListBoxes = NumListBoxes + 1
	ListBox_Id[l_num] = Id_Count
	Id_Count = Id_Count + 1
	ListBox_Panel[l_num] = p_num
	ListBox_Options$[l_num] = options$
	ListBox_Pos[l_num,0] = x
	ListBox_Pos[l_num,1] = y
	ListBox_Size[l_num,0] = w
	ListBox_Size[l_num,1] = h
	ListBox_Selected[l_num] = 0
	ListBox_Selected_Text$[l_num,0] = ""
	ListBox_Color[l_num,0] = BACK_COLOR
	ListBox_Color[l_num,1] = FOR_COLOR
	ListBox_Color[l_num,2] = TEXT_COLOR
	ListBox_ScrollBar_Pos[l_num,0] = x + w
	ListBox_ScrollBar_Pos[l_num,1] = y
	ListBox_ScrollBar_Pos[l_num,2] = x + w
	ListBox_ScrollBar_Pos[l_num,3] = y + (h/2)
	ListBox_ScrollBar_Size[l_num,0] = 20
	ListBox_ScrollBar_Size[l_num,1] = 25
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = l_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_LISTBOX
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	For i = 0 to Length(ListBox_Options$[l_num])-1
		If Mid$(ListBox_Options$[l_num], i, 1) = ";" Then
			ListBox_NumOptions[l_num] = ListBox_NumOptions[l_num] + 1
		End If
	Next
	If (x+w+25) > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w+25
	End If
	If y+h > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h+5
	End If
	ListBox_NumListed[l_num] = Int(ListBox_Size[l_num,1] / FONT_CHAR_HEIGHT)
	SelectListBoxOption(l_num, 0)
	Return ListBox_Id[l_num]
End Function

Function Gui_CreateDropDown(p_id, options$, x, y, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If
	d_num = NumDropDowns
	NumDropDowns = NumDropDowns + 1
	DropDown_Id[d_num] = Id_Count
	Id_Count = Id_Count + 1
	DropDown_Panel[d_num] = p_num
	DropDown_Options$[d_num] = options$
	DropDown_Pos[d_num,0] = x
	DropDown_Pos[d_num,1] = y
	DropDown_Size[d_num,0] = w
	DropDown_Size[d_num,1] = h
	DropDown_Selected[d_num] = 0
	DropDown_Selected_Text$[d_num,0] = ""
	DropDown_Color[d_num,0] = BACK_COLOR
	DropDown_Color[d_num,1] = FOR_COLOR
	DropDown_Color[d_num,2] = TEXT_COLOR
	DropDown_Image_Pos[d_num,0] = x
	DropDown_Image_Pos[d_num,1] = y + h
	DropDown_Image_Size[d_num,0] = w
	DropDown_Image_Size[d_num,1] = 50
	DropDown_ScrollBar_Pos[d_num,0] = x + w
	DropDown_ScrollBar_Pos[d_num,1] = y + h
	DropDown_ScrollBar_Pos[d_num,2] = x + w
	DropDown_ScrollBar_Pos[d_num,3] = y + h + 25
	DropDown_ScrollBar_Size[d_num,0] = 20
	DropDown_ScrollBar_Size[d_num,1] = 25
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = d_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_DROPDOWN
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	For i = 0 to Length(DropDown_Options$[d_num])-1
		If Mid$(DropDown_Options$[d_num], i, 1) = ";" Then
			DropDown_NumOptions[d_num] = DropDown_NumOptions[d_num] + 1
		End If
	Next
	If x+w > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w
	End If
	If y+h+50 > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h+50
	End If
	SelectDropDownOption(d_num, 0)
	Return DropDown_Id[d_num]
End Function

Function Gui_CreateCheckBox(p_id, x, y, w, h)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If
	cb_num = NumCheckBoxes
	NumCheckBoxes = NumCheckBoxes + 1
	CheckBox_Id[cb_num] = Id_Count
	Id_Count = Id_Count + 1
	CheckBox_Panel[cb_num] = p_num
	CheckBox_Pos[cb_num,0] = x
	CheckBox_Pos[cb_num,1] = y
	CheckBox_Size[cb_num,0] = w
	CheckBox_Size[cb_num,1] = h
	CheckBox_Status[cb_num] = STATUS_NULL
	CheckBox_State[cb_num] = 0
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = cb_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_CHECKBOX
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	If x+w > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w
	End If
	If y+h > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h
	End If
	Return CheckBox_Id[cb_num]
End Function

Function Gui_CreateTextField(p_id, x, y, w, h, flag, scroll_active)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
		End If
	Next

	If p_num = -1 Then
		Return -1
	End If
	tf_num = NumTextFields
	NumTextFields = NumTextFields + 1
	TextField_Id[tf_num] = Id_Count
	Id_Count = Id_Count + 1
	TextField_Panel[tf_num] = p_num
	If scroll_active Then
		TextField_Pos[tf_num,0] = x
		TextField_Pos[tf_num,1] = y
		TextField_Size[tf_num,0] = w - 15
		TextField_Size[tf_num,1] = h - 15
		TextField_ScrollBar_Active[tf_num] = True
		'print "scroll = " + scroll_active
	Else
		TextField_Pos[tf_num,0] = x
		TextField_Pos[tf_num,1] = y
		TextField_Size[tf_num,0] = w
		TextField_Size[tf_num,1] = h
		'print "normal width"
	End If
	If TextField_Size[tf_num,1] < 15 Then
		TextField_Size[tf_num,1] = 15
	End If
	sx = TextField_Pos[tf_num,0] + TextField_Size[tf_num,0]
	sy = TextField_Pos[tf_num,1]
	TextField_ScrollBar_Pos[tf_num,0] = sx
	TextField_ScrollBar_Pos[tf_num,1] = sy
	TextField_ScrollBar_Size[tf_num,0] = 15
	TextField_ScrollBar_Size[tf_num,1] = 15
	TextField_Status[tf_num] = STATUS_NULL
	TextField_State[tf_num] = 0
	TextField_Flag[tf_num] = flag
	Panel_Widget[p_num, Panel_Widget_Count[p_num]] = tf_num
	Panel_Widget_Type[p_num, Panel_Widget_Count[p_num]] = TYPE_TEXTFIELD
	Panel_Widget_Count[p_num] = Panel_Widget_Count[p_num] + 1
	TextField_Text$[tf_num] = ""
	If x+w > Panel_Scroll_Size[p_num,0] Then
		Panel_Scroll_Size[p_num,0] = x+w
	End If
	If y+h > Panel_Scroll_Size[p_num,1] Then
		Panel_Scroll_Size[p_num,1] = y+h
	End If
	Return TextField_Id[tf_num]
End Function

Sub DrawTextField(tf_num)
	Canvas(CANVAS_PANEL)
	SetColor(BACK_COLOR)
	Rect(TextField_Pos[tf_num,0], TextField_Pos[tf_num,1], TextField_Size[tf_num,0], TextField_Size[tf_num,1])
	SetColor(RGB(255,255,255))
	RectFill(TextField_Pos[tf_num,0]+1, TextField_Pos[tf_num,1]+1, TextField_Size[tf_num,0]-2, TextField_Size[tf_num,1]-2)
	SetColor(RGB(0,0,0))
	start_index = Length(TextField_Text$[tf_num]) - Int(TextField_Size[tf_num,0]/FONT_CHAR_WIDTH) - 1
	Dim display_text$
	If start_index < 0 Then
		display_text$ = TextField_Text$[tf_num] + " "
	Else
		display_text$ = Mid(TextField_Text$[tf_num], start_index, Length(TextField_Text$[tf_num]) )
	End If
	DrawText(display_text$, TextField_Pos[tf_num,0], TextField_Pos[tf_num,1])
End Sub

Sub BitmapSurfaceCommands()
	Dim n[10]
	Dim s$[10]
	If BitmapSurface_NumCommands > 0 Then
		For i = 0 To BitmapSurface_NumCommands-1

			For j = 0 to 9
				n[j] = BitmapSurface_Arg_n[i,j]
				s$[j] = BitmapSurface_Arg_s$[i,j]
			Next

			Select Case BitmapSurface_DrawCommand[i]
			Case 1
				ClearCanvas()
			Case 2
				DrawImage(n[0], n[1], n[2])
			Case 3
				DrawImage_Blit(n[0], n[1], n[2], n[3], n[4], n[5], n[6])
			Case 4
				Font(n[0])
			Case 5
				DrawText(s$[0], n[0], n[1])
			Case 6
				PSet(n[0], n[1])
			Case 7
				Line(n[0], n[1], n[2], n[3])
			Case 8
				Rect(n[0], n[1], n[2], n[3])
			Case 9
				RectFill(n[0], n[1], n[2], n[3])
			Case 10
				FloodFill(n[0], n[1])
			Case 11
				Circle(n[0], n[1], n[2])
			Case 12
				CircleFill(n[0], n[1], n[2])
			Case 13
				CanvasClip(n[0], n[1], n[2], n[3], n[4], 1)
			Case 14
				SetColor(n[0])
			End Select
		Next
	End If
	BitmapSurface_NumCommands = 0
End Sub

Sub BitmapSurface2Commands()
	Dim n[10]
	Dim s$[10]
	If BitmapSurface2_NumCommands > 0 Then
		For i = 0 To BitmapSurface2_NumCommands-1

			For j = 0 to 9
				n[j] = BitmapSurface2_Arg_n[i,j]
				s$[j] = BitmapSurface2_Arg_s$[i,j]
			Next

			Select Case BitmapSurface2_DrawCommand[i]
			Case 1
				ClearCanvas()
			Case 2
				DrawImage(n[0], n[1], n[2])
			Case 3
				DrawImage_Blit(n[0], n[1], n[2], n[3], n[4], n[5], n[6])
			Case 4
				Font(n[0])
			Case 5
				DrawText(s$[0], n[0], n[1])
			Case 6
				PSet(n[0], n[1])
			Case 7
				Line(n[0], n[1], n[2], n[3])
			Case 8
				Rect(n[0], n[1], n[2], n[3])
			Case 9
				RectFill(n[0], n[1], n[2], n[3])
			Case 10
				FloodFill(n[0], n[1])
			Case 11
				Circle(n[0], n[1], n[2])
			Case 12
				CircleFill(n[0], n[1], n[2])
			Case 13
				CanvasClip(n[0], n[1], n[2], n[3], n[4], 1)
			Case 14
				SetColor(n[0])
			End Select
		Next
	End If
	BitmapSurface2_NumCommands = 0
End Sub

Sub DrawBitmapSurface(b_num)
	Canvas(CANVAS_PANEL)
	p = BitmapSurface_Panel[b_num]
	'SetColor(RGB(1,1,1))
	'RectFill(0, 0, Panel_Size[p,0], Panel_Size[p,1])
	w = Panel_Scroll_Size[p,0]
	h = Panel_Scroll_Size[p,1]
	If ImageExists(BitmapSurface_Image[b_num]) Then
		DrawImage(BitmapSurface_Image[b_num],0,0)
		GetImageSize(BitmapSurface_Image[b_num], w, h)
		DeleteImage(BitmapSurface_Image[b_num])
	End If
	BitmapSurfaceCommands()
	CanvasClip(BitmapSurface_Image[b_num], 0, 0, w, h, 1)
	BitmapSurface2Commands()
End Sub

Sub DrawCheckBox(cb_num)
	Canvas(CANVAS_PANEL)
	SetColor(BACK_COLOR)
	Rect(CheckBox_Pos[cb_num,0], CheckBox_Pos[cb_num,1], CheckBox_Size[cb_num,0], CheckBox_Size[cb_num,1])
	If CheckBox_Status[cb_num] = STATUS_PRESS Then
		SetColor(RGB(FOR_COLOR SHL 16, FOR_COLOR SHL 8, FOR_COLOR))
	Else
		If CheckBox_State[cb_num] Then
			SetColor(CHECKBOX_FILL_COLOR)
		Else
			SetColor(CHECKBOX_NULL_COLOR)
		End If
	End If
	RectFill(CheckBox_Pos[cb_num,0]+1, CheckBox_Pos[cb_num,1]+1, CheckBox_Size[cb_num,0]-2, CheckBox_Size[cb_num,1]-2)
End Sub

Sub DrawColorSelector(c_num)
	Canvas(CANVAS_PANEL)
	SetColor(BACK_COLOR)
	Rect(ColorSelector_Pos[c_num,0], ColorSelector_Pos[c_num,1], ColorSelector_Size[c_num,0], ColorSelector_Size[c_num,1])
	DrawImage(ColorSelector_Image[c_num], ColorSelector_Image_Pos[c_num,0], ColorSelector_Image_Pos[c_num,1])
End Sub

Sub DrawImageClip(i_num)
	Canvas(CANVAS_PANEL)
	If ImageExists(ImageClip_Image[i_num]) Then
		DrawImage(ImageClip_Image[i_num], ImageClip_Pos[i_num,0], ImageClip_Pos[i_num,1])
	Else
		SetColor(RGB(5,5,5))
		RectFill(ImageClip_Pos[i_num,0], ImageClip_Pos[i_num,1], ImageClip_Size[i_num,0], ImageClip_Size[i_num, 1])
	End If
	If ImageClip_Border[i_num] Then
		SetColor(BACK_COLOR)
		Rect(ImageClip_Pos[i_num,0], ImageClip_Pos[i_num,1], ImageClip_Size[i_num,0], ImageClip_Size[i_num,1])
	End If
End Sub

Sub DrawDropDown(d_num)
	Canvas(CANVAS_PANEL)
	SetColor(DropDown_Color[d_num,0])
	Rect(DropDown_Pos[d_num,0], DropDown_Pos[d_num,1], DropDown_Size[d_num,0], DropDown_Size[d_num,1])
	If DropDown_Status[d_num] = STATUS_PRESS Then
		SetColor(RGB(DropDown_Color[d_num,1] SHL 16, DropDown_Color[d_num,1] SHL 8, DropDown_Color[d_num,1]))
	Else
		SetColor(DropDown_Color[d_num,1])
	End If

	RectFill(DropDown_Pos[d_num,0]+1, DropDown_Pos[d_num,1]+1, DropDown_Size[d_num,0]-2, DropDown_Size[d_num,1]-2)

	Font(GUI_FONT)
	SetColor(TEXT_COLOR)
	RenderText(DROPDOWN_SELECT_IMAGE_SLOT, DropDown_Selected_Text$[d_num,0])
	Dim dw
	Dim dh
	GetImageSize(DROPDOWN_SELECT_IMAGE_SLOT, dw, dh)
	If dw >= DropDown_Size[d_num,0]-20 Then
		DrawImage_Blit(DROPDOWN_SELECT_IMAGE_SLOT, DropDown_Pos[d_num,0]+1, DropDown_Pos[d_num,1]+1, 0, 0, DropDown_Size[d_num,0]-20, DropDown_Size[d_num,1]-2)
	Else
		DrawImage(DROPDOWN_SELECT_IMAGE_SLOT, DropDown_Pos[d_num,0]+1, DropDown_Pos[d_num,1]+1)
	End If
	DeleteImage(DROPDOWN_SELECT_IMAGE_SLOT)
	SetColor(BACK_COLOR)
	Rect(DropDown_Pos[d_num,0]+DropDown_Size[d_num,0]-19, DropDown_Pos[d_num,1], 19, DropDown_Size[d_num,1])
	DrawText("V", DropDown_Pos[d_num,0]+DropDown_Size[d_num,0]-12, DropDown_Pos[d_num,1] + (DropDown_Size[d_num,1]/2)-6)


	Select Case DropDown_State[d_num]
		Case 0
			If DROPDOWN_STATE_CHANGE Then
				DROPDOWN_STATE_CHANGE = 0
				GUI_CURRENT_EVENT = 0
				'CanvasClose(CANVAS_OVERLAY)
				Canvas(CANVAS_PANEL)
				'Print "DropDown Closed"
			End If
		Case 1
			If DROPDOWN_STATE_CHANGE Then
				DROPDOWN_STATE_CHANGE = 0
				GUI_CURRENT_EVENT = EVENT_DROPDOWN_SELECT
				EVENT_ID = d_num

				'Canvas(CANVAS_OVERLAY)
				'ClearCanvas()
				'SetColor(rgb(255,0,0))
				'BoxFill(0,0, DropDown_Image_Size[d_num,0], DropDown_Image_Size[d_num,1])

				'Print "DropDown Opened: " + DropDown_Image_Size[d_num,0] + " x " + DropDown_Image_Size[d_num,1]
			End If

			Canvas(CANVAS_OVERLAY)

			SetColor(BACK_COLOR)
			Rect(0,0,DropDown_Image_Size[d_num,0],DropDown_Image_Size[d_num,1])
			SetColor(FOR_COLOR)
			RectFill(1, 1, DropDown_Image_Size[d_num,0]-2, DropDown_Image_Size[d_num,1]-2)

			SetColor(RGB(80,80,80))
			Hover_Option = DropDown_Hover_Option[d_num] - DropDown_Selected[d_num]
			Hover_X = 1
			Hover_Y = Hover_Option * 9
			Hover_W = DropDown_Image_Size[d_num,0]
			Hover_H = 9
			RectFill(Hover_X, Hover_Y, Hover_W, Hover_H)

			SetColor(RGB(255,0,0))
			Font(GUI_FONT)
			For i = 0 to 4
				If Length(DropDown_Selected_Text$[d_num,i]) > 0 Then
					DrawText(DropDown_Selected_Text$[d_num,i], 1, i * Hover_H)
				End If
			Next

			CanvasClip(DROPDOWN_IMAGE_SLOT, 0, 0, DropDown_Image_Size[d_num,0], DropDown_Image_Size[d_num,1], 1)
			Canvas(CANVAS_PANEL)
			DrawImage(DROPDOWN_IMAGE_SLOT, DropDown_Image_Pos[d_num,0], DropDown_Image_Pos[d_num,1])
			DeleteImage(DROPDOWN_IMAGE_SLOT)
			SetColor(BACK_COLOR)
			Rect(DropDown_ScrollBar_Pos[d_num,0], DropDown_ScrollBar_Pos[d_num,1], DropDown_ScrollBar_Size[d_num,0], DropDown_ScrollBar_Size[d_num,1])
			Rect(DropDown_ScrollBar_Pos[d_num,2], DropDown_ScrollBar_Pos[d_num,3], DropDown_ScrollBar_Size[d_num,0], DropDown_ScrollBar_Size[d_num,1])
			If DropDown_ScrollBar_Status[d_num,0] = STATUS_PRESS Then
				SetColor(BACK_COLOR)
			Else
				SetColor(FOR_COLOR)
			End If
			RectFill(DropDown_ScrollBar_Pos[d_num,0]+1, DropDown_ScrollBar_Pos[d_num,1]+1, DropDown_ScrollBar_Size[d_num,0]-2, DropDown_ScrollBar_Size[d_num,1]-2)
			If DropDown_ScrollBar_Status[d_num,1] = STATUS_PRESS Then
				SetColor(BACK_COLOR)
			Else
				SetColor(FOR_COLOR)
			End If
			RectFill(DropDown_ScrollBar_Pos[d_num,2]+1, DropDown_ScrollBar_Pos[d_num,3]+1, DropDown_ScrollBar_Size[d_num,0]-2, DropDown_ScrollBar_Size[d_num,1]-2)
			SetColor(RGB(10, 10, 10))
			DrawText("/\\", DropDown_ScrollBar_Pos[d_num,0]+3, DropDown_ScrollBar_Pos[d_num,1]+4)
			DrawText("\\/", DropDown_ScrollBar_Pos[d_num,2]+3, DropDown_ScrollBar_Pos[d_num,3]+8)
	End Select
	'Canvas(CANVAS_MAIN)
End Sub

Sub DrawListBox(l_num)
	Font(GUI_FONT)
	Canvas(CANVAS_OVERLAY)
	SetColor(BACK_COLOR)
	Rect(0, 0, ListBox_Size[l_num, 0], ListBox_Size[l_num, 1])
	SetColor(FOR_COLOR)
	RectFill(1, 1, ListBox_Size[l_num,0]-2, ListBox_Size[l_num,1]-2)

	SetColor(RGB(80,80,80))
	Hover_Option = ListBox_Highlight[l_num] - ListBox_Selected[l_num]
	Hover_X = 1
	Hover_Y = Hover_Option * FONT_CHAR_HEIGHT
	Hover_W = ListBox_Size[l_num,0]
	Hover_H = FONT_CHAR_HEIGHT
	RectFill(Hover_X, Hover_Y, Hover_W, Hover_H)

	SetColor(RGB(10,10,10))
	For i = 0 To ListBox_NumListed[l_num]-1
		If Length(ListBox_Selected_Text$[l_num,i]) > 0 Then
			DrawText(ListBox_Selected_Text$[l_num,i], 1, i*FONT_CHAR_HEIGHT)
		End If
	Next
	CanvasClip(LISTBOX_IMAGE_SLOT, 0, 0, ListBox_Size[l_num, 0], ListBox_Size[l_num, 1], 1)
	Canvas(CANVAS_PANEL)
	DrawImage(LISTBOX_IMAGE_SLOT, ListBox_Pos[l_num, 0], ListBox_Pos[l_num, 1])
	DeleteImage(LISTBOX_IMAGE_SLOT)

	SetColor(BACK_COLOR)
	Rect(ListBox_ScrollBar_Pos[l_num,0], ListBox_ScrollBar_Pos[l_num,1], ListBox_ScrollBar_Size[l_num,0], ListBox_ScrollBar_Size[l_num,1])
	Rect(ListBox_ScrollBar_Pos[l_num,2], ListBox_ScrollBar_Pos[l_num,3], ListBox_ScrollBar_Size[l_num,0], ListBox_ScrollBar_Size[l_num,1])
	If ListBox_ScrollBar_Status[l_num,0] = STATUS_PRESS Then
		SetColor(BACK_COLOR)
	Else
		SetColor(FOR_COLOR)
	End If
	RectFill(ListBox_ScrollBar_Pos[l_num,0]+1, ListBox_ScrollBar_Pos[l_num,1]+1, ListBox_ScrollBar_Size[l_num,0]-2, ListBox_ScrollBar_Size[l_num,1]-2)
	If ListBox_ScrollBar_Status[l_num,1] = STATUS_PRESS Then
		SetColor(BACK_COLOR)
	Else
		SetColor(FOR_COLOR)
	End If
	RectFill(ListBox_ScrollBar_Pos[l_num,2]+1, ListBox_ScrollBar_Pos[l_num,3]+1, ListBox_ScrollBar_Size[l_num,0]-2, ListBox_ScrollBar_Size[l_num,1]-2)
	SetColor(RGB(10, 10, 10))
	DrawText("/\\", ListBox_ScrollBar_Pos[l_num,0]+3, ListBox_ScrollBar_Pos[l_num,1]+4)
	DrawText("\\/", ListBox_ScrollBar_Pos[l_num,2]+3, ListBox_ScrollBar_Pos[l_num,3]+8)
End Sub

Sub DrawLabel(l_num)
	Canvas(CANVAS_PANEL)
	DrawImage(Label_Image[l_num], Label_Pos[l_num,0], Label_Pos[l_num,1])
End Sub

Sub DrawButton(b_num)
	Canvas(CANVAS_PANEL)
	SetColor(Button_Color[b_num,0])
	Rect(Button_Pos[b_num,0], Button_Pos[b_num,1], Button_Size[b_num,0], Button_Size[b_num,1])
	If Button_Status[b_num] = STATUS_PRESS Then
		SetColor(RGB(Button_Color[b_num,1] SHL 16, Button_Color[b_num,1] SHL 8, Button_Color[b_num,1]))
	Else
		SetColor(Button_Color[b_num,1])
	End If
	RectFill(Button_Pos[b_num,0]+1, Button_Pos[b_num,1]+1, Button_Size[b_num,0]-2, Button_Size[b_num,1]-2)
	Dim bw
	Dim bh
	GetImageSize(Button_Image[b_num], bw, bh)
	If bw <= Button_Size[b_num,0]-2 Then
		DrawImage(Button_Image[b_num], Button_Pos[b_num,0]+1, Button_Pos[b_num,1]+1)
	Else
		DrawImage_Blit(Button_Image[b_num], Button_Pos[b_num,0]+1, Button_Pos[b_num,1]+1, 0, 0, Button_Size[b_num,0]-2, Button_Text_Size[b_num,1]-2)
	End If
	'DrawImage_Blit_Ex(Button_Image[b_num], Button_Pos[b_num,0]+1, Button_Pos[b_num,1]+1, Button_Size[b_num,0]-2, Button_Size[b_num,1]-2, 0, 0, Button_Text_Size[b_num,0], Button_Text_Size[b_num,1])
End Sub

Sub DrawPanel(p_num)
	'CanvasOpen(CANVAS_PANEL, Panel_Scroll_Size[p_num, 0], Panel_Scroll_Size[p_num, 1], 0, 0, Panel_Scroll_Size[p_num, 0], Panel_Scroll_Size[p_num, 1], 1)
	Canvas(CANVAS_PANEL)
	SetClearColor(RGB(0,0,0))
	ClearCanvas()
	SetCanvasZ(CANVAS_PANEL, 1)
	If Panel_Widget_Count[p_num] > 0 Then
		For i = 0 to Panel_Widget_Count[p_num]-1
			Select Case Panel_Widget_Type[p_num, i]
				Case TYPE_BUTTON
					DrawButton(Panel_Widget[p_num,i])
				Case TYPE_DROPDOWN
					DrawDropDown(Panel_Widget[p_num,i])
				Case TYPE_CHECKBOX
					DrawCheckBox(Panel_Widget[p_num,i])
				Case TYPE_TEXTFIELD
					DrawTextField(Panel_Widget[p_num,i])
				Case TYPE_LISTBOX
					DrawListBox(Panel_Widget[p_num,i])
				Case TYPE_COLORSELECTOR
					DrawColorSelector(Panel_Widget[p_num,i])
				Case TYPE_BITMAPSURFACE
					DrawBitmapSurface(Panel_Widget[p_num,i])
				Case TYPE_IMAGECLIP
					DrawImageClip(Panel_Widget[p_num,i])
				Case TYPE_LABEL
					DrawLabel(Panel_Widget[p_num,i])
			End Select
		Next
	End If
	CanvasClip(PANEL_IMAGE, Panel_Scroll[p_num,0], Panel_Scroll[p_num,1], Panel_Size[p_num,0], Panel_Size[p_num,1], 1)
	ColorKey(PANEL_IMAGE, 0)
	'CanvasClose(CANVAS_PANEL)

	Canvas(CANVAS_MAIN)

	SetColor(Panel_Color[p_num,0])
	Rect(Panel_Pos[p_num,0], Panel_Pos[p_num,1], Panel_Size[p_num,0], Panel_Size[p_num,1])
	SetColor(Panel_Color[p_num,1])
	'print "dude"
	RectFill(Panel_Pos[p_num,0]+1, Panel_Pos[p_num,1]+1, Panel_Size[p_num,0]-2, Panel_Size[p_num,1]-2)
	DrawImage(PANEL_IMAGE, Panel_Pos[p_num,0], Panel_Pos[p_num,1])
	DeleteImage(PANEL_IMAGE)
End Sub

Sub Gui_ScrollPanel(p_id, x, y)
	p_num = -1
	For i = 0 to MAX_PANELS-1
		If Panel_Id[i] = p_id Then
			p_num = i
			Exit For
		End If
	Next
	If p_num = -1 Then
		Return
	End If
	If x > 0 And (Panel_Scroll[p_num,0] + x) <= Panel_Scroll_Size[p_num,0] - Panel_Size[p_num,0] Then
		Panel_Scroll[p_num,0] = Panel_Scroll[p_num,0] + x
	ElseIf x < 0 And (Panel_Scroll[p_num,0] + x) >= 0 Then
		Panel_Scroll[p_num,0] = Panel_Scroll[p_num,0] + x
	End If
	If y > 0 And (Panel_Scroll[p_num,1] + y) <= Panel_Scroll_Size[p_num,1] - Panel_Size[p_num,1] Then
		Panel_Scroll[p_num,1] = Panel_Scroll[p_num,1] + y
	ElseIf y < 0 And (Panel_Scroll[p_num,1] + y)  >= 0 Then
		Panel_Scroll[p_num,1] = Panel_Scroll[p_num,1] + y
	End If
End Sub

Function MouseOnItem(p_num, item_type, item_num, x, y)
	Select Case item_type
		Case TYPE_BUTTON
			If Button_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+Button_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+Button_Pos[item_num,0]+Button_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+Button_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+Button_Pos[item_num,1]+Button_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_DROPDOWN
			If DropDown_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+DropDown_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+DropDown_Pos[item_num,0]+DropDown_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+DropDown_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+DropDown_Pos[item_num,1]+DropDown_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_DROPDOWN_SCROLLUP
			If DropDown_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+DropDown_ScrollBar_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+DropDown_ScrollBar_Pos[item_num,0]+DropDown_ScrollBar_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+DropDown_ScrollBar_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+DropDown_ScrollBar_Pos[item_num,1]+DropDown_ScrollBar_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_DROPDOWN_SCROLLDOWN
			If DropDown_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+DropDown_ScrollBar_Pos[item_num,2]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+DropDown_ScrollBar_Pos[item_num,2]+DropDown_ScrollBar_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+DropDown_ScrollBar_Pos[item_num,3]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+DropDown_ScrollBar_Pos[item_num,3]+DropDown_ScrollBar_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_DROPDOWN_OPTION
			If DropDown_Panel[item_num] <> p_num Then
				Return False
			End If
			Option_X = (Panel_Pos[p_num,0] + DropDown_Image_Pos[item_num,0]) - Panel_Scroll[p_num,0]
			Option_Y = (Panel_Pos[p_num,1] + DropDown_Image_Pos[item_num,1]) - Panel_Scroll[p_num,1]
			Option_W = DropDown_Image_Size[item_num,0]
			For i = 0 to 4
				If x >= Option_X And x < Option_X + Option_W Then
					If y >= Option_Y + (i*9) And y < Option_Y + (i*9) + 9 Then
						DropDown_Hover_Option[item_num] = DropDown_Selected[item_num] + i
						Return True
					End If
				End If
			Next
			Return False
		Case TYPE_LISTBOX
			If ListBox_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+ListBox_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+ListBox_Pos[item_num,0]+ListBox_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+ListBox_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+ListBox_Pos[item_num,1]+ListBox_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_LISTBOX_OPTION
			If ListBox_Panel[item_num] <> p_num Then
				Return False
			End If
			Option_X = (Panel_Pos[p_num,0] + ListBox_Pos[item_num,0]) - Panel_Scroll[p_num,0]
			Option_Y = (Panel_Pos[p_num,1] + ListBox_Pos[item_num,1]) - Panel_Scroll[p_num,1]
			Option_W = ListBox_Size[item_num,0]
			For i = 0 to ListBox_NumListed[item_num]-1
				If x >= Option_X And x < Option_X + Option_W Then
					If y >= Option_Y + (i*FONT_CHAR_HEIGHT) And y < Option_Y + (i*FONT_CHAR_HEIGHT) + FONT_CHAR_HEIGHT Then
						ListBox_Hover_Option[item_num] = ListBox_Selected[item_num] + i
						Return True
					End If
				End If
			Next
			Return False
		Case TYPE_LISTBOX_SCROLLUP
			If ListBox_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+ListBox_ScrollBar_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+ListBox_ScrollBar_Pos[item_num,0]+ListBox_ScrollBar_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+ListBox_ScrollBar_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+ListBox_ScrollBar_Pos[item_num,1]+ListBox_ScrollBar_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_LISTBOX_SCROLLDOWN
			If ListBox_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+ListBox_ScrollBar_Pos[item_num,2]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+ListBox_ScrollBar_Pos[item_num,2]+ListBox_ScrollBar_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+ListBox_ScrollBar_Pos[item_num,3]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+ListBox_ScrollBar_Pos[item_num,3]+ListBox_ScrollBar_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_CHECKBOX
			If CheckBox_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+CheckBox_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+CheckBox_Pos[item_num,0]+CheckBox_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+CheckBox_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+CheckBox_Pos[item_num,1]+CheckBox_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_TEXTFIELD
			If TextField_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+TextField_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+TextField_Pos[item_num,0]+TextField_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+TextField_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+TextField_Pos[item_num,1]+TextField_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_COLORSELECTOR
			If ColorSelector_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+ColorSelector_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+ColorSelector_Pos[item_num,0]+ColorSelector_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+ColorSelector_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+ColorSelector_Pos[item_num,1]+ColorSelector_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_BITMAPSURFACE
			If BitmapSurface_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= Panel_Pos[p_num,0] And x < Panel_Pos[p_num,0] + Panel_Size[p_num,0] And y >= Panel_Pos[p_num,1] And y < Panel_Pos[p_num,1] + Panel_Size[p_num,1] Then
				BitmapSurface_Mouse[item_num,0] = (x - Panel_Pos[p_num,0]) + Panel_Scroll[p_num,0]
				BitmapSurface_Mouse[item_num,1] = (y - Panel_Pos[p_num,1]) + Panel_Scroll[p_num,1]
				Return True
			Else
				BitmapSurface_Mouse[item_num,0] = -1
				BitmapSurface_Mouse[item_num,1] = -1
				Return False
			End If
		Case TYPE_BITMAPSURFACE_SCROLLUP
			If BitmapSurface_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,0]+BitmapSurface_ScrollBar_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,1]+BitmapSurface_ScrollBar_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_BITMAPSURFACE_SCROLLDOWN
			If BitmapSurface_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,2]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,2]+BitmapSurface_ScrollBar_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,3]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,3]+BitmapSurface_ScrollBar_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_BITMAPSURFACE_SCROLLLEFT
			If BitmapSurface_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,4]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,4]+BitmapSurface_ScrollBar_Size[item_num,2]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,5]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,5]+BitmapSurface_ScrollBar_Size[item_num,3]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_BITMAPSURFACE_SCROLLRIGHT
			If BitmapSurface_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,6]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+BitmapSurface_ScrollBar_Pos[item_num,6]+BitmapSurface_ScrollBar_Size[item_num,2]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,7]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+BitmapSurface_ScrollBar_Pos[item_num,7]+BitmapSurface_ScrollBar_Size[item_num,3]) - Panel_Scroll[p_num,1] Then
				Return True
			Else
				Return False
			End If
		Case TYPE_IMAGECLIP
			If ImageClip_Panel[item_num] <> p_num Then
				Return False
			End If
			If x >= (Panel_Pos[p_num,0]+ImageClip_Pos[item_num,0]) - Panel_Scroll[p_num,0] And x < (Panel_Pos[p_num,0]+ImageClip_Pos[item_num,0]+ImageClip_Size[item_num,0]) - Panel_Scroll[p_num,0] And y >= (Panel_Pos[p_num,1]+ImageClip_Pos[item_num,1]) - Panel_Scroll[p_num,1] And y < (Panel_Pos[p_num,1]+ImageClip_Pos[item_num,1]+ImageClip_Size[item_num,1]) - Panel_Scroll[p_num,1] Then
				ImageClip_Mouse[item_num,0] = x - ((Panel_Pos[p_num,0]+ImageClip_Pos[item_num,0]) - Panel_Scroll[p_num,0])
				ImageClip_Mouse[item_num,1] = y - ((Panel_Pos[p_num,1]+ImageClip_Pos[item_num,1]) - Panel_Scroll[p_num,1])
				Return True
			Else
				ImageClip_Mouse[item_num,0] = -1
				ImageClip_Mouse[item_num,1] = -1
				Return False
			End If
		Default
			Return False
	End Select
	Return False
End Function

Function Gui_Button_Clicked(id)
	If Button_Event = id Then
		Return True
	Else
		Return False
	End If
End Function

Function Gui_Button_Pressed(id)
	b_num = -1
	For i = 0 to NumButtons-1
		If Button_Id[i] = id Then
			b_num = i
			Exit For
		End If
	Next
	If b_num = -1 Then
		Return False
	End If
	If Button_Status[b_num] = STATUS_PRESS Then
		Return True
	Else
		Return False
	End If
End Function

Function Gui_DropDown_GetSelection(id)
	For i = 0 To NumDropDowns-1
		If DropDown_Id[i] = id Then
			Return DropDown_Selected[i]
		End If
	Next
	Return -1
End Function

Function Gui_DropDown_GetSelectionText$(id)
	For i = 0 To NumDropDowns-1
		If DropDown_Id[i] = id Then
			Return DropDown_Selected_Text$[i,0]
		End If
	Next
	Return ""
End Function

Sub Gui_DropDown_SetOptions(id, options$)
	n = 0
	d_num = -1
	For i = 0 to NumDropDowns-1
		If DropDown_Id[i] = id Then
			d_num = i
			Exit For
		End If
	Next
	If d_num = -1 Then
		Return
	End If
	DropDown_Options$[d_num] = options$
	n = 0
	For i = 0 to Length(options$)
		If Mid$(options$, i, 1) = ";" Then
			n = n + 1
		End If
	Next
	DropDown_NumOptions[d_num] = n
	SelectDropDownOption(d_num, DropDown_Selected[d_num])
End Sub

Sub Gui_DropDown_SetSelection(id, opt_num)
	d_num = -1
	For i = 0 to NumDropDowns-1
		If DropDown_Id[i] = id Then
			d_num = i
			Exit For
		End If
	Next
	If d_num = -1 Then
		Return
	End If
	SelectDropDownOption(d_num, opt_num)
End Sub

Sub Gui_DropDown_AddOption(id, option$)
	d_num = -1
	For i = 0 to NumDropDowns-1
		If DropDown_Id[i] = id Then
			d_num = i
			Exit For
		End If
	Next
	If d_num = -1 Then
		Return
	End If
	n = 0
	end_char = False
	For i = 0 To Length(option$)-1
		If Mid$(option$, i, 1) = ";" Then
			n = n + 1
		ElseIf i = Length(option$)-1 Then
			n = n + 1
			end_char = True
		End If
	Next
	DropDown_NumOptions[d_num] = DropDown_NumOptions[d_num] + n
	DropDown_Options$[d_num] = DropDown_Options$[d_num] + option$
	If end_char Then
		DropDown_Options$[d_num] = DropDown_Options$[d_num] + ";"
	End If
	SelectDropDownOption(d_num, DropDown_Selected[d_num])
End Sub

Function Gui_ListBox_GetSelection(id)
	For i = 0 To NumListBoxes-1
		If ListBox_Id[i] = id Then
			Return ListBox_Highlight[i]
		End If
	Next
	Return -1
End Function

Function Gui_ListBox_GetSelectionText$(id)
	For i = 0 To NumListBoxes-1
		If ListBox_Id[i] = id Then
			Return ListBox_Highlight_Text$[i]
		End If
	Next
	Return ""
End Function

Sub Gui_ListBox_SetOptions(id, options$)
	n = 0
	d_num = -1
	For i = 0 to NumListBoxes-1
		If ListBox_Id[i] = id Then
			d_num = i
			Exit For
		End If
	Next
	If d_num = -1 Then
		Return
	End If
	ListBox_Options$[d_num] = options$
	n = 0
	For i = 0 to Length(options$)
		If Mid$(options$, i, 1) = ";" Then
			n = n + 1
		End If
	Next
	ListBox_NumOptions[d_num] = n
	SelectListBoxOption(d_num, ListBox_Selected[d_num])
End Sub

Sub Gui_ListBox_SetSelection(id, opt_num)
	d_num = -1
	For i = 0 to NumListBoxes-1
		If ListBox_Id[i] = id Then
			d_num = i
			Exit For
		End If
	Next
	If d_num = -1 Then
		Return
	End If
	SelectListBoxOption(d_num, opt_num)
End Sub

Sub Gui_ListBox_AddOption(id, option$)
	d_num = -1
	For i = 0 to NumListBoxes-1
		If ListBox_Id[i] = id Then
			d_num = i
			Exit For
		End If
	Next
	If d_num = -1 Then
		Return
	End If

	'Print "!!!!!" + ListBox_Options[d_num]
	Gui_ListBox_SetOptions(id, ListBox_Options$[d_num] + option$)
	Return

	n = 0
	end_char = False
	For i = 0 To Length(option$)-1
		If Mid$(option$, i, 1) = ";" Then
			n = n + 1
		ElseIf i = Length(option$)-1 Then
			n = n + 1
			end_char = True
		End If
	Next
	ListBox_NumOptions[d_num] = ListBox_NumOptions[d_num] + n
	ListBox_Options$[d_num] = ListBox_Options$[d_num] + option$
	If end_char Then
		ListBox_Options$[d_num] = ListBox_Options$[d_num] + ";"
	End If
	SelectListBoxOption(d_num, ListBox_Selected[d_num])
End Sub

Function Gui_TextField_GetText$(id)
	If NumTextFields > 0 Then
		For i = 0 To NumTextFields-1
			If TextField_Id[i] = id Then
				Return TextField_Text$[i]
			End If
		Next
	End If
	Return ""
End Function

Sub Gui_TextField_SetText(id, text$)
	For i = 0 To NumTextFields-1
		If TextField_Id[i] = id Then
			TextField_Text$[i] = text$
		End If
	Next
End Sub

Function Gui_ColorSelector_GetColor(id)
	For i = 0 to NumColorSelectors-1
		If ColorSelector_Id[i] = id Then
			Return ColorSelector_Selected[i]
		End If
	Next
	Return 0
End Function

Sub Gui_ColorSelector_SetColor(id, index, color)
	For i = 0 to NumColorSelectors-1
		If ColorSelector_Id[i] = id And index >= 0 And index < 8 Then
			ColorSelector_Color[i, index] = color
			ColorSelector_SetColors_Image(i)
		End If
	Next
End Sub

Sub Gui_BitmapSurface_GetMouse(id, ByRef x, ByRef y)
	b_num = -1
	For i = 0 To NumBitmapSurfaces-1
		If BitmapSurface_Id[i] = id Then
			b_num = i
			Exit For
		End If
	Next
	If b_num = -1 Then
		x = -1
		y = -1
		Return
	End If
	x = BitmapSurface_Mouse[b_num,0]
	y = BitmapSurface_Mouse[b_num,1]
End Sub

Function Gui_BitmapSurface_Clicked(id)
	For i = 0 to NumBitmapSurfaces-1
		If BitmapSurface_Id[i] = id And BitmapSurface_Status[i] = STATUS_RELEASE Then
			Return True
		End If
	Next
	Return False
End Function

Function Gui_BitmapSurface_GetActive()
	If Active_BitmapSurface <> -1 Then
		Return BitmapSurface_Id[Active_BitmapSurface]
	Else
		Return -1
	End If
End Function

Sub Gui_BitmapSurface_Clear()
	If Active_BitmapSurface <> -1 Then
		'Clear = 1
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 1
			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawImage(image, x, y)
	If Active_BitmapSurface <> -1 Then
		'DrawImage = 2
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 2
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = image
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = y
			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_Blit(image, x, y, src_x, src_y, src_w, src_h)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 3
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = image
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = y
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,3] = src_x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,4] = src_y
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,5] = src_w
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,6] = src_h

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_SetFont(f_num)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 4
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = f_num

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawText(text$, x, y)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 5
			BitmapSurface_Arg_s[BitmapSurface_NumCommands,0] = text$
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawPixel(x, y)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 6
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawLine(x1, y1, x2, y2)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 7
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x1
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y1
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = x2
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,3] = y2

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawRect(x, y, w, h)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 8
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = w
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,3] = h

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawRectFill(x, y, w, h)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 9
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = w
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,3] = h

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_FloodFill(x, y)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 10
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawCircle(x, y, r)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 11
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = r

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_DrawCircleFill(x, y, r)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 12
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = y
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = r

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_Grab(image, x, y, w, h)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 13
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = image
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,1] = x
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,2] = y
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,3] = w
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,4] = h

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapSurface_SetColor(color)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface_NumCommands < 100 Then
			BitmapSurface_DrawCommand[BitmapSurface_NumCommands] = 14
			BitmapSurface_Arg_n[BitmapSurface_NumCommands,0] = color

			BitmapSurface_NumCommands = BitmapSurface_NumCommands + 1
		End If
	End If
End Sub


'''''''''''''''
Sub Gui_BitmapOverlay_Clear()
	If Active_BitmapSurface <> -1 Then
		'Clear = 1
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 1
			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawImage(image, x, y)
	If Active_BitmapSurface <> -1 Then
		'DrawImage = 2
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 2
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = image
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,2] = y
			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_Blit(image, x, y, src_x, src_y, src_w, src_h)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 3
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = image
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,2] = y
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,3] = src_x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,4] = src_y
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,5] = src_w
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,6] = src_h

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_SetFont(f_num)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 4
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = f_num

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawText(text$, x, y)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 5
			BitmapSurface2_Arg_s[BitmapSurface2_NumCommands,0] = text$
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawPixel(x, y)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 6
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawLine(x1, y1, x2, y2)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 7
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x1
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y1
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,2] = x2
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,3] = y2

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawRect(x, y, w, h)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 8
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,2] = w
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,3] = h

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawRectFill(x, y, w, h)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 9
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,2] = w
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,3] = h

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_FloodFill(x, y)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 10
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawCircle(x, y, r)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 11
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,2] = r

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_DrawCircleFill(x, y, r)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 12
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = x
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,1] = y
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,2] = r

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

Sub Gui_BitmapOverlay_SetColor(color)
	If Active_BitmapSurface <> -1 Then
		'Blit = 3
		If BitmapSurface2_NumCommands < 100 Then
			BitmapSurface2_DrawCommand[BitmapSurface2_NumCommands] = 14
			BitmapSurface2_Arg_n[BitmapSurface2_NumCommands,0] = color

			BitmapSurface2_NumCommands = BitmapSurface2_NumCommands + 1
		End If
	End If
End Sub

'''''''''''''''

Function Gui_CheckBox_GetState(id)
	For i = 0 To NumCheckBoxes-1
		If CheckBox_Id[i] = id Then
			Return CheckBox_State[i]
		End If
	Next
	Return 0
End Function

Sub Gui_CheckBox_SetState(id, state)
	For i = 0 To NumCheckBoxes-1
		If CheckBox_Id[i] = id Then
			If state = 0 Then
				CheckBox_State[i] = 0
			Else
				CheckBox_State[i] = 1
			End If
		End If
	Next
End Sub

Sub ClearStatus(p_num)
	If Panel_Widget_Count[p_num] > 0 Then
		For i = 0 to Panel_Widget_Count[p_num]-1
			Select Case Panel_Widget_Type[p_num,i]
				Case TYPE_BUTTON
					Button_Status[Panel_Widget[p_num,i]] = STATUS_NULL
				Case TYPE_DROPDOWN
				Case TYPE_TEXTFIELD
				Case TYPE_CHECKBOX
				Case TYPE_LISTBOX
			End Select
		Next
	End If
End Sub

Function Gui_GetActivePanel()
	If Active_Panel > 0 Then
		Return Panel_Id[Active_Panel]
	Else
		Return 0
	End If
End Function

Function Gui_GetActiveWindow()
	Return CurrentWindow
End Function

Sub Gui_GetMouse(win_num, ByRef x, ByRef y, ByRef mbutton1, ByRef mButton2, ByRef mButton3)
	If win_num <> -1 Then
		x = GuiWindow_Mouse[win_num, 0]
		y = GuiWindow_Mouse[win_num, 1]
		mbutton1 = GuiWindow_Mouse[win_num, 2]
		mbutton2 = GuiWindow_Mouse[win_num, 3]
		mbutton3 = GuiWindow_Mouse[win_num, 4]
	Else
		x = -1
		y = -1
		mbutton1 = -1
		mbutton2 = -1
		mbutton3 = -1
	End If
End Sub

Sub Gui_GetEvents()
	Button_Event = -1
	ImageClip_Event = -1

	Last_Panel = Active_Panel
	EventWindow = GetFocusWindow()
	If EventWindow <> CurrentWindow Then
		'Window(EventWindow)
		CurrentWindow = EventWindow
		Active_Panel = -1
	End If
	'For i = 0 to 7
	'	If GuiWindow_isOpen[i] Then
	'		If WindowHasMouseFocus(i) Then
	'			Window(i)
	'			Exit For
	'		End If
	'	End If
	'Next

	Dim mouse_x
	Dim mouse_y
	Dim mouse_button1
	Dim mouse_button2
	Dim mouse_button3
	GetMouse(mouse_x, mouse_y, mouse_button1, mouse_button2, mouse_button3)
	For i = 0 To 7
		GuiWindow_Mouse[i,0] = -1
		GuiWindow_Mouse[i,1] = -1
		GuiWindow_Mouse[i,2] = -1
		GuiWindow_Mouse[i,3] = -1
		GuiWindow_Mouse[i,4] = -1
	Next
	If EventWindow <> -1 Then
		GuiWindow_Mouse[EventWindow,0] = mouse_x
		GuiWindow_Mouse[EventWindow,1] = mouse_y
		GuiWindow_Mouse[EventWindow,2] = mouse_button1
		GuiWindow_Mouse[EventWindow,3] = mouse_button2
		GuiWindow_Mouse[EventWindow,4] = mouse_button3
	End If
	For i = 0 to MAX_PANELS-1
		If Panel_Window[i] = EventWindow Then
			If mouse_x >= Panel_Pos[i,0] And mouse_x < Panel_Pos[i,0] + Panel_Size[i,0] And mouse_y >= Panel_Pos[i,1] And mouse_y < Panel_Pos[i,1] + Panel_Size[i,1] Then
				Active_Panel = i
				Exit For
			End If
		End If
	Next
	If Last_Panel <> Active_Panel And Last_Panel >= 0 Then
		ClearStatus(Last_Panel)
	End If

	'Start here
	If Active_Panel <> (-1) Then
		'TextFields
		If NumTextFields > 0 Then
			For i = 0 to NumTextFields-1
				Select Case TextField_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_TEXTFIELD, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								TextField_Status[i] = STATUS_PRESS
							Else
								TextField_Status[i] = STATUS_HOVER
							End If
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_TEXTFIELD, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								TextField_Status[i] = STATUS_PRESS
							End If
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_TEXTFIELD, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If Not mouse_button1 Then
								TextField_Status[i] = STATUS_RELEASE
								TextField_State[i] = 1
								ACTIVE_TEXTFIELD_PANEL = Active_Panel
								ACTIVE_TEXTFIELD = i
								ReadInput_Start()
								ReadInput_SetText(TextField_Text$[i])
							End If
						Else
							TextField_Status[i] = STATUS_NULL
						End If
					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_TEXTFIELD, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								TextField_Status[i] = STATUS_PRESS
							Else
								TextField_Status[i] = STATUS_HOVER
							End If
						Else
							TextField_Status[i] = STATUS_NULL
						End If
				End Select
				If ACTIVE_TEXTFIELD = i Then
					If (Not MouseOnItem(ACTIVE_TEXTFIELD_PANEL, TYPE_TEXTFIELD, i, mouse_x, mouse_y)) And mouse_button1 Then
						TextField_State[i] = 0
						ACTIVE_TEXTFIELD = -1
						ACTIVE_TEXTFIELD_PANEL = -1
						ReadInput_Stop()
					Else
						TextField_Text$[i] = ReadInput_Text$()
					End If
				End If
			Next
		End If

		'Button Events
		If NumButtons > 0 Then
			For i = 0 to NumButtons-1
				Select Case Button_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_BUTTON, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								Button_Status[i] = STATUS_PRESS
							Else
								Button_Status[i] = STATUS_HOVER
							End If
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_BUTTON, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								Button_Status[i] = STATUS_PRESS
							End If
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_BUTTON, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If Not mouse_button1 Then
								Button_Status[i] = STATUS_RELEASE
								Button_Event = Button_Id[i]
							End If
						Else
							Button_Status[i] = STATUS_NULL
						End If
					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_BUTTON, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								Button_Status[i] = STATUS_PRESS
							Else
								Button_Status[i] = STATUS_HOVER
							End If
						Else
							Button_Status[i] = STATUS_NULL
						End If
				End Select
			Next
		End If

		'DropDown Events
		If NumDropDowns > 0 Then
			For i = 0 to NumDropDowns-1
				Select Case DropDown_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_DROPDOWN, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								DropDown_Status[i] = STATUS_PRESS
							Else
								DropDown_Status[i] = STATUS_HOVER
							End If
						End If

						If DropDown_State[i] Then
							If MouseOnItem(Active_Panel, TYPE_DROPDOWN_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
								SelectDropDownOption(i, DropDown_Hover_Option[i])
								DropDown_Status[i] = STATUS_NULL
								DROPDOWN_STATE_CHANGE = 1
								DropDown_State[i] = 0
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLUP, i, mouse_x, mouse_y) And mouse_button1 Then
								DropDown_ScrollBar_Status[i,0] = STATUS_PRESS
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLDOWN, i, mouse_x, mouse_y) And mouse_button1 Then
								DropDown_ScrollBar_Status[i,1] = STATUS_PRESS
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLUP, i, mouse_x, mouse_y) And (Not mouse_button1) Then
								If DropDown_ScrollBar_Status[i,0] = STATUS_PRESS Then
									DropDown_ScrollBar_Status[i,0] = STATUS_RELEASE
									SelectDropDownOption(i, DropDown_Selected[i] - 1)
									'Print "UP"
								Else
									DropDown_ScrollBar_Status[i,0] = STATUS_NULL
								End If
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLDOWN, i, mouse_x, mouse_y) And (Not mouse_button1) Then
								If DropDown_ScrollBar_Status[i,1] = STATUS_PRESS Then
									DropDown_ScrollBar_Status[i,1] = STATUS_RELEASE
									SelectDropDownOption(i, DropDown_Selected[i] + 1)
									'Print "Down"
								Else
									DropDown_ScrollBar_Status[i,1] = STATUS_NULL
								End If
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
							Else
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							End If
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_DROPDOWN, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								DropDown_Status[i] = STATUS_PRESS
							End If
						End If

						If DropDown_State[i] Then
							If MouseOnItem(Active_Panel, TYPE_DROPDOWN_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
								SelectDropDownOption(i, DropDown_Hover_Option[i])
								DropDown_Status[i] = STATUS_NULL
								DROPDOWN_STATE_CHANGE = 1
								DropDown_State[i] = 0
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLUP, i, mouse_x, mouse_y) And mouse_button1 Then
								DropDown_ScrollBar_Status[i,0] = STATUS_PRESS
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLDOWN, i, mouse_x, mouse_y) And mouse_button1 Then
								DropDown_ScrollBar_Status[i,1] = STATUS_PRESS
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLUP, i, mouse_x, mouse_y) And (Not mouse_button1) Then
								If DropDown_ScrollBar_Status[i,0] = STATUS_PRESS Then
									DropDown_ScrollBar_Status[i,0] = STATUS_RELEASE
									SelectDropDownOption(i, DropDown_Selected[i] - 1)
									'Print "UP"
								Else
									DropDown_ScrollBar_Status[i,0] = STATUS_NULL
								End If
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLDOWN, i, mouse_x, mouse_y) And (Not mouse_button1) Then
								If DropDown_ScrollBar_Status[i,1] = STATUS_PRESS Then
									DropDown_ScrollBar_Status[i,1] = STATUS_RELEASE
									SelectDropDownOption(i, DropDown_Selected[i] + 1)
									'Print "Down"
								Else
									DropDown_ScrollBar_Status[i,1] = STATUS_NULL
								End If
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
							Else
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							End If
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_DROPDOWN, i, mouse_x, mouse_y) Then
							If Not mouse_button1 Then
								DropDown_Status[i] = STATUS_RELEASE
								DropDown_State[i] = Not DropDown_State[i]
								DROPDOWN_STATE_CHANGE = 1
							End If
						Else
							DropDown_Status[i] = STATUS_NULL
						End If

						If DropDown_State[i] Then
							If MouseOnItem(Active_Panel, TYPE_DROPDOWN_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
								SelectDropDownOption(i, DropDown_Hover_Option[i])
								DropDown_Status[i] = STATUS_NULL
								DROPDOWN_STATE_CHANGE = 1
								DropDown_State[i] = 0
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLUP, i, mouse_x, mouse_y) And (Not mouse_button1) Then
								DropDown_ScrollBar_Status[i,0] = STATUS_RELEASE
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
								SelectDropDownOption(i, DropDown_Selected[i] - 1)
								'Print "Press UP"
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLDOWN, i, mouse_x, mouse_y) And (Not mouse_button1) Then
								DropDown_ScrollBar_Status[i,1] = STATUS_RELEASE
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
								SelectDropDownOption(i, DropDown_Selected[i] + 1)
							Else
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							End If
						End If
					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_DROPDOWN, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								DropDown_Status[i] = STATUS_PRESS
							Else
								DropDown_Status[i] = STATUS_HOVER
							End If
						Else
							DropDown_Status[i] = STATUS_NULL
						End If

						If DropDown_State[i] Then
							If MouseOnItem(Active_Panel, TYPE_DROPDOWN_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
								SelectDropDownOption(i, DropDown_Hover_Option[i])
								DropDown_Status[i] = STATUS_NULL
								DROPDOWN_STATE_CHANGE = 1
								DropDown_State[i] = 0
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLUP, i, mouse_x, mouse_y) And mouse_button1 Then
								DropDown_ScrollBar_Status[i,0] = STATUS_PRESS
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
								'Print "Release UP"
							ElseIf MouseOnItem(Active_Panel, TYPE_DROPDOWN_SCROLLDOWN, i, mouse_x, mouse_y) And mouse_button1 Then
								DropDown_ScrollBar_Status[i,1] = STATUS_PRESS
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
							Else
								DropDown_ScrollBar_Status[i,0] = STATUS_NULL
								DropDown_ScrollBar_Status[i,1] = STATUS_NULL
							End If
						End If
				End Select
			Next
		End If

		'ListBox Events
		If NumListBoxes > 0 Then
			For i = 0 to NumListBoxes-1
				Select Case ListBox_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_LISTBOX_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
							'SelectListBoxOption(i, ListBox_Hover_Option[i])
							ListBox_Highlight[i] = ListBox_Hover_Option[i]
							ListBox_Highlight_Text$[i] = ListBox_Selected_Text$[i, ListBox_Highlight[i] - ListBox_Selected[i]]
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLUP, i, mouse_x, mouse_y) And mouse_button1 Then
							ListBox_ScrollBar_Status[i,0] = STATUS_PRESS
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLDOWN, i, mouse_x, mouse_y) And mouse_button1 Then
							ListBox_ScrollBar_Status[i,1] = STATUS_PRESS
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLUP, i, mouse_x, mouse_y) And (Not mouse_button1) Then
							If ListBox_ScrollBar_Status[i,0] = STATUS_PRESS Then
								ListBox_ScrollBar_Status[i,0] = STATUS_RELEASE
								SelectListBoxOption(i, ListBox_Selected[i] - 1)
								'Print "UP"
							Else
								ListBox_ScrollBar_Status[i,0] = STATUS_NULL
							End If
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLDOWN, i, mouse_x, mouse_y) And (Not mouse_button1) Then
							If ListBox_ScrollBar_Status[i,1] = STATUS_PRESS Then
								ListBox_ScrollBar_Status[i,1] = STATUS_RELEASE
								SelectListBoxOption(i, ListBox_Selected[i] + 1)
								'Print "Down"
							Else
								ListBox_ScrollBar_Status[i,1] = STATUS_NULL
							End If
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
						Else
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_LISTBOX, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ListBox_Status[i] = STATUS_PRESS
							End If
						End If

						If MouseOnItem(Active_Panel, TYPE_LISTBOX_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
							'SelectListBoxOption(i, ListBox_Hover_Option[i])
							ListBox_Highlight[i] = ListBox_Hover_Option[i]
							ListBox_Highlight_Text$[i] = ListBox_Selected_Text$[i, ListBox_Highlight[i] - ListBox_Selected[i]]
							ListBox_Status[i] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLUP, i, mouse_x, mouse_y) And mouse_button1 Then
							ListBox_ScrollBar_Status[i,0] = STATUS_PRESS
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLDOWN, i, mouse_x, mouse_y) And mouse_button1 Then
							ListBox_ScrollBar_Status[i,1] = STATUS_PRESS
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLUP, i, mouse_x, mouse_y) And (Not mouse_button1) Then
							If ListBox_ScrollBar_Status[i,0] = STATUS_PRESS Then
								ListBox_ScrollBar_Status[i,0] = STATUS_RELEASE
								SelectListBoxOption(i, ListBox_Selected[i] - 1)
								'Print "UP"
							Else
								ListBox_ScrollBar_Status[i,0] = STATUS_NULL
							End If
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLDOWN, i, mouse_x, mouse_y) And (Not mouse_button1) Then
							If ListBox_ScrollBar_Status[i,1] = STATUS_PRESS Then
								ListBox_ScrollBar_Status[i,1] = STATUS_RELEASE
								SelectListBoxOption(i, ListBox_Selected[i] + 1)
								'Print "Down"
							Else
								ListBox_ScrollBar_Status[i,1] = STATUS_NULL
							End If
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
						Else
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_LISTBOX, i, mouse_x, mouse_y) Then
							If Not mouse_button1 Then
								ListBox_Status[i] = STATUS_RELEASE
							End If
						Else
							ListBox_Status[i] = STATUS_NULL
						End If

						If MouseOnItem(Active_Panel, TYPE_LISTBOX_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
							'SelectListBoxOption(i, ListBox_Hover_Option[i])
							ListBox_Highlight[i] = ListBox_Hover_Option[i]
							ListBox_Highlight_Text$[i] = ListBox_Selected_Text$[i, ListBox_Highlight[i] - ListBox_Selected[i]]
							ListBox_Status[i] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLUP, i, mouse_x, mouse_y) And (Not mouse_button1) Then
							ListBox_ScrollBar_Status[i,0] = STATUS_RELEASE
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
							SelectListBoxOption(i, ListBox_Selected[i] - 1)
							'Print "Press UP"
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLDOWN, i, mouse_x, mouse_y) And (Not mouse_button1) Then
							ListBox_ScrollBar_Status[i,1] = STATUS_RELEASE
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
							SelectListBoxOption(i, ListBox_Selected[i] + 1)
						Else
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						End If
					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_LISTBOX, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ListBox_Status[i] = STATUS_PRESS
							Else
								ListBox_Status[i] = STATUS_HOVER
							End If
						Else
							ListBox_Status[i] = STATUS_NULL
						End If

						If MouseOnItem(Active_Panel, TYPE_LISTBOX_OPTION, i, mouse_x, mouse_y) and mouse_button1 Then
							'SelectListBoxOption(i, ListBox_Hover_Option[i])
							ListBox_Highlight[i] = ListBox_Hover_Option[i]
							ListBox_Highlight_Text$[i] = ListBox_Selected_Text$[i, ListBox_Highlight[i] - ListBox_Selected[i]]
							ListBox_Status[i] = STATUS_NULL
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLUP, i, mouse_x, mouse_y) And mouse_button1 Then
							ListBox_ScrollBar_Status[i,0] = STATUS_PRESS
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
							'Print "Release UP"
						ElseIf MouseOnItem(Active_Panel, TYPE_LISTBOX_SCROLLDOWN, i, mouse_x, mouse_y) And mouse_button1 Then
							ListBox_ScrollBar_Status[i,1] = STATUS_PRESS
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
						Else
							ListBox_ScrollBar_Status[i,0] = STATUS_NULL
							ListBox_ScrollBar_Status[i,1] = STATUS_NULL
						End If
				End Select
			Next
		End If

		Last_Active_BitmapSurface = Active_BitmapSurface

		'BitmapSurfaces
		If NumBitmapSurfaces > 0 Then
			For i = 0 to NumBitmapSurfaces-1
				Select Case BitmapSurface_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_BITMAPSURFACE, i, mouse_x, mouse_y) Then
							Active_BitmapSurface = i
							If mouse_button1 Then
								BitmapSurface_Status[i] = STATUS_PRESS
								BitmapSurface_Event = BitmapSurface_Id[i]
							End If
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_BITMAPSURFACE, i, mouse_x, mouse_y) Then
							Active_BitmapSurface = i
							If mouse_button1 Then
								BitmapSurface_Status[i] = STATUS_PRESS
							End If
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_BITMAPSURFACE, i, mouse_x, mouse_y) Then
							If Not mouse_button1 Then
								BitmapSurface_Status[i] = STATUS_RELEASE
								BitmapSurface_Event = BitmapSurface_Id[i]
							End If
						Else
							BitmapSurface_Status[i] = STATUS_NULL
						End If

					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_BITMAPSURFACE, i, mouse_x, mouse_y) Then
							Active_BitmapSurface = i
							If mouse_button1 Then
								BitmapSurface_Status[i] = STATUS_PRESS
							Else
								BitmapSurface_Status[i] = STATUS_HOVER
							End If
						Else
							BitmapSurface_Status[i] = STATUS_NULL
						End If
				End Select
			Next
		End If

		'CheckBoxes
		If NumCheckBoxes > 0 Then
			For i = 0 to NumCheckBoxes-1
				Select Case CheckBox_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_CHECKBOX, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								CheckBox_Status[i] = STATUS_PRESS
							Else
								CheckBox_Status[i] = STATUS_HOVER
							End If
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_CHECKBOX, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								CheckBox_Status[i] = STATUS_PRESS
							End If
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_CHECKBOX, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If Not mouse_button1 Then
								CheckBox_Status[i] = STATUS_RELEASE
								CheckBox_State[i] = Not CheckBox_State[i]
							End If
						Else
							CheckBox_Status[i] = STATUS_NULL
						End If
					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_CHECKBOX, i, mouse_x, mouse_y) And GUI_CURRENT_EVENT = 0 Then
							If mouse_button1 Then
								CheckBox_Status[i] = STATUS_PRESS
							Else
								CheckBox_Status[i] = STATUS_HOVER
							End If
						Else
							CheckBox_Status[i] = STATUS_NULL
						End If
				End Select
			Next
		End If

		If NumColorSelectors > 0 Then
			For i = 0 to NumColorSelectors-1
				Select Case ColorSelector_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_COLORSELECTOR, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ColorSelector_Status[i] = STATUS_PRESS
							Else
								ColorSelector_Status[i] = STATUS_HOVER
							End If
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_COLORSELECTOR, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ColorSelector_Status[i] = STATUS_PRESS
							End If
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_COLORSELECTOR, i, mouse_x, mouse_y) Then
							If Not mouse_button1 Then
								ColorSelector_Status[i] = STATUS_RELEASE
								ColorSelector_Selected[i] = GetPixel(mouse_x, mouse_y)
							End If
						Else
							ColorSelector_Status[i] = STATUS_NULL
						End If
					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_COLORSELECTOR, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ColorSelector_Status[i] = STATUS_PRESS
							Else
								ColorSelector_Status[i] = STATUS_HOVER
							End If
						Else
							ColorSelector_Status[i] = STATUS_NULL
						End If
				End Select
			Next
		End If

		'ImageClips
		If NumImageClips > 0 Then
			For i = 0 to NumImageClips-1
				Select Case ImageClip_Status[i]
					Case STATUS_NULL
						If MouseOnItem(Active_Panel, TYPE_IMAGECLIP, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ImageClip_Status[i] = STATUS_PRESS
							Else
								ImageClip_Status[i] = STATUS_HOVER
							End If
						End If
					Case STATUS_HOVER
						If MouseOnItem(Active_Panel, TYPE_IMAGECLIP, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ImageClip_Status[i] = STATUS_PRESS
							End If
						End If
					Case STATUS_PRESS
						If MouseOnItem(Active_Panel, TYPE_IMAGECLIP, i, mouse_x, mouse_y) Then
							If Not mouse_button1 Then
								ImageClip_Status[i] = STATUS_RELEASE
								ImageClip_Event = ImageClip_Id[i]
								Print "imageclip clicked"
							End If
						Else
							ImageClip_Status[i] = STATUS_NULL
						End If
					Case STATUS_RELEASE
						If MouseOnItem(Active_Panel, TYPE_IMAGECLIP, i, mouse_x, mouse_y) Then
							If mouse_button1 Then
								ImageClip_Status[i] = STATUS_PRESS
							Else
								ImageClip_Status[i] = STATUS_HOVER
							End If
						Else
							ImageClip_Status[i] = STATUS_NULL
						End If
				End Select
			Next
		End If

	End If
End Sub

Sub Gui_Render()
	For win_num = 0 to 7
		If GuiWindow_isOpen[win_num] Then
			Window(win_num)
			Canvas(CANVAS_MAIN)
			SetColor(RGB(200, 200, 200))
			RectFill(0, 0, GuiWindow_Size[win_num,0], GuiWindow_Size[win_num,1])
			If NumGuiPanels[win_num] > 0 Then
				For i = 0 to NumGuiPanels[win_num]-1
					DrawPanel(GuiWindow_Panel[win_num, i])
				Next
			End If
			Update()
		End If
	Next
	If CurrentWindow >= 0 And CurrentWindow < 8 Then
		If WindowExists(CurrentWindow) Then
			Window(CurrentWindow)
		End If
	End If
	Wait(5)
End Sub

Function Gui_WindowOpen(title$, x, y, w, h, flag)
	'win_num = NumGuiWindows
	win_num = -1
	For i = 0 To 7
		If Not WindowExists(i) Then
			win_num = i
			Exit For
		End If
	Next
	If win_num = -1 Then
		Print "Could not open window"
		Return -1
	End If
	NumGuiWindows = NumGuiWindows + 1
	WindowOpen(win_num, title$, x, y, w, h, flag)
	Window(win_num)
	GuiWindow_isOpen[win_num] = true
	GuiWindow_Size[win_num,0] = w
	GuiWindow_Size[win_num,1] = h
	CanvasOpen(CANVAS_MAIN, w, h, 0, 0, w, h, 0)
	Canvas(CANVAS_MAIN)
	SetCanvasZ(CANVAS_MAIN, 2)
	CanvasOpen(CANVAS_PANEL, w, h, 0, 0, w, h, 1)
	Canvas(CANVAS_PANEL)
	SetCanvasVisible(CANVAS_PANEL, False)
	SetCanvasZ(CANVAS_PANEL, 1)
	CanvasOpen(CANVAS_OVERLAY, w, h, 0, 0, w, h, 1)
	Canvas(CANVAS_OVERLAY)
	SetCanvasVisible(CANVAS_OVERLAY, False)
	SetCanvasZ(CANVAS_OVERLAY, 0)
	Window(CurrentWindow)
	Canvas(CANVAS_MAIN)
	Return win_num
End Function

Sub Gui_WindowClose(win_num)
	NumGuiWindows = NumGuiWindows - 1
	GuiWindow_isOpen[win_num] = False
	NumGuiPanels[win_num] = 0
	WindowClose(win_num)
End Sub

Sub Gui_HideWindow(win_num)
	Window(win_num)
	HideWindow(win_num)
	Window(CurrentWindow)
End Sub

Sub Gui_ShowWindow(win_num)
	Window(win_num)
	ShowWindow(win_num)
	Window(CurrentWindow)
End Sub

Function Gui_LoadFont(font_file$, font_size)
	For i = 0 to 31
		If Not FontIsLoaded(i) Then
			LoadFont(i, font_file$, font_size)
			If FontIsLoaded(i) Then
				Return i
			Else
				Return -1
			End If
		End If
	Next
	Return -1
End Function

