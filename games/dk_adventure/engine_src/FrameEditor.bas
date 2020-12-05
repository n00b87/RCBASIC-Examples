Include "gui.bas"
Include "FrameSet.bas"

Gui_Init()

main_win = Gui_WindowOpen("Test GUI", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 640, 480, 0)

'Menu Panel
menu_panel = Gui_CreatePanel(main_win, "menu panel", 0, 0, 640, 30)

'Menu Buttons
new_button = Gui_CreateButton(menu_panel, "New Set", 5, 5, 60, 20)
load_button = Gui_CreateButton(menu_panel, "Load Set", 70, 5, 60, 20)
save_button = Gui_CreateButton(menu_panel, "Save Set", 135, 5, 60, 20)
'import_button = Gui_CreateButton(menu_panel, "Import Frames", 200, 5, 90, 20)

'Animation List Panel
alist_panel = Gui_CreatePanel(main_win, "animation list", 5, 40, 120, 300)

'Animation ListBox and New Animation Button
anim_label = Gui_CreateLabel(alist_panel, "Animation List", 5, 1)
anim_listbox = Gui_CreateListBox(alist_panel, " ;", 5, 20, 90, 250)
anim_new_button = Gui_CreateButton(alist_panel, "New Animation", 5, 265, 90, 20)
'''''''''''
'Bitmap Panel and Surface
bitmap_panel = Gui_CreatePanel(main_win, "bitmap", 130, 40, 370, 300)
bsurf = Gui_CreateBitmapSurface(bitmap_panel, 380, 300)
bsurf_isLoaded = False
bsurf_mouse_x = 0
bsurf_mouse_y = 0
bsurf_mouse_w = 1
bsurf_mouse_h = 1
bsurf_frame = 0

'Animation Preview Panel
preview_panel = Gui_CreatePanel(main_win, "Animation Preview", 505, 40, 130, 165)
preview_image = Gui_CreateImageClip(preview_panel, 5, 5, 110, 110)
play_button = Gui_CreateButton(preview_panel, ">", 5, 120, 40, 40)
stop_button = Gui_CreateButton(preview_panel, "||", 50, 120, 40, 40)

'Animation Info Panel
info_panel = Gui_CreatePanel(main_win, "Animation Info", 505, 210, 130, 260)
anim_name_label = Gui_CreateLabel(info_panel, "Name:", 5, 5)
anim_name_field = Gui_CreateTextField(info_panel, 50, 5, 75, 15, 0, 0)
anim_id_label = Gui_CreateLabel(info_panel, "ID:", 5, 30)
anim_id_field = Gui_CreateTextField(info_panel, 50, 30, 75, 15, 0, 0)
anim_fps_label = Gui_CreateLabel(info_panel, "FPS:", 5, 55)
anim_fps_field = Gui_CreateTextField(info_panel, 50, 55, 75, 15, 0, 0)
anim_fcount_label = Gui_CreateLabel(info_panel, "Frame Count:###", 5, 80)

'Frame slide panel
slide_left_panel = Gui_CreatePanel(main_win, "Left Slide", 5, 350, 75, 70)
slide_right_panel = Gui_CreatePanel(main_win, "Right Slide", 400, 350, 75, 70)
ad_rm_panel = Gui_CreatePanel(main_win, "Num Frame Panel", 5, 420, 490, 40)
slide_left_button = Gui_CreateButton(slide_left_panel, "<", 5, 5, 64, 64)
slide_right_button = Gui_CreateButton(slide_right_panel, ">", 5, 5, 64, 64)
add_frame_button = Gui_CreateButton(ad_rm_panel, "+", 5, 5, 30, 30)
remove_frame_button = Gui_CreateButton(ad_rm_panel, "-", 40, 5, 30, 30)

'Frames
frame_panel = Gui_CreatePanel(main_win, "Frames", 80, 350, 320, 70)

'ImageClips for the diffent frames in the animation
MAX_FRAME_CLIPS = 8
Dim frame_clip[MAX_FRAME_CLIPS]
frame_clip_count = 0
selected_frame_clip = 0

'---LOAD WINDOW----
load_asset_win = Gui_WindowOpen("Load Asset", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 300, 300, 3)

load_asset_panel = Gui_CreatePanel(load_asset_win, "Load Assets", 0, 0, 300, 300)
load_asset_list = Gui_CreateListBox(load_asset_panel, " ;", 5, 5, 265, 255)
load_asset_loadButton = Gui_CreateButton(load_asset_panel, "Load", 5, 265, 100, 20)
load_asset_cancelButton = Gui_CreateButton(load_asset_panel, "Cancel", 120, 265, 100, 20)

'---NEW WINDOW---
new_asset_win = Gui_WindowOpen("New Asset", WINDOWPOS_CENTERED, WINDOWPOS_CENTERED, 300, 300, 3)

new_asset_panel = Gui_CreatePanel(new_asset_win, "New Asset", 0, 0, 300, 300)
new_asset_nameLabel = Gui_CreateLabel(new_asset_panel, "Name:", 5, 5)
new_asset_nameField = Gui_CreateTextField(new_asset_panel, 45, 5, 200, 15, 0, 0)
new_asset_list = Gui_CreateListBox(new_asset_panel, " ;", 5, 25, 275, 200)
new_asset_fwLabel = Gui_CreateLabel(new_asset_panel, "Frame Width:", 5, 230)
new_asset_fwField = Gui_CreateTextField(new_asset_panel, 100, 230, 100, 15, 0, 0)
new_asset_fhLabel = Gui_CreateLabel(new_asset_panel, "Frame Height:", 5, 250)
new_asset_fhField = Gui_CreateTextField(new_asset_panel, 108, 250, 100, 15, 0, 0)
new_asset_createButton = Gui_CreateButton(new_asset_panel, "Create", 5, 270, 100, 20)
new_asset_cancelButton = Gui_CreateButton(new_asset_panel, "Cancel", 120, 270, 100, 20)

asset = 0
asset_name$ = ""
asset_id$ = ""
Selected_Animation = 0

Sub OnLoadAsset()
	la_assets$ = ""
	
	main_dir$ = dir$()
	ChangeDir(dir$() + "/sprite")
	item$ = DirFirst$()

	While item$ <> ""
		If length(item$) > 4 Then
			If Mid$(item$, length(item$)-4, 4) = ".spr" Then
				la_assets$ = la_assets$ + Mid$(item$, 0, length(item$)-4) + ";"
			End If
		End If
		item$ = DirNext$()
	Wend

	ChangeDir(main_dir$)
	
	If la_assets$ = "" Then
		la_assets$ = " ;"
	End If
	
	Gui_ListBox_SetOptions(load_asset_list, la_assets$)
	Gui_ShowWindow(load_asset_win)
End Sub

Sub OnAnimListChange()
	If frame_clip_count > 0 Then
		For i = 0 to frame_clip_count-1
			Gui_DeleteImageClip(frame_clip[i])
		Next
	End If
	
	Dim x
	Dim y
	Dim w
	Dim h
	
	If Sprite_NumAnimationFrames[asset, Selected_Animation] > 0 Then
		For i = 0 to Sprite_NumAnimationFrames[asset, Selected_Animation]-1
			frame_clip[i] = Gui_CreateImageClip(frame_panel, i*65, 0, 64, 64)
			Sprite_GetFrame(asset, Sprite_Frames[asset, Selected_Animation, i], x, y, w, h)
			Gui_ImageClip_Grab(frame_clip[i], FrameSheet_Image[Sprite_FrameSheet[asset]], x, y, w, h)
		Next
	End If
	frame_clip_count = Sprite_NumAnimationFrames[asset, Selected_Animation]
	Selected_Frame_Clip = 0
End Sub

Sub OnNewAsset()
	na_asset$ = ""
	
	main_dir$ = dir$()
	ChangeDir(dir$() + "/gfx")
	item$ = DirFirst$()

	While item$ <> ""
		If Not (Mid$(item$, 0, 1) = ".") Then
			na_asset$ = na_asset$ + item$ + ";"
		End If
		item$ = DirNext$()
	Wend

	ChangeDir(main_dir$)
	
	If na_asset$ = "" Then
		na_asset$ = " ;"
	End If
	
	Gui_ListBox_SetOptions(new_asset_list, na_asset$)
	Gui_ListBox_SetSelection(new_asset_list, 0)
	Gui_ShowWindow(new_asset_win)
End Sub

Sub OnNewAsset_CreateButton()
	frame_width = Val(Gui_TextField_GetText$(new_asset_fwField))
	frame_height = Val(Gui_TextField_GetText$(new_asset_fhField))
	asset_name$ = Gui_TextField_GetText$(new_asset_nameField)
	frame_sheet_file$ = Gui_ListBox_GetSelectionText$(new_asset_list)
	frame_sheet = Editor_LoadFrameSheet(frame_sheet_file$, frame_width, frame_height)
	if frame_sheet = -1 Then
		Return
	End If
	asset = CreateSprite(frame_sheet)
	Gui_TextField_SetText(anim_name_field, asset_name$)
	Gui_TextField_SetText(anim_id_field, asset_name$ + "_ID")
	Gui_TextField_SetText(anim_fps_field, Str$(Sprite_FPS[asset]))
	
	Gui_BitmapSurface_Clear()
	Gui_BitmapSurface_DrawImage(FrameSheet_Image[Sprite_FrameSheet[asset]], 0, 0)
	bsurf_isLoaded = True
	Animation_List$ = ""
	If Sprite_NumAnimations[asset] > 0 Then
		For i = 0 to Sprite_NumAnimations[asset]-1
			Animation_List$ = Animation_List$ + "Animation " + Str$(i) + ";"
		Next
	Else
		Animation_List$ = " ;"
	End If
	Gui_ListBox_SetOptions(anim_listbox, Animation_List$)
	Gui_ListBox_SetSelection(anim_listbox, 0)
	
	Selected_Animation = 0
	OnAnimListChange()
	Gui_HideWindow(new_asset_win)
End Sub

Sub OnNewAsset_CancelButton()
	Gui_HideWindow(new_asset_win)
End Sub

Sub OnLoadAsset_LoadButton()
	asset_name$ = Gui_ListBox_GetSelectionText$(load_asset_list)
	asset = Editor_LoadSprite(asset_name$)
	Gui_BitmapSurface_Clear()
	Gui_BitmapSurface_DrawImage(FrameSheet_Image[Sprite_FrameSheet[asset]], 0, 0)
	bsurf_isLoaded = True
	Animation_List$ = ""
	If Sprite_NumAnimations[asset] > 0 Then
		For i = 0 to Sprite_NumAnimations[asset]-1
			Animation_List$ = Animation_List$ + "Animation " + Str$(i) + ";"
		Next
	Else
		Animation_List$ = " ;"
	End If
	Gui_ListBox_SetOptions(anim_listbox, Animation_List$)
	Gui_ListBox_SetSelection(anim_listbox, 0)
	Selected_Animation = 0
	OnAnimListChange()
	Gui_TextField_SetText(anim_name_field, asset_name$)
	Gui_TextField_SetText(anim_id_field, asset_name$ + "_ID")
	Gui_TextField_SetText(anim_fps_field, Str$(Sprite_FPS[asset]) )
	Gui_HideWindow(load_asset_win)
End Sub

Sub OnNewAnimation()
	Gui_ListBox_AddOption(anim_listbox, "Animation " + Str$(Sprite_NumAnimations[asset]) + ";")
	Selected_Animation = Sprite_NumAnimations[asset]
	Sprite_NumAnimations[asset] = Sprite_NumAnimations[asset] + 1
	OnAnimListChange()
End Sub

Sub OnSaveAsset()
	Sprite_SetFPS(asset, Val(Gui_TextField_GetText$(anim_fps_field)))
	asset_name$ = Gui_TextField_GetText$(anim_name_field)
	SaveSprite(asset, asset_name$)
	Print "Sprite[" + asset_name$ + "] was saved"
End Sub

Sub OnPreviewPlay()
	Sprite_SetFPS(asset, Val(Gui_TextField_GetText$(anim_fps_field)))
	Sprite_Play(asset, Selected_Animation, -1)
End Sub

Sub OnPreviewStop()
	Sprite_Stop(asset)
End Sub

Sub Editor_Events()
	p = Gui_GetActivePanel()
	
	alist_selection = Gui_ListBox_GetSelection(anim_listbox)
	If alist_selection <> Selected_Animation And alist_selection >= 0 And alist_selection < Sprite_NumAnimations[asset] Then
		Selected_Animation = alist_selection
		OnAnimListChange()
	End If
	
	If bsurf_isLoaded Then
		If Gui_BitmapSurface_Clicked(bsurf) Then
			Gui_BitmapSurface_GetMouse(bsurf, bsurf_mouse_x, bsurf_mouse_y)
			bsurf_mouse_x = Int(bsurf_mouse_x / bsurf_mouse_w)
			bsurf_mouse_y = Int(bsurf_mouse_y / bsurf_mouse_h)
			frames_per_row = Int(FrameSheet_Width[Sprite_FrameSheet[asset]] / FrameSheet_Frame_Width[Sprite_FrameSheet[asset]])
			bsurf_frame = bsurf_mouse_y * frames_per_row + bsurf_mouse_x
			Sprite_Frames[asset, Selected_Animation, Selected_Frame_Clip] = bsurf_frame
			fx = 0
			fy = 0
			fw = 0
			fh = 0
			Gui_DeleteImageClip(frame_clip[Selected_Frame_Clip])
			frame_clip[Selected_Frame_Clip] = Gui_CreateImageClip(frame_panel, Selected_Frame_clip*65, 0, 64, 64)
			Sprite_GetFrame(asset, bsurf_frame, fx, fy, fw, fh)
			Gui_ImageClip_Grab(frame_clip[Selected_Frame_Clip], FrameSheet_Image[Sprite_FrameSheet[asset]], fx, fy, fw, fh)
		Else
			Sprite_GetFrame(asset, Sprite_Frames[asset, Selected_Animation, Selected_Frame_Clip], bsurf_mouse_x, bsurf_mouse_y, bsurf_mouse_w, bsurf_mouse_h)
		End If
		
		Gui_BitmapOverlay_SetColor(RGB(255,0,0))
		Gui_BitmapOverlay_DrawRect(bsurf_mouse_x, bsurf_mouse_y, bsurf_mouse_w, bsurf_mouse_h)
	End If
	
	If frame_clip_count > 0 Then
		For i = 0 to frame_clip_count-1
			If Gui_ImageClip_Clicked(frame_clip[i]) Then
				Selected_Frame_Clip = i
				Exit For
			End If
		Next
	End If
	
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
	
	'Buttons
	If Gui_Button_Clicked(load_button) Then
		OnLoadAsset()
	ElseIf Gui_Button_Clicked(new_button) Then
		OnNewAsset()
	ElseIf Gui_Button_Clicked(new_asset_createButton) Then
		OnNewAsset_CreateButton()
	ElseIf Gui_Button_Clicked(new_asset_cancelButton) Then
		OnNewAsset_CancelButton()
	ElseIf Gui_Button_Clicked(save_button) Then
		OnSaveAsset()
	ElseIf Gui_Button_Clicked(play_button) Then
		OnPreviewPlay()
	ElseIf Gui_Button_Clicked(stop_button) Then
		OnPreviewStop()
	ElseIf Gui_Button_Clicked(load_asset_loadButton) Then
		OnLoadAsset_LoadButton()
		Gui_HideWindow(load_asset_win)
	ElseIf Gui_Button_Clicked(load_asset_cancelButton) Then
		Gui_HideWindow(load_asset_win)
	ElseIf Gui_Button_Pressed(slide_left_button) Then
		Gui_ScrollPanel(frame_panel, -2, 0)
	ElseIf Gui_Button_Pressed(slide_right_button) Then
		Gui_ScrollPanel(frame_panel, 2, 0)
	ElseIf Gui_Button_Clicked(add_frame_button) And frame_clip_count < MAX_FRAME_CLIPS Then
		frame_clip[frame_clip_count] = Gui_CreateImageClip(frame_panel, frame_clip_count*65, 0, 64, 64)
		frame_clip_count = frame_clip_count + 1
		Sprite_NumAnimationFrames[asset, Selected_Animation] = frame_clip_count
	ElseIf Gui_Button_Clicked(remove_frame_button) And frame_clip_count > 0 Then
		frame_clip_count = frame_clip_count - 1
		Gui_DeleteImageClip(frame_clip[frame_clip_count])
		Sprite_NumAnimationFrames[asset, Selected_Animation] = frame_clip_count
	ElseIf Gui_Button_Clicked(anim_new_button) Then
		OnNewAnimation()
	End If
	
	Preview_Render(preview_image, asset)
End Sub

while not key(k_escape)
	Gui_GetEvents()
	
	Editor_Events()
	
	Gui_Render()
wend

Print "Exit Event Reached"
