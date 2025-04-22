# Adobe DNG Converter実行スクリプト

## 概要

このスクリプトは指定されたフォルダのRAWファイルをAdobe DNG Converterを呼び出してDNGファイルに変換するものです。
Adobe DNG Converterはインストールされていることが前提でWindows環境で動作します。

FreeFileSyncでコピーが完了した後に呼び出されることを想定しています。

## 設定ファイル

スクリプトの動作は`config.json`で設定できます。初回実行時は`config.sample.json`をコピーして`config.json`を作成してください。

設定可能な項目：
- `dngConverter`: Adobe DNG Converterの実行ファイルパス
- `rawExtensions`: 変換対象のRAWファイル拡張子リスト
- `logFile`: ログファイルの出力先パス
- `postProcessing`: 変換後に実行する後処理プログラムの設定（オプション）
  - `name`: プログラム名
  - `enabled`: 有効/無効
  - `path`: 実行ファイルのパス
  - `arguments`: コマンドライン引数
  - `waitForExit`: 完了を待つかどうか

## FreeFileSyncでの指定

FreeFIleSyncでは `コマンドを実行` の `完了時の動作` で下記のようなコマンドを実行する想定です。

```powershell
powershell.exe -ExecutionPolicy Bypass -File "[このスクリプトを置いた場所 ex) c:\scripts]\dngconv.ps1" [出力先 ex)%csidl_Pictures%\一眼写真\%Year%\%Date%_\RAW ※%Year%などはFreeFileSyncのマクロ]
```

引数のフォルダ指定は環境に合わせて変更が必要。

上記例のでは `%csidl_Pictures%\一眼写真\%Year%\%Date%_\RAW` にRAWファイルが配置される先です。

DNGファイルの出力先はひとつ上のフォルダです。
動作状況は指定したフォルダにログファイルとして書き出されます。

## FreeFileSyncのマクロ

https://freefilesync.org/manual.php?topic=macros
