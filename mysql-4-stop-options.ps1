# mysql-4-stop-options.ps1

Write-Host "`n=== 4. ВЫХОД ИЗ КОНСОЛИ ===" -ForegroundColor Cyan

# Проверяем, добавлена ли папка скриптов в PATH
$scriptsPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$inPath = $currentPath -like "*$scriptsPath*"

if (-not $inPath) {
Write-Host "`nДобавить папку со скриптами в PATH? (y/n)" -ForegroundColor Yellow -NoNewline
$choice = Read-Host
if ($choice -eq 'y') {
        $newPath = "$currentPath;$scriptsPath"
        [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
        $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + $newPath
        Write-Host "✅ Добавлено. Теперь скрипты доступны отовсюду" -ForegroundColor Green
    }
}

# Спрашиваем про остановку сервера
Write-Host "`nОстановить сервер? (y/n) " -ForegroundColor Yellow -NoNewline
$stopChoice = Read-Host
if ($stopChoice -eq 'y') { .\mysql-5-stop.ps1 } 
else { Write-Host "Сервер продолжает работу. Для остановки: mysql-5-stop.ps1" -ForegroundColor Green }
