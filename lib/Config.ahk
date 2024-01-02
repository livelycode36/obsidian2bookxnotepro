#Requires AutoHotkey v2.0
#Include sqlite\SqliteControl.ahk

Class Config{
    BookxnoteNoteDataPath{
        get{
            return GetKey("bookxnote_note_data_path")
        }
        set{
            UpdateOrIntert("bookxnote_note_data_path",Value)
        }
    }

    HotkeyBacklink{
        get{
            return GetKey("hotkey_backlink")
        }
        set{
            UpdateOrIntert("hotkey_backlink",Value)
        }
    }

    IsBack{
        get{
            return GetKey("is_back")
        }
        set{
            UpdateOrIntert("is_back",Value)
        }
    }

    Template{
        get{
            return GetKey("template")
        }
        set{
            UpdateOrIntert("template",Value)
        }
    }

    ImageTemplate{
        get{
            return GetKey("image_template")
        }
        set{
            UpdateOrIntert("image_template",Value)
        }
    }

    AppName{
        get{
            return GetKey("app_name")
        }
        set{
            UpdateOrIntert("app_name",Value)
        }
    }

    ImagePathInNote{
        get{
            return GetKey("image_path_in_note")
        }
        set{
            UpdateOrIntert("image_path_in_note",Value)
        }
    }

    HotkeyCopyBacklink{
        get{
            return GetKey("hotkey_copy_backlink")
        }
        set{
            UpdateOrIntert("hotkey_copy_backlink",Value)
        }
    }

    HotkeyCopyContent{
        get{
            return GetKey("hotkey_copy_content")
        }
        set{
            UpdateOrIntert("hotkey_copy_content",Value)
        }
    }

    HotkeyHightline{
        get{
            return GetKey("hotkey_hightline")
        }
        set{
            UpdateOrIntert("hotkey_hightline",Value)
        }
    }

    HotkeyBookxnoteHightline{
        get{
            return GetKey("hotkey_bookxnote_hightline")
        }
        set{
            UpdateOrIntert("hotkey_bookxnote_hightline",Value)
        }
    }
}