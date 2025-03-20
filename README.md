# Adobe DNG Converter実行スクリプト

## 概要

このスクリプトは指定されたフォルダのRAWファイルをAdobe DNG Converterを呼び出してDNGファイルに変換するものです。
Adobe DNG Converterはインストールされていることが前提でWindows環境で動作します。

FreeFileSyncでコピーが完了した後に呼び出されることを想定しています。

## FreeFileSyncでの指定

FreeFIleSyncでは `コマンドを実行` の `完了時の動作` で下記のようなコマンドを実行する想定です。


```powershell
powershell.exe -ExecutionPolicy Bypass -File "D:\Documents\PowerShell\dngconv\dngconv.ps1" %csidl_Pictures%\一眼写真\%Year%\%Date%_\RAW
```

引数のフォルダ指定は環境に合わせて変更が必要。

上記例のでは `%csidl_Pictures%\一眼写真\%Year%\%Date%_\RAW` にRAWファイルが配置される先です。

## dngconv.ps1

Adobe DNG Converterを呼び出す処理を行います。

引数で渡されたフォルダ内のRAWファイルをAdobe DNG ConverterでDNGに変換します。

DNGファイルの出力先はひとつ上のフォルダとします。

動作状況はデスクトップにログファイルとして書き出します。
