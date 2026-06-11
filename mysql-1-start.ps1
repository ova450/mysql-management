# mysql-1-start.ps1
Write-Host "`n=== 1. СТАРТ СЕРВЕРА ===" -ForegroundColor Cyan

# Переходим в папку, где лежит сам скрипт
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

# Подгружаем common, если переменные не загружены
if (-not (Get-Variable -Name MySqlBin -ErrorAction SilentlyContinue)) {  .\mysql-0-common.ps1 }

# Проверяем установку
TestMySqlInstall