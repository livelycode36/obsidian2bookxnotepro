#Requires Autohotkey v2
#Include sqlite/SqliteControl.ahk
#Include ../obsidian2bookxnotepro.ahk
#Include BootUp.ahk

; 初始化数据
InitSqlite()

app_config := Config()
myGui := Gui()

myGui.Add("Text", "x32 y18 w118 h18", "Bookxnote数据的目录")
Edit_bookxnote_note_data_path := myGui.AddEdit("x160 y16 w291 h19", app_config.BookxnoteNoteDataPath)
Edit_bookxnote_note_data_path.OnEvent("LoseFocus",(*) => app_config.BookxnoteNoteDataPath := Edit_bookxnote_note_data_path.Value)

myGui.Add("Text", "x62 y48 w87 h23", "图片保存到Obsidian的目录")
Edit_image_path_in_note := myGui.AddEdit("x160 y48 w291 h21", app_config.ImagePathInNote)
Edit_image_path_in_note.OnEvent("LoseFocus",(*) => app_config.ImagePathInNote := Edit_image_path_in_note.Value)

myGui.Add("Text", "x40 y80 w109 h23", "笔记软件的程序名称")
Edit_note_app_name := myGui.AddEdit("x160 y80 w154 h54 +Multi", app_config.AppName)
Edit_note_app_name.OnEvent("LoseFocus",(*) => app_config.AppName := Edit_note_app_name.Value)

myGui.Add("Text", "x104 y153 w51 h23", "回链模板")
Edit_template := myGui.AddEdit("x160 y152 w154 h60 +Multi", app_config.Template)
Edit_template.OnEvent("LoseFocus",(*) => app_config.Template := Edit_template.Value)

myGui.Add("Text", "x80 y225 w77 h23", "图片回链模板")
Edit_image_tempalte := myGui.AddEdit("x160 y224 w154 h79 +Multi", app_config.ImageTemplate)
Edit_image_tempalte.OnEvent("LoseFocus",(*) => app_config.ImageTemplate := Edit_image_tempalte.Value)

CheckBox_is_back := myGui.AddCheckbox("x160 y304 w150 h23", "粘贴之后回到Bookxnote")
CheckBox_is_back.Value := app_config.IsBack
CheckBox_is_back.OnEvent("Click", (*) => app_config.IsBack := CheckBox_is_back.Value)

CheckBox_is_markmind_rich := myGui.Add("CheckBox", "x160 y328 w132 h23", "markmind的rich模式")
CheckBox_is_markmind_rich.Value := app_config.IsMarkmindRich
CheckBox_is_markmind_rich.OnEvent("Click", (*) => app_config.IsMarkmindRich := CheckBox_is_markmind_rich.Value)

CheckBox_is_remove_linebreak := myGui.Add("CheckBox", "x160 y352 w130 h23", "移除高亮内容的换行")
CheckBox_is_remove_linebreak.Value := app_config.IsRemoveLinebreak
CheckBox_is_remove_linebreak.OnEvent("Click", (*) => app_config.IsRemoveLinebreak := CheckBox_is_remove_linebreak.Value)

CheckBox_boot_up := myGui.Add("CheckBox", "x160 y376 w120 h26", "开机启动")
CheckBox_boot_up.Value := get_boot_up()
CheckBox_boot_up.OnEvent("Click", (*) => adaptive_bootup())


myGui.Add("Text", "x96 y408 w63 h23", "回链快捷键")
hk_backlink := myGui.Add("Hotkey", "x160 y408 w155 h21", GetKey("hotkey_backlink"))
hk_backlink.OnEvent("Change", Update_Hk_Backlink)
Update_Hk_Backlink(*){
  RefreshHotkey(app_config.HotkeyBacklink,hk_backlink.Value,obsidian2bookxnote)
  app_config.HotkeyBacklink := hk_backlink.Value
}

myGui.Add("Text", "x61 y440 w96 h27", "bookxnote快捷键:复制摘录原文")
hk_copy_content := myGui.Add("Hotkey", "x160 y440 w156 h21",app_config.HotkeyCopyContent)
hk_copy_content.OnEvent("Change", (*) => app_config.HotkeyCopyContent := hk_copy_content.Value)

myGui.Add("Text", "x61 y472 w96 h29", "bookxnote快捷键:复制外部回链")
hk_copy_backlink := myGui.Add("Hotkey", "x160 y472 w156 h21", app_config.HotkeyCopyBacklink)
hk_copy_backlink.OnEvent("Change", (*) => app_config.HotkeyCopyBacklink := hk_copy_backlink.Value)


myGui.Add("Text", "x64 y520 w93 h23 +0x200", "高亮+回链快捷键")
hotkey_hightline := myGui.Add("Hotkey", "x160 y520 w156 h21",app_config.HotkeyHightline)
hotkey_hightline.OnEvent("Change", Update_Hk_Hightline)
Update_Hk_Hightline(*){
  RefreshHotkey(app_config.HotkeyHightline,hotkey_hightline.Value,obsidian2bookxnote)
  app_config.HotkeyHightline := hotkey_hightline.Value
}

myGui.Add("Text", "x61 y552 w96 h26", "bookxnote快捷键:设为高亮")
hotkey_bookxnote_hightline := myGui.Add("Hotkey", "x160 y552 w156 h21",app_config.HotkeyBookxnoteHightline)
hotkey_bookxnote_hightline.OnEvent("Change", (*) => app_config.HotkeyBookxnoteHightline := hotkey_bookxnote_hightline.Value)

Button_sync_image_to_obsidian := myGui.Add("Button", "x352 y528 w103 h47", "同步修改obsidian中的图片")
Button_sync_image_to_obsidian.OnEvent("Click",SyncImages)

myGui.Add("Text", "x24 y592 w131 h23 +0x200", "在笔记软件中停留的延迟")
myGui.Add("Text", "x282 y592 w63 h23 +0x200", "单位毫秒ms")
Edit_delay_note := myGui.Add("Edit", "x161 y592 w120 h21", app_config.DelayNote)
Edit_delay_note.OnEvent("LoseFocus",(*) => app_config.DelayNote := Edit_delay_note.Value)

myGui.Add("Link", "x440 y590 w51 h17", "<a href=`"https://github.com/livelycode36/obsidian2bookxnotepro`">查看更新</a>")
myGui.OnEvent('Close', (*) => myGui.Hide())
myGui.OnEvent('Escape', (*) => myGui.Hide())
myGui.Title := "obsidian2bookxnotepro"

; =======托盘菜单=========
myMenu := A_TrayMenu

myMenu.Add("&Open", (*) => myGui.Show("w500 h648"))
myMenu.Default := "&Open"
myMenu.ClickCount := 2

myMenu.Rename("&Open" , "打开")
myMenu.Rename("E&xit" , "退出")
myMenu.Rename("&Pause Script" , "暂停脚本")
myMenu.Rename("&Suspend Hotkeys" , "暂停热键")
