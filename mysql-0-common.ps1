# mysql-0-common.ps1
# Глобальные переменные для всех скриптов

# Делаем переменные глобальными
$Global:ServiceName = "MySql95"
$Global:MySqlBin = "C:\Program Files\MySql\MySql Server 9.5\bin"
$Global:DefaultDrive = "D:"
$Global:DefaultPath = "\.mysql-data"
$Global:DataDir = "$DefaultDrive$DefaultPath"
$Global:MySqlPort = 3306
$Global:MySqlUser = "root"
$Global:MySqlPassword = "12345678"

# Экспортируем переменные в родительскую область
# Export-ModuleMember -Variable * -ErrorAction SilentlyContinue


# Функция для проверки запуска сервера
function Global:TestMySqlRunning {
    $portCheck = netstat -ano | findstr ":$Global:MySqlPort.*LISTENING"    # Проверяем, стартовал ли сервер
    Write-Host "Проверяем активацию сервера... " -ForegroundColor Yellow -NoNewline
    if ($portCheck) { Write-Host "✅ Сервер активен" -ForegroundColor Green } 
	else { Write-Host "❌ Сервер неактивен" -ForegroundColor Red }    
    return [bool]$portCheck
}

# Функция для проверки установки сервера
function Global:TestMySqlInstall {
	$service = Get-Service -Name $Global:ServiceName -ErrorAction SilentlyContinue    # Проверяем, установлен ли сервер
    Write-Host "Проверяем установлен ли сервер... " -ForegroundColor Yellow -NoNewline
    if ($service) 
	{ 
		Write-Host "✅ Сервер уже установлен" -ForegroundColor Green 
		if (TestMySqlRunning) { .\mysql-3-mysql-console  } else { .\mysql-2-restart } # проверяем, стартовал ли сервер
	} 
	else 
	{ 
		Write-Host "❌ Сервер не установлен, запуск прекращен" -ForegroundColor Red
		exit 1
	}    
    #return [bool]$portCheck
}

# Функция для получения PID сервера
function Global:Get-MySqlPid {
    $portCheck = netstat -ano | findstr ":$Global:MySqlPort.*LISTENING"
    if ($portCheck) {
        return ($portCheck -split '\s+')[-1]
    }
    return $null
}

# Функция для подключения к MySql
function Global:ConnectMySql {
    param(
        [string]$Query,
        [switch]$UsePassword
    )
    
    if ($UsePassword) {
        & "$Global:MySqlBin\mySql" -u $Global:MySqlUser -p$Global:MySqlPassword -e "$Query" 2>&1
    } else {
        & "$Global:MySqlBin\mySql" -u $Global:MySqlUser -e "$Query" 2>&1
    }
}


# Функция прогресса
function Global:Progress {
    param (
        [int]$num,
        [string]$message,
        [ConsoleColor]$color = "Yellow"  # цвет по умолчанию - желтый
    )
    Write-Host "$message" -ForegroundColor $color  -NoNewline
    for ($i = 1; $i -le $num; $i++) {
        Start-Sleep -Seconds 1
        Write-Host "." -NoNewline
    }
	Write-Host ""
}

Write-Host "✅ Глобальные переменные загружены:" -ForegroundColor Green
Write-Host "   ServiceName: $Global:ServiceName" -ForegroundColor Gray
Write-Host "   MySqlBin: $Global:MySqlBin" -ForegroundColor Gray
Write-Host "   DefaultDrive: $Global:DefaultDrive" -ForegroundColor Gray
Write-Host "   DefaultPath: $Global:DefaultPath" -ForegroundColor Gray
Write-Host "   DataDir: $Global:DataDir" -ForegroundColor Gray
Write-Host "   MySqlPort: $Global:MySqlPort" -ForegroundColor Gray