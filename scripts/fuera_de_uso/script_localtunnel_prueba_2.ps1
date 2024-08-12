# Configuración
$nodePath = "C:\Program Files\nodejs\node.exe"
$ltPath = "C:\Users\Server\AppData\Roaming\npm\node_modules\localtunnel\bin\lt.js"
$port = 3000

$urlPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_url.txt"
$urlPath_errors = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_errors.txt"
$pidPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_pid.txt"
$script_generar_endpoint_push = "C:\Users\Server\Desktop\scriptsTunnels\scripts\generar_endpointsjson_y_git_push.ps1"

$restartInterval = 6 * 60 * 60  #6 horas en segundos
$elapsedTime = 0  # Tiempo transcurrido en segundos

function Start-LocalTunnel {
    $process = Start-Process -FilePath $nodePath -ArgumentList "$ltPath --port $port" -RedirectStandardOutput $urlPath -RedirectStandardError $urlPath_errors -PassThru
    $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
    $process.Id | Out-File -FilePath $pidPath
    Write-Warning "Nuevo proceso localtunnel iniciado con PID $($process.Id)."
    Start-Sleep -Seconds 5
    # Script para generar el json y subirlo a Github.
    &$script_generar_endpoint_push
    return $process
}

function Check-ProcessById {
    param (
        [int]$Pid
    )
    try {
        $process = Get-Process -Id $Pid -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

# Leer el PID de localtunnel si existe
if (Test-Path $pidPath) {
    $pidlocaltunnel = Get-Content -Path $pidPath
    $pidlocaltunnel_int = [int]$pidlocaltunnel  # Se castea como INT
    $result = Check-ProcessById -Pid $pidlocaltunnel_int
    if ($result) {
        Stop-Process -Id $pidlocaltunnel_int -ErrorAction Stop
        Write-Warning "Proceso localtunnel con PID $pidlocaltunnel_int detenido."
    } else {
        Write-Warning "No se pudo detener el proceso localtunnel con PID $pidlocaltunnel_int. Puede que ya esté detenido."
    }
    $process = Start-LocalTunnel
}

# Mantener el proceso vivo y reiniciar cada 6 horas
while ($true) {
    # Comprobar si el proceso se ha cerrado
    if ($process.HasExited) {
        Write-Warning "El proceso localtunnel con PID $($process.Id) se cerró. Reiniciando..."
        $process = Start-LocalTunnel
        $elapsedTime = 0  # Reiniciar el contador de tiempo
    }
    Start-Sleep -Seconds 1
    $elapsedTime++
    # Comprobar si ha pasado el intervalo de reinicio
    if ($elapsedTime -ge $restartInterval) {
         Write-Warning "Reiniciando el proceso localtunnel con PID $($process.Id) despuesde 6 horas..."
        Stop-Process -Id $process.Id -ErrorAction Stop
        $process = Start-LocalTunnel
        $elapsedTime = 0  # Reiniciar el contador de tiempo
    }
}
