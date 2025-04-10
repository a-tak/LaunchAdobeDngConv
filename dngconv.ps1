﻿﻿﻿﻿﻿﻿﻿﻿# デスクトップにログファイルを作成
$LogFile = "$env:USERPROFILE\Desktop\dngconv_log.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
"[$timestamp] 処理開始: スクリプト実行" | Out-File -FilePath $LogFile -Encoding UTF8

# 引数の処理
"[$timestamp] 受け取った引数: $args" | Out-File -FilePath $LogFile -Append -Encoding UTF8

# 引数が存在するか確認
if ($args.Count -eq 0 -or [string]::IsNullOrWhiteSpace($args[0])) {
    "[$timestamp] エラー: 入力フォルダが指定されていません。引数を確認してください。" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    exit 1
}

# 入力フォルダを設定
$InputFolder = $args[0]
"[$timestamp] 入力フォルダ: $InputFolder" | Out-File -FilePath $LogFile -Append -Encoding UTF8

# 入力フォルダの存在確認
if (-Not (Test-Path $InputFolder)) {
    "[$timestamp] エラー: 指定されたフォルダが存在しません: $InputFolder" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    exit 1
}

# 出力先フォルダを設定（入力フォルダの一つ上）
try {
    $OutputFolder = Split-Path -Parent $InputFolder
    if ([string]::IsNullOrWhiteSpace($OutputFolder)) {
        throw "出力先フォルダの取得に失敗しました"
    }
    "[$timestamp] 出力先フォルダ: $OutputFolder" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}
catch {
    "[$timestamp] エラー: 出力先フォルダの設定に失敗しました: $_" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    exit 1
}

# Adobe DNG Converterのパスを設定
$DNGConverter = "C:\Program Files\Adobe\Adobe DNG Converter\Adobe DNG Converter.exe"

# RAWファイルの拡張子リスト
$RawExtensions = @(".arw", ".cr2", ".cr3", ".nef", ".orf", ".raf", ".rw2", ".dng", ".raw")

# RAWファイルのみを処理
$RawFiles = Get-ChildItem -Path $InputFolder -File | Where-Object { $RawExtensions -contains $_.Extension.ToLower() }
"[$timestamp] 変換対象RAWファイル数: $($RawFiles.Count)" | Out-File -FilePath $LogFile -Append -Encoding UTF8

if ($RawFiles.Count -eq 0) {
    "[$timestamp] 警告: 変換対象のRAWファイルが見つかりませんでした" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}
else {
    foreach ($file in $RawFiles) {
        $message = "[$timestamp] 変換中: ファイル - $($file.Name)"
        $message | Out-File -FilePath $LogFile -Append -Encoding UTF8
        
        # 期待される出力ファイル名を生成（拡張子を.dngに変更）
        $outputFileName = [System.IO.Path]::ChangeExtension($file.Name, ".dng")
        $outputFilePath = Join-Path $OutputFolder $outputFileName
        
        # Adobe DNG Converterを呼び出し、処理完了を待機
        Start-Process -FilePath $DNGConverter -ArgumentList "-c", "-d", $OutputFolder, $file.FullName -Wait -NoNewWindow
        
        # 出力ファイルの存在を確認
        if (Test-Path $outputFilePath) {
            "[$timestamp] 変換成功: $($file.Name) -> $outputFileName" | Out-File -FilePath $LogFile -Append -Encoding UTF8
        }
        else {
            "[$timestamp] 変換失敗: $($file.Name) (出力ファイルが生成されませんでした)" | Out-File -FilePath $LogFile -Append -Encoding UTF8
        }
    }
}

"[$timestamp] 処理完了" | Out-File -FilePath $LogFile -Append -Encoding UTF8

# 出力先フォルダをExplorerで開く
"[$timestamp] 出力先フォルダを開きます: $OutputFolder" | Out-File -FilePath $LogFile -Append -Encoding UTF8
Start-Process "explorer.exe" -ArgumentList $OutputFolder

# 変換失敗があった場合はログファイルを開く
if (Get-Content $LogFile | Select-String "変換失敗:") {
    "[$timestamp] 変換失敗があったためログファイルを開きます" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    Invoke-Item $LogFile
}
