;~ ;******************************************************************
		_Author_		=	Shyangs
		_Name_			=	DelFxExtLocal
		_Version_		=	0.7
		_ReleaseDate_	=	2012/06/05
		_Compiler_  	:=	"AutoHotkey_L " . (A_IsUnicode ? "Unicode" : "ANSI") . " x86 v" . A_AhkVersion
;~ ;******************************************************************

#include QA.ahk				; http://www.chocomus.com/qa_en/
#include tf.ahk				; http://www.autohotkey.net/~hugov/tf-lib.htm

FileEncoding, UTF-8-RAW

;" 全域變數
gObj := Object()
gObj.fxExtDirPath := A_ScriptDir
gObj.tempFolderPath := A_Temp . "\Temp_DelFxExtLocal_" . A_Now
gObj.pathLogFile := A_ScriptDir . "\log_" . A_Now . ".txt"	;" log檔路徑
gObj.rowNumber := 0
QA_Create( _arrExt_ )		;" 建立陣列，儲存套件相關資訊
QA_Create(_arrLangTag_)

fLangCode(){
	global _langCode_
	If("0404"=A_Language||"0804"=A_Language||"0c04"=A_Language||"1004"=A_Language||"1404"=A_Language){
		_langCode_ := "zhTW_"
	}else{
		_langCode_ := "enUS_"
	}
}

fLang(var){
	global _langCode_, _Version_, _ReleaseDate_, _Compiler_
	
	zhTW_msgAbout := "程式名:`tDelFxExtLocal`n版本號:`t" . _Version_ . "`n發佈日:`t" . _ReleaseDate_ . "`n編譯器:`t" . _Compiler_ . "`n`nCopyright (C) 2010-2012  Shyangs"
	zhTW_msgInvalidLangTag := " 不是合法的語言代碼！"
	zhTW_msgPlzPutinExtDir := "請將本程式放在 extensions 目錄底下！"
	zhTW_msgFileInUse := "該檔案/資料夾可能正被其他程式所使用。請關閉可能鎖定該檔案/資料夾的程式，例如 Firefox，再按下重試按鈕！"
	zhTW_msgNoCompressionModule := "請安裝 7-Zip，或將 7za.exe 與 DelFxExtLocal.exe 置於同一目錄。"
	zhTW_msgFinished := "已完成！"
	enUS_msgAbout := "Name:`tDelFxExtLocal`nVersion:`t" . _Version_ . "`nRelease:`t" . _ReleaseDate_ . "`nCompiler:`t" . _Compiler_ . "`n`nCopyright (C) 2010-2012  Shyangs"
	enUS_msgInvalidLangTag := " is invalid language code!"
	enUS_msgPlzPutinExtDir := "Please put this program in the extensions directory."
	enUS_msgFileInUse := "The file/folder could be locked by another program. Please close any programs that are using the file/folder."
	enUS_msgNoCompressionModule := "Please install 7-Zip, or put 7za.exe and DelFxExtLocal.exe in the same directory."
	enUS_msgFinished := "Finished!"

	zhTW_menuHomepage := "首頁 (&H)"
	zhTW_menuAbout := "關於 (&A)"
	zhTW_menuLang := "語言 (&L)"
	zhTW_menuHelp := "說明 (&H)"
	enUS_menuHomepage := "Homepage (&H)"
	enUS_menuAbout := "About (&A)"
	enUS_menuLang := "Language (&L)"
	enUS_menuHelp := "Help (&H)"
	
	zhTW_LevelStore := "封存"
	zhTW_LevelFastest := "最快速"
	zhTW_LevelFast := "快速"
	zhTW_LevelNormal := "一般"
	zhTW_LevelMaximum := "最大"
	zhTW_LevelUltra := "極致"
	zhTW_muiModule := "壓縮模組: "
	zhTW_muiLevel := "壓縮層級: "
	zhTW_muiLevelList := "封存|最快速|快速|一般|最大|極致"
	zhTW_muiSave := "保留語系: en-US,"
	zhTW_muiTextEditSave := "zh-TW, zh-HK, zh-CN"
	zhTW_muiLvTitle := "擴充套件名稱|擴充套件ID|類型|上次清理日期"
	zhTW_muiSelectAll := "全部勾選"
	zhTW_muiUnSelectAll := "全不勾選"
	zhTW_muiSmart := "智慧選擇"
	zhTW_muiStartClean := "開始清理"
	zhTW_muiDelMETAINF := "刪除 META-INF"
	zhTW_muiDelExtINI := "刪除 extensions.ini"
	zhTW_muiLogFile := "生成記錄檔"
	zhTW_muiTotal := "套件數: "
	enUS_LevelStore := "Store"
	enUS_LevelFastest := "Fastest"
	enUS_LevelFast := "Fast"
	enUS_LevelNormal := "Normal"
	enUS_LevelMaximum := "Maximum"
	enUS_LevelUltra := "Ultra"
	enUS_muiModule := "Module: "
	enUS_muiLevel := "Level: "
	enUS_muiLevelList := "Store|Fastest|Fast|Normal|Maximum|Ultra"
	enUS_muiSave := "Save: en-US,"
	enUS_muiTextEditSave := ""
	enUS_muiLvTitle := "Name|ID|Type|Last cleaned date"
	enUS_muiSelectAll := " Select all "
	enUS_muiUnSelectAll := "Unselect all"
	enUS_muiSmart := "Smartly Select"
	enUS_muiStartClean := "Start"
	enUS_muiDelMETAINF := "Del META-INF"
	enUS_muiDelExtINI := "Del extensions.ini"
	enUS_muiLogFile := "Log file"
	enUS_muiTotal := "Total: "
	
	zhTW_puiDetails := "細節`:"	;" 「節」的第二個byte包含「`」（AHK中的轉義符）。使用時，在文字後面插入一個「`」
	zhTW_puiInProcess := "執行中...。 請勿強行關閉程式或干擾相關檔案操作！"
	enUS_puiDetails := "Details:"
	enUS_puiInProcess := "Don't close this program while it is still running."
	
	zhTW_editCollectInfo := "正在收集套件資訊..."
	zhTW_editNoLocale := ", 此套件無語系檔。"
	zhTW_editDelLocale := ", 刪除語系檔 "
	zhTW_editDecompress := ", 解壓縮 "
	zhTW_editCompress := ", 壓縮 "
	zhTW_editFileOrFloder := ", 將檔案/資料夾 "
	zhTW_editAdd2ZipFile := " 加入壓縮檔 "
	zhTW_editStart := ", DelFxExtLocal 開始清理。"
	zhTW_editHandle := ", 處理套件 "
	zhTW_editFinished := ", 全部完成，程式關閉。"
	enUS_editCollectInfo := "Collecting information of extensions..."
	enUS_editNoLocale := ", there is no locale in this extension."
	enUS_editDelLocale := ", delete locale: "
	enUS_editDecompress := ", decompress "
	enUS_editCompress := ", compress "
	enUS_editFileOrFloder := ", add "
	enUS_editAdd2ZipFile := " to "
	enUS_editStart := ", DelFxExtLocal started."
	enUS_editHandle := ", handle "
	enUS_editFinished := ", finished."
	
	zhTW_cannotModify := "無法修改"
	zhTW_cannotDel := "無法刪除"
	zhTW_delete := "刪除"
	zhTW_unknown := "未知"
	zhTW_folder := "資料夾"
	enUS_cannotModify := "Cannot modify"
	enUS_cannotDel := "Cannot remove"
	enUS_delete := "delete"
	enUS_unknown := "unknown"
	enUS_folder := "folder"
	
	var := _langCode_ . var
	var := %var%
	return, var
}

