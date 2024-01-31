#Requires AutoHotkey v2.0
#Include sqlite\SqliteControl.ahk

Class Config{
    BookxnoteNoteDataPath{
        get => GetKey("bookxnote_note_data_path")
        set => UpdateOrIntert("bookxnote_note_data_path",Value)
    }

    HotkeyBacklink{
        get => GetKey("hotkey_backlink")
        set => UpdateOrIntert("hotkey_backlink",Value)
    }

    IsBack{
        get => GetKey("is_back")
        set => UpdateOrIntert("is_back",Value)
    }

    IsMarkmindRich{
        get => GetKey("is_markmind_rich")
        set => UpdateOrIntert("is_markmind_rich",Value)
    }
    
    IsRemoveLinebreak{
        get => GetKey("is_remove_linebreak")
        set => UpdateOrIntert("is_remove_linebreak",Value)
    }
    
    Template{
        get => GetKey("template")
        set => UpdateOrIntert("template",Value)
    }

    ImageTemplate{
        get => GetKey("image_template")
        set => UpdateOrIntert("image_template",Value)
    }

    AppName{
        get => GetKey("app_name")
        set => UpdateOrIntert("app_name",Value)
    }

    ImagePathInNote{
        get => GetKey("image_path_in_note")
        set => UpdateOrIntert("image_path_in_note",Value)
    }

    HotkeyCopyBacklink{
        get => GetKey("hotkey_copy_backlink")
        set => UpdateOrIntert("hotkey_copy_backlink",Value)
    }

    HotkeyCopyContent{
        get => GetKey("hotkey_copy_content")
        set => UpdateOrIntert("hotkey_copy_content",Value)
    }

    HotkeyHightline{
        get => GetKey("hotkey_hightline")
        set => UpdateOrIntert("hotkey_hightline",Value)
    }

    HotkeyBookxnoteHightline{
        get => GetKey("hotkey_bookxnote_hightline")
        set => UpdateOrIntert("hotkey_bookxnote_hightline",Value)
    }

    DelayNote{
        get => GetKey("delay_note")
        set => UpdateOrIntert("delay_note",Value)
    }
}