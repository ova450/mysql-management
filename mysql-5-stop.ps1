# mysql-5-stop.ps1

Write-Host "`n=== 5. ОСТАНОВКА СЕРВЕРА ===" -ForegroundColor Cyan

# Убиваем все процессы mysqld
$mysqldProcesses = Get-Process -Name mysqld -ErrorAction SilentlyContinue

if ($mysqldProcesses) {
    $mysqldProcesses | Stop-Process -Force
    Write-Host "Остановлено процессов: $($mysqldProcesses.Count)" -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

# Проверка
if (TestMySqlRunning) {
	Write-Host "`n❌ Сервер не остановился" -ForegroundColor Red
    exit 1
} else {
    Write-Host "`n✅ Сервер остановлен" -ForegroundColor Green
}

# 3. Чтобы окно не закрылось
Read-Host "`nНажмите Enter для выхода"