fFolderSize(pathFolder){
	FolderSize := 0
	Loop, % pathFolder, , 1
		FolderSize += %A_LoopFileSize%
	return, FolderSize
}

fFileDelete(pathFile){
	Loop
	{
		FileDelete, % pathFile
		If ErrorLevel
		{
			MsgBox,	53,, % fLang("cannotDel") . pathFile . "`n" . fLang("msgFileInUse")
			IfMsgBox, Retry
			{
				fFileDelete(pathFile)
			}else{
				ExitApp
			}
		}else{
			break
		}
	}
}

fFileMove(source, dest , flag){
	Loop
	{
		FileMove, % source, % dest , % flag
		If ErrorLevel
		{
			MsgBox,	53,, % fLang("cannotModify") . dest . "`n" . fLang("msgFileInUse")
			IfMsgBox, Retry
			{
				fFileMove(source, dest , flag)
			}else{
				ExitApp
			}
		}else{
			break
		}
	}
}

fFileRemoveDir(pathDir , recurse){
	Loop
	{
		FileRemoveDir, % pathDir, % recurse
		If ErrorLevel
		{
			MsgBox,	53,, % fLang("cannotDel") . pathDir . "`n" . fLang("msgFileInUse")
			IfMsgBox, Retry
			{
				fFileRemoveDir(pathDir , recurse)
			}else{
				ExitApp
			}
		}else{
			break
		}
	}
}

;" 新值與陣列中每一個元素皆相異的話，將之加入陣列末端
fQA_CondPush(ByRef arr, value){
	len := QA_Length(arr)
	Loop, %len%
	{
		if( QA_Get(arr, A_index) = value ){
			return
		}
	}
	QA_Push(arr, value)
}

;" 從陣列中，移除特定元素
fQA_RemoveValue(ByRef arr, value){
	index	:=	QA_IndexOf(arr, value)
	if(	0	=	index	){
		Return
	}else{
		QA_Remove(arr, index)
	}
}

;" 從陣列中，移除全部元素
fQA_RemoveAll(ByRef arr){
	len	:=	QA_Length(arr)
	Loop, %len%
	{
		index := len + 1 - A_index
		QA_Remove(arr, index)
	}
}

;" 字串分割為一個字串陣列
fQA_StringSplit(ByRef arr, inputStr, delimiters){
	Loop, Parse, inputStr, % delimiters
	{
		QA_Push(arr, A_LoopField)
	}
}

