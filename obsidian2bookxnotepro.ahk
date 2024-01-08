#Requires AutoHotkey v2.0
#SingleInstance force
#Include lib\Config.ahk
#Include lib\Tool.ahk
#Include lib\ClipboardControl.ahk
#Include lib\JSON.ahk
#Include lib\gui.ahk

main()

main() {
    global
    SetKeyDelay 50, 50

    TraySetIcon("lib/icon.png", 1, false)

    app_config := Config()

    RegisterHotKey()
}

RegisterHotKey() {
    HotIf CheckCurrentProgram
    Hotkey app_config.HotkeyBacklink " Up", obsidian2bookxnote
    Hotkey app_config.HotkeyHightline " Up", obsidian2bookxnoteHightline
}

RefreshHotkey(old_hotkey,new_hotkey,callback){
    try{
        Hotkey old_hotkey " Up", "off"
        Hotkey new_hotkey " Up" ,callback
    }
    catch Error as err{
        ; 防止无效的快捷键产生报错，中断程序
        Exit
    }
}

CheckCurrentProgram(*) {
    programs := "BookxNotePro.exe" "`n" app_config.AppName
    Loop Parse programs, "`n"{
        program := A_LoopField
        if program{
            if WinActive("ahk_exe" program){
                return true
            }
        }
    }
    return false
}

obsidian2bookxnote(*) {
    global
    ReleaseCommonUseKeyboard()
    ActivateProgram("BookxNotePro.exe")
    
    backlink := GetBackLink()
    note_content := GetNoteContent()

    markdown_link := RenderTemplate(backlink, note_content)

    SendLink2Obsidian(markdown_link)

    if (GetKey("is_back") == 1) {
        ActivateProgram("BookxNotePro.exe")
    }
}

obsidian2bookxnoteHightline(*) {
    global
    ReleaseCommonUseKeyboard()
    ActivateProgram("BookxNotePro.exe")

    ; 仅此与obsidian2bookxnote方法，不同
    Send app_config.HotkeyBookxnoteHightline

    backlink := GetBackLink()
    note_content := GetNoteContent()

    markdown_link := RenderTemplate(backlink, note_content)

    SendLink2Obsidian(markdown_link)
}

GetBackLink() {
    bookxnote_hotkey := app_config.HotkeyCopyBacklink
    return PressDownHotkey(bookxnote_hotkey)
}

GetNoteContent() {
    bookxnote_hotkey := app_config.HotkeyCopyContent

    A_Clipboard := ""
    EnableClipboardWatcher()
    Send bookxnote_hotkey
    if (ClipWait(2, 1)) == 0 {
        MsgBox "检测不到数据"
        Exit
    }
    Sleep 300 ; 等待剪贴板数据稳定
    DisableClipboardWatcher()
    if (File_Type == "image") {
        parameter_map := ParseUrl(backlink)
        note_content := GetImagePath(parameter_map["nb"], parameter_map["uuid"])
    } else if (File_Type == "text") {
        note_content := A_Clipboard
        if (app_config.IsRemoveLinebreak == "1") {
            note_content := StrReplace(note_content, "`n", "")
        }
    }
    return note_content
}

PressDownHotkey(bookxnote_hotkey) {
    ; 先让剪贴板为空, 这样可以使用 ClipWait 检测文本什么时候被复制到剪贴板中.
    A_Clipboard := ""
    Send bookxnote_hotkey
    ClipWait 1, 0
    result := A_Clipboard
    ; MyLog "剪切板的值是：" . result

    ; 解决：一旦potplayer左上角出现提示，快捷键不生效的问题
    if (result == "") {
        SafeRecursion()
        ; 无限重试！
        result := PressDownHotkey(bookxnote_hotkey)
    }
    running_count := 0
    return result
}

