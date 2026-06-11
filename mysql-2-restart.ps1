# mysql-2-restart.ps1

Write-Host "`n=== 2. РЕСТАРТ СЕРВЕРА ===" -ForegroundColor Cyan

# Удаляем проблемные undo файлы (баг MySQL 9.x на Windows)
if (Test-Path $DataDir) {
    Get-ChildItem -Path $DataDir -Filter "undo_*" -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "  Удаляем: $($_.Name)" -ForegroundColor Gray
        Remove-Item -Path $_.FullName -Force
    }
}

# Запускаем сервер
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = "$MySqlBin\mysqld.exe"
$psi.Arguments = "--console --datadir=`"$DataDir`""
$psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
$psi.CreateNoWindow = $true
# Сохраняем в глобальную переменную
$Global:MySQLProcess = [System.Diagnostics.Process]::Start($psi)

# Ждём пока встанет
Write-Host "Запускаем сервер..." -ForegroundColor Yellow
$started = $false
$timeout = 10
$times = 5
for ($i = 1; $i -le $times; $i++){
Progress $timeout "Ожидаем  " -color Gray
   if (TestMySqlRunning) {
        $started = $true
		Write-Host "" #-NoNewline
        break
    }
}
		
 # Проверяем запуск
if (TestMySqlRunning) {
	Progress 3 "✅ Сервер активирован, переходим в консоль mysql" -color Green
	 .\mysql-3-mysql-console.ps1
	} 
else {
	#Progress 5 "❌ Сервер не запустился, останавливаем запуск " -color Red
    Write-Host "❌ Сервер не запустился, останавливаем выполнение скрипта" -ForegroundColor Red
    Write-Host "`n=== ДИАГНОСТИКА ===" -ForegroundColor Yellow
    Write-Host "  psi.FileName: $($psi.FileName)"
    Write-Host "  psi.Arguments: $($psi.Arguments)"
    Write-Host "  psi.WindowStyle: $($psi.WindowStyle)"
    Write-Host "  psi.CreateNoWindow: $($psi.CreateNoWindow)"
    Write-Host "  process.Id: $($Global:MySQLProcess.Id)"
    Write-Host "  process.HasExited: $($process.HasExited)"

	# Проверяем код завершения процесса
    if ($process.HasExited) {  Write-Host "  process.ExitCode: $($process.ExitCode)" -ForegroundColor Red  }
    
    # Ищем лог ошибок MySQL
    $logPath = "$DataDir\*.err"
    if (Test-Path $DataDir) {
        $logs = Get-ChildItem $logPath -ErrorAction SilentlyContinue
        if ($logs) {
            Write-Host "`n=== ПОСЛЕДНИЕ ОШИБКИ ИЗ ЛОГА MYSQL ===" -ForegroundColor Red
            $logs | Sort-Object LastWriteTime -Descending | Select-Object -First 1 | ForEach-Object {
                Get-Content $_.FullName -Tail 15
            }
        } else {
            Write-Host "`n⚠️ Лог-файл не найден" -ForegroundColor Yellow
        }
    }  
    exit 1
}
