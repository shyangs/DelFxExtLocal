# DelFxExtLocal
刪除用不著的 Firefox 套件語系。

公開發佈於 [MozTW討論區](http://forum.moztw.org/viewtopic.php?t=30196)。


### 使用說明：

* 強烈建議：執行本程式前，請先備份個人設定檔。
* DelFxExtLocal.exe 放到個人設定檔底下的 extensions 資料夾，點兩下執行。
* 執行過程中，請不要取消檔案複製。
* 預設會保留 en-US、zh-CN、zh-TW、zh-HK 四個語系（可自訂）。
* META-INF 是[套件簽章](https://developer.mozilla.org/docs/Signing_a_XPI)，當套件檔案變動後，安裝該 XPI 檔會因簽章驗證錯誤而無法安裝。0.4 版加入刪除 META-INF 功能，預設啟用。

### 疑難排解：

* 如果出現 "請安裝 [7-Zip](http://www.7-zip.org/)，或將 7za.exe 與 DelFxExtLocal.exe 置於同一目錄。" 訊息視窗，請依提示做下述操作（三選一）：
 * 安裝 7-Zip
 * 將 7za.exe 與 DelFxExtLocal.exe 置於同一目錄。
 * 將 7z.exe, 7z.dll 與 DelFxExtLocal.exe 置於同一目錄。


### 已知問題：

* DelFxExtLocal 全版本，有可能造成 Firefox 錯判部份套件的相容性。暫時解法：按下套件更新，或者用強制相容；目前不清楚 Firefox 對套件檔案變動的相容性判斷機制，無法修復這個 Bug。如果有人知道可以告訴我。
* DelFxExtLocal v0.3.1 (含)之前的版本無法正確處理 LastPass Password Manager 與 QuickDrag。0.4 版似乎解決了這個 bug ，遺憾的是我不曉得是哪幾行程式碼的改動解決了這個 bug ，因此以後有可能復發。

### 下載點：

* [DelFxExtLocal v0.7 主程式](http://forum.moztw.org/download/file.php?id=11938)
* [7za.exe](http://forum.moztw.org/download/file.php?id=11337): 7-Zip standalone command line version. (7-Zip 的獨立命令列執行版)