;" returnFirst = 0 return multiple lines  , =1 return first line only.
;" returnType = 0 return line numbers only , =1 return entire line (text).
fTF_RegexMatch(path, startLine, endLine, strRegex, returnFirst, returnType){
	strTF		:=	TF_Find(path, startLine, endLine, strRegex, returnFirst, returnType)
	If( strTF && 0=returnFirst && 1=returnType ){
		QA_Create(arrTF)
		QA_ValueOf(arrTF, strTF, "`n")
		strTF := ""
		len := QA_Length(arrTF)
		Loop, %len%
		{
			RegExMatch(QA_Get(arrTF, A_index), strRegex, outputVar)
			strPath := ( 1 = A_index ? outputVar1 : strPath . "," . outputVar1 )
		}
		Return, strPath
	}Else If( strTF && 1=returnType ){
		RegExMatch(strTF, strRegex, outputVar)
		Return, outputVar1		;" outputVar 陣列 第1個元素
	}Else If( strTF && 0=returnType ){
		Return, strTF
	}Else{
		Return, 0
	}
}

fGetElmByID(elmExtID, ByRef arr){
	len := QA_Length(arr)
	Loop, %len%
	{
		oExt := QA_Get(arr, A_Index)		
		If(elmExtID = oExt.extID ){
			Return, oExt
		}
	}
}

;" 將檔案/資料夾名稱 存入 陣列. numType=0 檔案, =1 檔案和資料夾, =2 資料夾
fFileFolderArray(path, numType, ByRef arr){
;~ 	path := path . "\*"
	Loop, % path, %numType%
	{
		QA_Push(arr, A_LoopFileName)		
	}
}

;" 檢查本程式放置之目錄
fIsInExtensionsDir(ByRef arrSDP){
	lenSDP	:=	QA_Length(arrSDP)
	elmSDP	:=	QA_Get(arrSDP, lenSDP)
	if (	"extensions"	!=	elmSDP	){
		MsgBox,	4112,, % fLang("msgPlzPutinExtDir") ; "請將本程式放在 extensions 目錄底下！"
		ExitApp
	}
}


;" 檢測是否安裝 7Zip
fCheck_7Zip(){
	global _path7zip_, _compressionModule_
	RegRead, _path7zip_, HKEY_CURRENT_USER, SOFTWARE\7-Zip, Path
	If ErrorLevel  ;" 不存在的鍵值，ErrorLevel 被設置為 1 ，否則為 0 
	{
		If( FileExist("7za.exe") )
		{	;" 在當前目錄找到 7za.exe
			_compressionModule_ := "7za.exe"
			_path7zip_ := "7za.exe"
			Return, True		
		}Else If( FileExist("7z.exe") && FileExist("7z.dll") )
		{	;" 在當前目錄找到 7z.exe 與 7z.dll
			_compressionModule_ := "7z.exe"
			_path7zip_ := "7z.exe"
			Return, True		
		}Else{
			Return, False
		}	
	}Else IfNotExist, %_path7zip_%\7z.exe
	{	;" 7-Zip 安裝目錄找不到 7z.exe
		Return, False
	}Else{
		_compressionModule_	:= "7-Zip"
		_path7zip_		:= _path7zip_ . "\7z.exe"
		Return, True
	}
}

fCheckLangTag( strLangTag ){
	global _arrLangTag_
	fQA_RemoveAll(_arrLangTag_)
	strRegex :="^\s*([A-Za-z]{2,4}(?:-[A-Za-z]{2,4})*)\s*$"
	fQA_StringSplit( _arrLangTag_, strLangTag, ",")
	lenLT := QA_Length(_arrLangTag_)
	Loop, %lenLT%
	{
		elmLT :=  QA_Get(_arrLangTag_, A_Index)
		bln := RegExMatch(elmLT, strRegex, langTag)
		If( !bln ){
			MsgBox, 4112,,% elmLT . fLang("msgInvalidLangTag") ;" "不是合法的語言代碼"
			Gui, Show
			Exit	;" Exit current thread 中止執行緒
		}
		QA_Push(_arrLangTag_, langTag1)
	}
	QA_Push(_arrLangTag_, "en-US")
}

;" 執行介面
fProcessGui(rowHeight){
	global _textEditContent_, _progressValue_, _hwnd_, _Name_, _ReleaseDate_
	_textEditContent_	:=	""		;" 用來儲存 Gui Edit區的內容
	_progressValue_		:=	0
	
	Gui, Font, S16
	Gui, -Caption +Border
	Gui, Add, GroupBox, +Center +W700 +H10, % _Name_

	Gui, Font, S12
	Gui, Add, Text, +W700, % fLang("puiDetails")	; "細節:"
	Gui, Add, Edit, +ReadOnly +W700 +R%rowHeight% V_textEditContent_ HWND_textEditContentHwnd_
	Gui, Add, Progress, +W700 +H20 +CBlue V_progressValue_
	Gui, Add, Text, +W700 +CRed, % fLang("puiInProcess")	; "執行中...。 請勿強行關閉程式或干擾相關檔案操作！"
	Gui, Show
	
	_hwnd_	:=	_textEditContentHwnd_
}