GetImagePath(book_id, note_uuid) {
    booknote_config_path := app_config.BookxnoteNoteDataPath "\notebooks\manifest.json"
    if !FileExist(booknote_config_path) {
        MsgBox booknote_config_path "文件不存在"
        Exit
    }

    books := Array()

    manifest := JSON.Load(FileRead(booknote_config_path, "utf-8"))
    notebooks := manifest["notebooks"]

    AddBook2Boos(notebooks)
    AddBook2Boos(notebooks) {
        for notebook in notebooks {
            try {
                if notebook["notebooks"] {
                    AddBook2Boos(notebook["notebooks"])
                } else {
                    books.Push(notebook)
                }
            } catch UnsetItemError {
                books.Push(notebook)
            }
        }
    }

    for book in books {
        if book["id"] == book_id {
            book_name := book["name"]
            ; return book["name"]
        }
    }

    book_markups_path := app_config.BookxnoteNoteDataPath "\notebooks\" book_name "\markups.json"
    if !FileExist(book_markups_path) {
        MsgBox book_markups_path "文件不存在"
        Exit
    }
    book_markups := JSON.Load(FileRead(book_markups_path, "utf-8"))
    markups := book_markups["markups"]
    for markup in markups {
        if markup["uuid"] == note_uuid {
            imgfile := markup["imgfile"]
            ; return markup["imgfile"]
        }
    }

    imgfile_path := app_config.BookxnoteNoteDataPath "\notebooks\" book_name "\imgfiles\" imgfile

    if !FileExist(app_config.ImagePathInNote)
        DirCreate(app_config.ImagePathInNote)

    FileCopy imgfile_path, app_config.ImagePathInNote "\" imgfile, 1

    return imgfile
}

RenderTemplate(backlink, note_content) {
    if InStr(note_content, ".png") {
        template := GetKey("image_template")
        template := StrReplace(template, "{backlink}", backlink)
        template := StrReplace(template, "{image}", "![[" note_content "]]")
        return template
    } else {
        template := GetKey("template")
        template := StrReplace(template, "{backlink}", backlink)
        template := StrReplace(template, "{text}", note_content)
        return template
    }
}

SendLink2Obsidian(markdown_link) {
    ActivateProgram(app_config.AppName)
    A_Clipboard := ""
    A_Clipboard := markdown_link
    ClipWait 2, 0
    delay := app_config.DelayNote
    if (app_config.IsMarkmindRich){
        MouseMove2obsidian()
        Send "{LCtrl down}"
        Send "{v down}"
        Send "{v up}"
        Send "{LCtrl up}"
        ;给osbdiain一点反应时间
        Sleep  delay
        MouseMove2Bookxnote()
    }else{
        Send "{LCtrl down}"
        Send "{v down}"
        Send "{v up}"
        Send "{LCtrl up}"
        Sleep delay
    }
    
}

MouseMove2obsidian() {
    global
    ; 获取当前鼠标位置
    MouseGetPos &originalX, &originalY

    ; 获取 Obsidian 窗口的位置和大小
    WinGetPos &winX, &winY, &winWidth, &winHeight, "ahk_exe" " Obsidian.exe"

    ; 计算 Obsidian 窗口中心的坐标
    centerX := winX + (winWidth / 2)
    centerY := winY + (winHeight / 2)

    ; 将鼠标移动到 Obsidian 窗口的中心
    WinActivate ("ahk_exe " app_config.AppName)
    MouseMove centerX, centerY, 0

    Sleep 200
}

MouseMove2Bookxnote(){
    ; 将鼠标移回原始位置
    MouseMove originalX, originalY
}

SyncImages(*){
    iamges_in_note := InitImagesInNote(app_config.ImagePathInNote)
    iamges_in_bookxnote := InitImagesInBookxnote(app_config.BookxnoteNoteDataPath "\notebooks")

    for image_note in iamges_in_note {
        name := GetNameForPath(image_note)

        for image_bookxnote in iamges_in_bookxnote {
            if (name == GetNameForPath(image_bookxnote)) {
                CopyIfNewer(image_bookxnote, image_note)
            }
        }
    }

    InitImagesInNote(images_path_in_note){
        iamges_in_note := Array()

        Loop Files, images_path_in_note "\*.png", "R"{ ; 递归子文件夹.
            iamges_in_note.Push(A_LoopFileFullPath)
        }
        return iamges_in_note
    }

    InitImagesInBookxnote(images_path_in_bookxnote){
        iamges_in_bookxnote := Array()
    
        Loop Files, images_path_in_bookxnote "\*.png", "R"{
            iamges_in_bookxnote.Push(A_LoopFileFullPath)
        }
        return iamges_in_bookxnote
    }

    CopyIfNewer(SourcePattern, DestPattern){
        Loop Files, SourcePattern{
            time := FileGetTime(DestPattern)
            time := DateDiff(time, A_LoopFileTimeModified, "Seconds")  ; 从目的时间中减去源文件的时间.
            if time < 0  ; 源文件比目的文件新.
                copy_it := true
        }
        if copy_it{
            try{
                FileCopy SourcePattern, DestPattern, 1   ; 以覆盖形式复制 overwrite=yes
            }
            catch
                MsgBox 'Could not copy "' SourcePattern '" to "' DestPattern '"'
        }
    }
    MsgBox "图片修改同步完成!"
}