Include "gui.bas"

Gui_Init()

main_win = Gui_WindowOpen("Test GUI", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)

'Menu Panel
menu_panel = Gui_CreatePanel(main_win, "menu panel", 0, 0, 640, 30)

'Menu Buttons
new_button = Gui_CreateButton(menu_panel, "New Set", 5, 5, 60, 20)
load_button = Gui_CreateButton(menu_panel, "Load Set", 70, 5, 60, 20)
save_button = Gui_CreateButton(menu_panel, "Save Set", 135, 5, 60, 20)
import_button = Gui_CreateButton(menu_panel, "Import Frames", 200, 5, 90, 20)
preview_button = Gui_CreateButton(menu_panel, "Preview", 295, 5, 60, 20)

'Animation List Panel
alist_panel = Gui_CreatePanel(main_win, "animation list", 5, 40, 120, 300)

'Animation ListBox and New Animation Button
anim_label = Gui_CreateLabel(alist_panel, "Animation List", 5, 1)
anim_listbox = Gui_CreateListBox(alist_panel, "0:blast;1:Second;3:Third;4:Fourth;", 5, 20, 90, 250)
anim_new_button = Gui_CreateButton(alist_panel, "New Animation", 5, 265, 90, 20)

'Bitmap Panel and Surface
bitmap_panel = Gui_CreatePanel(main_win, "bitmap", 130, 40, 370, 300)
bsurf = Gui_CreateBitmapSurface(bitmap_panel, 380, 300)

'Animation Preview Panel
preview_panel = Gui_CreatePanel(main_win, "Animation Preview", 505, 40, 130, 165)
preview_image = Gui_CreateImageClip(preview_panel, 5, 5, 110, 110)
play_button = Gui_CreateButton(preview_panel, ">", 5, 120, 40, 40)
stop_button = Gui_CreateButton(preview_panel, "||", 50, 120, 40, 40)

'Animation Info Panel
info_panel = Gui_CreatePanel(main_win, "Animation Info", 505, 210, 130, 260)
anim_name_label = Gui_CreateLabel(info_panel, "Name:", 5, 5)
anim_id_label = Gui_CreateLabel(info_panel, "Id:", 5, 30)
anim_fps_label = Gui_CreateLabel(info_panel, "FPS:", 5, 55)
anim_fcount_label = Gui_CreateLabel(info_panel, "Frame Count:999", 5, 80)

'Frame slide panel
slide_panel = Gui_CreatePanel(main_win, "Frame Slide", 5, 345, 495, 130)
slide_left_button = Gui_CreateButton(slide_panel, "<", 5, 5, 64, 64)
slide_right_button = Gui_CreateButton(slide_panel, ">", 430, 5, 64, 64)
add_frame_button = Gui_CreateButton(slide_panel, "+", 70, 80, 30, 30)
remove_frame_button = Gui_CreateButton(slide_panel, "-", 105, 80, 30, 30)

'Frames
frame_panel = Gui_CreatePanel(main_win, "Frames", 80, 345, 345, 64)

while not key(k_escape)
	Gui_GetEvents()
	p = Gui_GetActivePanel()
	If Key(K_DOWN) then
		Gui_ScrollPanel(p, 0, 1)
	End If
	
	If Key(K_UP) Then
		Gui_ScrollPanel(p, 0, -1)
	End If
	
	If Key(K_RIGHT) Then
		Gui_ScrollPanel(p, 1, 0)
	End If
	
	If Key(K_LEFT) Then
		Gui_ScrollPanel(p, -1, 0)
	End If
	
	
	
	Gui_Render()
wend

Print "Exit Event Reached"
