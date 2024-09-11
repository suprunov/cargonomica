# Функция для проверки, запущен ли скрипт с правами администратора
function Test-IsElevated {
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [System.Security.Principal.WindowsPrincipal]$id
    return $principal.IsInRole([System.Security.Principal.WindowsBuiltinRole]::Administrator)
}

# Если скрипт не запущен с правами администратора, перезапускаем его с правами администратора
if (-not (Test-IsElevated)) {
    # Получаем путь к текущему скрипту
    $scriptPath = $MyInvocation.MyCommand.Definition
    
    # Запускаем PowerShell с правами администратора и передаем текущий скрипт
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
    exit
}

wsl --shutdown

# Получаем список всех установленных дистрибутивов WSL
$distributions = wsl --list --all | Select-String -Pattern "^Ubuntu"

# Проходим по каждому найденному дистрибутиву и выполняем unregister
foreach ($dist in $distributions) {
    $distName = $dist.ToString().Trim()
    Write-Output "Unregistering $distName..."
    wsl --unregister $distName
}

Write-Output "Unregistration of all Ubuntu distributions completed."

# Получаем путь к каталогу AppData\Local\Packages текущего пользователя
$packagesPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, "Packages")

# Находим все папки в указанном каталоге, названия которых содержат "ubuntu" без учета регистра
$foldersToDelete = Get-ChildItem -Path $packagesPath -Directory -Recurse | Where-Object { $_.Name -match "ubuntu" }

# Удаляем найденные папки вместе с содержимым
foreach ($folder in $foldersToDelete) {
    Write-Output "Удаление папки: $($folder.FullName)"
    try {
        Remove-Item -Path $folder.FullName -Recurse -Force
    }
    catch {
        Write-Output "Ошибка при удалении: $($_.Exception.Message)"
        # Добавляем задержку и пробуем удалить снова
        Start-Sleep -Seconds 5
        try {
            Remove-Item -Path $folder.FullName -Recurse -Force
        }
        catch {
            Write-Output "Не удалось удалить после повторной попытки: $($_.Exception.Message)"
        }
    }
}
Write-Output "Удаление завершено."
