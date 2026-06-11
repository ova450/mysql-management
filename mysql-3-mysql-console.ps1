# mysql-3-mysql-console.ps1

Write-Host "`n=== 3. КОНСОЛЬ MYSQL ===" -ForegroundColor Cyan
# Запускаем консоль mysql
& "$MySqlBin\mysql" -u root -p

# После выхода из консоли
.\mysql-4-stop-options.ps1