;" 將處理進度資料更新至 gui 與 log 檔
fEditGuiAndFile(textNewContent){
	global gObj, _textEditContent_, _hwnd_, _blnLog_
	if( _blnLog_ ){
		FileAppend, %textNewContent%, % gObj.pathLogFile
	}
	_textEditContent_	:=	_textEditContent_ . textNewContent
	GuiControl,, _textEditContent_, %_textEditContent_%		;" 更新 Gui 內容
	ControlSend,, {Ctrl Down}{End}{Ctrl up}, ahk_id %_hwnd_%		;" ctrl+End 捲軸拉至最底
}

;" language 語系檔目錄的相對路徑
fDirLocale(oExt, language){
	strRegex	:=	"locale\s.*" . language . "\s+([^\s]+)"	;" 正規表達式 \s 相當於 [\f\n\r\t\v]
	strPath		:=	fTF_RegexMatch(oExt.pathCM, "", "", strRegex, 0, 1)
	StringReplace, strPath, strPath, /, \, All			;" 斜線變反斜線
	QA_Create(arrPath)
	QA_Create(arrTemp)
	QA_ValueOf(arrTemp, strPath)
	strRegex	:=	"([^\s]+)\\" . language . "\\"
	Loop, % QA_Length(arrTemp)
	{
		RegExMatch(QA_Get(arrTemp, A_index), strRegex, dirLocale)
		fQA_CondPush(arrPath, dirLocale1)
	}
	strPath := QA_ToString(arrPath)
	QA_Destroy(arrTemp)
	QA_Destroy(arrPath)
	Return, strPath
}

fJarOrFolder(oExt, dirLocale){
	strRegex	:=	"jar:(?:([^\s]*?)\\?)([^\\\s]+\.jar)!\\([^\s]+)"
	RegExMatch(dirLocale, strRegex, outputVar)
	jarDir		:= outputVar1		;" .jar檔目錄
	jarFileName	:= outputVar2
	Return, ( jarFileName ? "jar" : "folder" )
}

