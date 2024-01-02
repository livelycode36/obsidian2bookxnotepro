#Requires AutoHotkey v2.0

File_Type := ""

EnableClipboardWatcher(){
    OnClipboardChange ClipDataType,1
}

DisableClipboardWatcher(){
    OnClipboardChange ClipDataType,0
}

ClipDataType(DataType){
    global
    switch DataType {
        case 0:
            File_Type := "null"
            return
        case 1:
            File_Type := "text"
            return
        case 2:
            File_Type := "image"
            return
    }
}