fAddElmTo_arrExt_(ByRef arr, path, shellType){
	global _arrExt_, gObj
	Loop, % QA_Length(arr)
	{
		extDirName	:=	QA_Get(arr, A_Index)
		pathExtDir := path . "\" . extDirName
		pathIR := pathExtDir . "\install.rdf"
		pathCM := pathExtDir . "\chrome.manifest"
		if( FileExist(pathIR) && FileExist(pathCM) ){	;" 各資料夾內存在 install.rdf 和 chrome.manifest
			obj := "oExt" . ( QA_Length(_arrExt_) + 1 )
			%obj% := Object()
			QA_Push(_arrExt_, %obj%)  ;" 物件存入陣列
			%obj%.extID := extDirName  ;" 套件ID存入物件
			%obj%.pathShell := gObj.fxExtDirPath . "\" . extDirName . ( ("xpi"=shellType) ? ".xpi" : "" )
			%obj%.pathExtDir := pathExtDir
			%obj%.pathIR := pathIR
			%obj%.pathCM := pathCM
			%obj%.shellType := shellType
			dirLocale := fDirLocale(%obj%, "[A-Za-z]{2,4}(?:-[A-Za-z]{2,4})*")
			%obj%.localeExist := ( dirLocale ? True : False )
			%obj%.localeDir := ( dirLocale ? dirLocale : "" )
			%obj%.coreType := ( %obj%.localeExist ? fJarOrFolder(%obj%, dirLocale) : "" )
			strRegex	=	em:name(?:>|=`'|=`")(.*)(?:`"|`'|</em:name>)  ;" AHK 的轉義符號 ` 
			strTF		:=	TF_Find(pathIR, "", "", strRegex, 1, 1)
			if( strTF ){
				RegExMatch(strTF, strRegex, strExtName)
				%obj%.name := strExtName1  ;" 套件名存入物件
			}else{
				%obj%.name := extDirName  ;" 沒套件名，則用 ID
			}
		}
	}
}

fInit_arrExt_(){
	global gObj, _arrExt_, _path7zip_
	
	fProcessGui(3)
	fEditGuiAndFile(fLang("editCollectInfo")) ;" "正在收集套件資訊"
	QA_Create(arrFolderName)
	fFileFolderArray(gObj.fxExtDirPath . "\*",     2, arrFolderName)	;" extensions 目錄下的 資料夾名稱 存入陣列
	fAddElmTo_arrExt_(arrFolderName, gObj.fxExtDirPath, "folder")

	QA_Create(arrFileName)
	fFileFolderArray(gObj.fxExtDirPath . "\*.xpi", 0, arrFileName)	;" extensions 目錄下的 檔案名稱 存入陣列
	len := QA_Length(arrFileName)
	Loop, % len
	{
		value	:=	A_Index/len*100		;" 進度估計值
		GuiControl,, _progressValue_, %value%	;" 更新進度條
		xpiName := QA_Get(arrFileName, A_Index)
		StringTrimRight, xpiName, xpiName, 4  ;" 去掉副檔名 .xpi
		QA_Set(arrFileName, A_Index, xpiName)
		pathZipFile := gObj.fxExtDirPath . "\" . xpiName . ".xpi"
		pathUnzDir  := gObj.tempFolderPath . "\" . xpiName
		RunWait, %ComSpec% /c ""%_path7zip_%" "x" "%pathZipFile%" "-o%pathUnzDir%" "install.rdf" "-r-" "-y"", , Hide
		RunWait, %ComSpec% /c ""%_path7zip_%" "x" "%pathZipFile%" "-o%pathUnzDir%" "chrome.manifest" "-r-" "-y"", , Hide
	}
	fAddElmTo_arrExt_(arrFileName, gObj.tempFolderPath ,"xpi")
	Gui, Destroy
}

fcleanedDate(oExt){
	global gObj
	lastLineNum := TF_CountLines(oExt.pathCM)
	strRegex := "# DelFxExtLocal_(\d+)"
	lastCleanedDate := fTF_RegexMatch(oExt.pathCM, lastLineNum, lastLineNum, strRegex, 1, 1)
	If ( lastCleanedDate ){
		Return, lastCleanedDate
	}Else{
		Return, fLang("unknown")
	}
}

;" 智慧選擇
fSmart(){
	rowNum := LV_GetCount()	;" 總列數
	Loop, %rowNum%
	{
		LV_GetText(lastCleanedDate, A_Index, 4)		;" 第 4 欄
		if ( fLang("unknown") = lastCleanedDate ){
			LV_Modify(A_Index, "Check")
		}else{
			LV_Modify(A_Index, "-Check")
		}
	}
}

;" 主介面
fMainGui(){
	global _arrExt_, _compressionModule_, _Level_, _textEditSave_, _blnDelMETAINF_, _blnDelExtINI_, _blnLog_
	Gui, Font, S10
	Menu, LangMenu, Add, % "English", _lLang_enUS
	Menu, LangMenu, Add, % "中文", _lLang_zhTW
	Menu, HelpMenu, Add, % fLang("menuHomepage"), _lHelpHomepage	; "首頁 (&H)"
	Menu, HelpMenu, Add, % fLang("menuAbout"), _lHelpAbout	; "關於 (&A)"
	
	Menu, MenuBar, Add, % fLang("menuLang"), :LangMenu	; "語言 (&L)"
	Menu, MenuBar, Add, % fLang("menuHelp"), :HelpMenu	; "說明 (&H)"

	Gui, Menu, MenuBar
	
	Gui, Add, Text, +Section, % fLang("muiModule") . _compressionModule_	; "壓縮模組: "
	Gui, Add, Text, +YS, % fLang("muiLevel") 	; "壓縮層級: "
	Gui, Add, DropDownList, +YS Choose2 V_Level_, % fLang("muiLevelList")	; 	"封存|最快速|快速|一般|最大|極致"

	Gui, Add, Text, +YS, % fLang("muiSave")	; "保留語系: en-US,"
	Gui, Add, Edit, +YS V_textEditSave_, % fLang("muiTextEditSave") ;" "zh-TW, zh-HK, zh-CN"
	Gui, Add, ListView, +Checked +W650 +R26 +XS +Section, % fLang("muiLvTitle") ; "擴充套件名稱|擴充套件ID|類型|上次清理日期"
	Gui, Add, Button, +YS G_lSelectAll, % fLang("muiSelectAll")	; "全部勾選"
	Gui, Add, Button, +WP G_lUnselectAll, % fLang("muiUnSelectAll")	; "全不勾選"
	Gui, Add, Button, +WP G_lSmart, % fLang("muiSmart")	; "智慧選擇"
	Gui, Add, Button,  +WP G_lClean, % fLang("muiStartClean")	; "開始清理"
	Gui, Add, Checkbox, +Checked V_blnDelMETAINF_, % fLang("muiDelMETAINF")	; "刪除 META-INF"
	Gui, Add, Checkbox, V_blnDelExtINI_, % fLang("muiDelExtINI")	; "刪除 extensions.ini"
	Gui, Add, Checkbox, V_blnLog_, % fLang("muiLogFile")	; "生成記錄檔"
	
	lenExt	:=	QA_Length(_arrExt_)	;" 套件個數
	Loop, %lenExt%
	{
		oExt := QA_Get(_arrExt_, A_Index)
		extName	:= oExt.name
		extID	:= oExt.extID
		extType := oExt.shellType
;~ 		coreType := oExt.coreType
		extType := ( "folder" = extType ? fLang("folder") : extType )
		cleanedDate := fcleanedDate(oExt)
		LV_Add("Check", extName, extID, extType, cleanedDate)
	}
	LV_ModifyCol()  ;" 自動調整大小來適應每列的內容。
	Gui, Add, Text, +XS, % fLang("muiTotal") . lenExt	; "套件數: "
	fSmart()
	Gui, Show
}

fEditChromeManifest(oExt){
	global _arrLangTag_
	QA_Create(arrLineNum)
	pathCM := oExt.pathCM
	StringReplace, pathCM_copy, pathCM, chrome.manifest, chrome_copy.manifest
	language := "[A-Za-z]{2,4}(?:-[A-Za-z]{2,4})*"
	strRegex := "locale\s.*" . language . "\s+([^\s]+)"
	strLineNumList := fTF_RegexMatch(pathCM, "", "", strRegex, 0, 0)
	fQA_StringSplit(arrLineNum, strLineNumList, ",")
	len := 	QA_Length(_arrLangTag_)
	Loop, %len%
	{
		langTag := QA_Get(_arrLangTag_, A_Index)
		strRegex := "locale\s.*" . langTag . "\s+([^\s]+)"
		lineNum := fTF_RegexMatch(pathCM, "", "", strRegex, 0, 0)
		QA_Create(arrTemp)
		QA_ValueOf(arrTemp, lineNum)
		Loop, % QA_Length(arrTemp)
		{
			fQA_RemoveValue(arrLineNum, QA_Get(arrTemp, A_index))
		}
		QA_Destroy(arrTemp)
	}

	len := 	QA_Length(arrLineNum)
	Loop, %len%
	{
		lineNum := QA_Get(arrLineNum, A_Index)
		TF_InsertPrefix(pathCM, lineNum, lineNum, "# ")
		fFileMove(pathCM_copy, pathCM, 1)	;" ,1: 覆蓋已存在的檔案
	}
	
	FileAppend, % "`n# DelFxExtLocal_" . A_Now, %pathCM%
}

;" 保留的語系目錄
fSaveLang(ByRef arrlocaleDirName){
	global _arrLangTag_
	len := QA_Length(_arrLangTag_)
	Loop, %len%
	{
		elm := QA_Get(_arrLangTag_, A_Index)
		fQA_RemoveValue(arrlocaleDirName, elm)
	}
}

fDelMETAINF(oExt){
	global _blnDelMETAINF_
	pathMETAINF := oExt.pathExtDir . "\META-INF"
	If( _blnDelMETAINF_ && FileExist(pathMETAINF) ){
		fEditGuiAndFile( "`n`t" . A_Now . ", " . fLang("delete") . " META-INF" ) ; "刪除 META-INF"
		fFileRemoveDir(pathMETAINF, 1)
	}
}

;" 刪除用不著的語系檔
fDelExtLocal(pathLocaleDir){
	QA_Create(arrlocaleDirName)
	fFileFolderArray(pathLocaleDir . "\*", 2, arrlocaleDirName)
	fSaveLang(arrlocaleDirName)
	len	:=	QA_Length(arrlocaleDirName)
	Loop, %len%
	{
		localeDirName	:=	QA_Get(arrlocaleDirName, A_Index)
		fEditGuiAndFile( "`n`t" . A_Now . fLang("editDelLocale") . localeDirName)	; ", 刪除語系檔 "
		pathLocale := pathLocaleDir . "\" . localeDirName
		fFileRemoveDir(pathLocale, 1)
	}
	QA_Destroy(arrlocaleDirName)
}

;" 解壓縮.zip檔
fUnzip( zipFileName, pathZipFile, pathUnzDir ){
	global _path7zip_
	fEditGuiAndFile( "`n`t" . A_Now . fLang("editDecompress") . zipFileName)	; ", 解壓縮 "
	RunWait, %ComSpec% /c ""%_path7zip_%" "x" "%pathZipFile%" "-o%pathUnzDir%" "-aos" "-y"", , Hide
}

;" 壓縮成.jar or .xpi檔
fZip(level, pathJARorXPIDir, pathUnzDir, fileNameJARorXPI, zipFileName){
	global _path7zip_
	pathJARorXPI	:=	pathJARorXPIDir . "\" . fileNameJARorXPI
	if( 0 = fFolderSize(pathUnzDir . "\*.*") ){
		fFileDelete(pathJARorXPI)
		return
	}
	fEditGuiAndFile( "`n`t" . A_Now . fLang("editCompress") . fileNameJARorXPI)	; ", 壓縮 "
	pathZip	:=	pathJARorXPIDir . "\" . zipFileName
	QA_Create(arrFileFolderName)
	fFileFolderArray(pathUnzDir . "\*", 1, arrFileFolderName)
	lenFFN	:=	QA_Length(arrFileFolderName)
	Loop, %lenFFN%
	{
		elmFFN	:=	QA_Get(arrFileFolderName, A_Index)
		pathFFN	:=	pathUnzDir . "\" . elmFFN
		fEditGuiAndFile( "`n`t" . A_Now . fLang("editFileOrFloder") . elmFFN . fLang("editAdd2ZipFile") . fileNameJARorXPI)	; ", 將檔案/資料夾 "	; " 加入壓縮檔 "
		RunWait, %ComSpec% /c ""%_path7zip_%" "a" "-tzip" "%pathZip%" "%pathFFN%" "-mx%level%"", , Hide
	}

	fFileMove(pathZip, pathJARorXPI, 1)
}

fCleanExtLocale(oExt){
	global gObj, _level_, _path7zip_
	If( False = oExt.localeExist ){
		pathCM := oExt.pathCM
		FileAppend, % "`n# DelFxExtLocal_" . A_Now, %pathCM%
		If( "xpi" = oExt.shellType ){
			pathXPI := oExt.pathShell
			RunWait, %ComSpec% /c ""%_path7zip_%" "a" "-tzip" "%pathXPI%" "%pathCM%" "-mx%_level_%"", , Hide
		}
		fEditGuiAndFile( "`n`t" . A_Now . fLang("editNoLocale") )	; ", 此套件無語系檔。"
	}Else If( "folder" = oExt.shellType && "folder" = oExt.coreType ){
		fDelMETAINF(oExt)
		QA_Create(arrPath)
		QA_ValueOf(arrPath, oExt.localeDir)
		Loop, % QA_Length(arrPath)
		{
			pathLocaleDir := oExt.pathExtDir . "\" . QA_Get(arrPath, A_index)
			fDelExtLocal(pathLocaleDir)
		}
		QA_Destroy(arrPath)
		fEditChromeManifest(oExt)
	}Else If( "folder" = oExt.shellType && "jar" = oExt.coreType ){
		fDelMETAINF(oExt)
		strRegex	:=	"jar:(?:([^\s]*?)\\?)([^\\\s]+\.jar)!\\([^\s]+)"
		QA_Create(arrPath)
		QA_ValueOf(arrPath, oExt.localeDir)
		Loop, % QA_Length(arrPath)
		{
			RegExMatch(QA_Get(arrPath, A_index), strRegex, outputVar)
			jarDir		:= outputVar1 ;" .jar檔目錄
			fileNameJAR	:= outputVar2 ;" .jar檔檔名
			pathJARDir	:= oExt.pathExtDir . ( (jarDir) ? ("\" . jarDir) : "" )
			pathJARFile := pathJARDir . "\" . fileNameJAR ;" .jar檔完整路徑
			pathUnzDir	:= gObj.tempFolderPath . "\" . oExt.extID . ".JAR" ;" 解壓縮暫存路徑
			fUnzip( fileNameJAR, pathJARFile, pathUnzDir ) ;" 解壓縮.jar檔
			pathLocaleDir:=	pathUnzDir . "\" . outputVar3	
			fDelExtLocal(pathLocaleDir)
			StringReplace, fileNameZIP, fileNameJAR, .jar, .zip
			fZip(_level_, pathJARDir, pathUnzDir, fileNameJAR, fileNameZIP)
			FileRemoveDir, % pathUnzDir, 1
		}
		QA_Destroy(arrPath)
		fEditChromeManifest(oExt)
 	}Else If( "xpi" = oExt.shellType && "folder" = oExt.coreType ){
		fEditChromeManifest(oExt)
		fileNameXPI	:= oExt.extID . ".xpi" ;" .xpi檔檔名
		pathUnzDir	:= oExt.pathExtDir
		fUnzip( fileNameXPI , oExt.pathShell, pathUnzDir ) ;" 解壓縮.xpi檔
		fDelMETAINF(oExt)
		QA_Create(arrPath)
		QA_ValueOf(arrPath, oExt.localeDir)
		Loop, % QA_Length(arrPath)
		{
			pathLocaleDir := oExt.pathExtDir . "\" . oExt.localeDir
			fDelExtLocal(pathLocaleDir)
		}
		QA_Destroy(arrPath)
		;; 作XPI壓縮
		StringReplace, fileNameZIP, fileNameXPI, .xpi, .zip
		fZip(_level_, gObj.fxExtDirPath, pathUnzDir, fileNameXPI, fileNameZIP)
 	}Else{ ;" ( "xpi" = oExt.shellType && "jar" = oExt.coreType )
		fEditChromeManifest(oExt)
		fileNameXPI	:= oExt.extID . ".xpi" ;" .xpi檔檔名
		pathXPIUnzDir	:= oExt.pathExtDir
		fUnzip( fileNameXPI , oExt.pathShell, pathXPIUnzDir ) ;" 解壓縮.xpi檔
		fDelMETAINF(oExt)
		strRegex	:=	"jar:(?:([^\s]*?)\\?)([^\\\s]+\.jar)!\\([^\s]+)"
		QA_Create(arrPath)
		QA_ValueOf(arrPath, oExt.localeDir)
		Loop, % QA_Length(arrPath)
		{
			RegExMatch(oExt.localeDir, strRegex, outputVar)
			jarDir		:= outputVar1 ;" .jar檔目錄
			fileNameJAR	:= outputVar2 ;" .jar檔檔名
			pathJARDir	:= oExt.pathExtDir . ( (jarDir) ? ("\" . jarDir) : "" )
			pathJARFile := pathJARDir . "\" . fileNameJAR ;" .jar檔完整路徑
			pathJARUnzDir	:= gObj.tempFolderPath . "\" . oExt.extID . ".JAR" ;" 解壓縮暫存路徑
			fUnzip( fileNameJAR, pathJARFile, pathJARUnzDir ) ;" 解壓縮.jar檔
			pathLocaleDir:=	pathJARUnzDir . "\" . outputVar3	
			fDelExtLocal(pathLocaleDir)
			StringReplace, fileNameZIP, fileNameJAR, .jar, .zip
			fZip(0, pathJARDir, pathJARUnzDir, fileNameJAR, fileNameZIP)
			FileRemoveDir, % pathUnzDir, 1
		}
		QA_Destroy(arrPath)
		;; 作XPI壓縮
		StringReplace, fileNameZIP, fileNameXPI, .xpi, .zip
		fZip(_level_, gObj.fxExtDirPath, pathXPIUnzDir, fileNameXPI, fileNameZIP)
	}
}

fMain(){
	global gObj, _arrExt_, _progressValue_, _blnDelExtINI_
	fProcessGui(9)	;" 執行介面
	fEditGuiAndFile( A_Now . fLang("editStart"))	;" 建立 log 檔， 記錄第一筆資料: 程式開始執行之時間		; ", DelFxExtLocal 開始清理。"
	pathExtINI := gObj.pathProfile . "\extensions.ini"
	If( _blnDelExtINI_ && FileExist(pathExtINI) ){
		fEditGuiAndFile( "`n`n" . A_Now . ", " . fLang("delete") . " extensions.ini" ) ; "刪除 extensions.ini"
		FileDelete, % pathExtINI
	}
	checkedIndex := 0
	lenExt := QA_Length(_arrExt_)	;" 總套件個數
	Loop, %lenExt%
	{
		oExt := QA_Get(_arrExt_, A_Index)
		;" 非使用者選取的，跳過，進行下一個迴圈
		If( True != oExt.checked ){
			Continue
		}
		value	:=	++checkedIndex/gObj.checkedNum*100		;" 進度估計值
		GuiControl,, _progressValue_, %value%	;" 更新進度條
		;" 記錄正在處理哪個套件
		fEditGuiAndFile( "`n`n" . A_Now . fLang("editHandle") . oExt.name . " (" . oExt.extID . ")" )	; ", 處理套件 "
		fCleanExtLocale(oExt)	;" 處理套件: 壓縮/解壓縮/刪除
	}
	
	fEditGuiAndFile( "`n`n" . A_Now . fLang("editFinished"))	; ", 全部完成，程式關閉。"
 	FileRemoveDir, % gObj.tempFolderPath, 1 ;" 刪除暫存資料夾
	MsgBox, 4096,, % fLang("msgFinished") ; "已完成！"
	ExitApp
}

fInitialize(){
	global gObj
	
	fLangCode()
	
	;;" 檢查
	QA_Create(arrSDP)				;" 建立一個陣列
	fQA_StringSplit(arrSDP, A_ScriptDir, "\")	;" 腳本路徑分段存入陣列
	fIsInExtensionsDir(arrSDP)		;" 檢查本程式放置之目錄
	
	lenSDP := QA_Length(arrSDP)
	QA_Remove(arrSDP, lenSDP)
	gObj.pathProfile := QA_ToString(arrSDP, "\")
	
	if( False = fCheck_7Zip() ){
		MsgBox,	4112,, % fLang("msgNoCompressionModule") ; "未安裝 7Zip !"
		ExitApp
	}
	
	FileCreateDir, % gObj.tempFolderPath  ;" 建立暫存資料夾
	fInit_arrExt_()	;" 獲得套件ID與名稱 
}

fInitialize()
fMainGui()	;" 主介面
Return

GuiClose:
	FileRemoveDir, % gObj.tempFolderPath, 1 ;" 刪除暫存資料夾
	ExitApp

_lHelpHomepage:	;" 首頁
	Run, http://forum.moztw.org/viewtopic.php?t=30196
	Return

_lHelpAbout:	;" 關於
	MsgBox,	4096,, % fLang("msgAbout")
	Return

_lLang_enUS:
	_langCode_ := "enUS_"
	Gui, Destroy
	Menu, LangMenu, DeleteAll	
	Menu, HelpMenu, DeleteAll
	Menu, MenuBar, DeleteAll
	fMainGui()
	Return

_lLang_zhTW:
	_langCode_ := "zhTW_"
	Gui, Destroy
	Menu, LangMenu, DeleteAll	
	Menu, HelpMenu, DeleteAll
	Menu, MenuBar, DeleteAll
	fMainGui()
	Return

_lSelectAll:	;" 全部勾選
	LV_Modify(0, "Check")
	Return

_lUnselectAll:	;" 全不勾選
	LV_Modify(0, "-Check")
	Return

_lSmart: ;" 智慧選擇
	fSmart()
	Return

_lClean:	;" 開始清理
	Gui, Submit	;" Saves the contents of each control to its associated variable
	fCheckLangTag(_textEditSave_)
	
	gObj.rowNumber := 0  ;" 列號
	Loop
	{
		gObj.rowNumber := LV_GetNext(gObj.rowNumber,"Checked")
		If not gObj.rowNumber  ;" 返回0，沒有被選中的列了
        Break
		LV_GetText(_elmExtID_, gObj.rowNumber, 2)	;" 第 2 欄
		oExt := fGetElmByID(_elmExtID_, _arrExt_)
		oExt.checked := True
		gObj.checkedNum := A_Index
	}

	If( fLang("LevelStore") = _level_ ){
		_level_ := 0	; "封存"
	}Else If( fLang("LevelFastest") = _level_ ){
		_level_ := 1	; "最快速"
	}Else If( fLang("LevelFast") = _level_ ){
		_level_ := 3	; "快速"
	}Else If( fLang("LevelNormal") = _level_ ){
		_level_ := 5	; "一般"
	}Else If( fLang("LevelMaximum") = _level_ ){
		_level_ := 7	; "最大"
	}Else If( fLang("LevelUltra") = _level_ ){
		_level_ := 9	; "極致"
	}
	Gui, Destroy
	fMain()
	Return
