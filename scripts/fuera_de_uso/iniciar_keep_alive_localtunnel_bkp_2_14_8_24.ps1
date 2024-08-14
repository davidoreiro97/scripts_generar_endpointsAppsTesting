# Configuración
$nodePath = "C:\Program Files\nodejs\node.exe"
$ltPath = "C:\Users\Server\AppData\Roaming\npm\node_modules\localtunnel\bin\lt.js"
$port = 3000

$urlPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_url.txt"
$urlPath_errors = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_errors.txt"
$pidPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_pid.txt"
$script_generar_endpoint_push = "C:\Users\Server\Desktop\scriptsTunnels\scripts\generar_endpointsjson_y_git_push.ps1"
$urlGenerada = ""

$restartInterval = 6 * 60 * 60  # 6 * 60 * 60 - 6 horas en segundos
$elapsedTime = 0  # Tiempo transcurrido en segundos para reiniciar.

unction Start-LocalTunnel {
    while ($true) {
        $process = Start-Process -FilePath $nodePath -ArgumentList "$ltPath --port $port" -RedirectStandardOutput $urlPath -RedirectStandardError $urlPath_errors -PassThru
        $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
        Start-Sleep -Seconds 3
        $process.Id | Out-File -FilePath $pidPath
        $urlGenerada = Get-Content -Path $urlPath

        if($urlGenerada -ne "" -and $urlGenerada -ne $null){
            Write-Warning "Nuevo proceso localtunnel iniciado con PID $($process.Id)."
            Start-Sleep -Seconds 5
            # Script para generar el json y subirlo a Github.
            &$script_generar_endpoint_push
            return $process
        } else {
            Write-Error "El proceso con PID : $($process.Id) se reiniciará ya que no devolvió una URL."
            Stop-Process -Id $process.Id -ErrorAction Stop
            Start-Sleep -Seconds 2  # Espera breve antes de intentar de nuevo
        }
    }
}

function Check-ProcessById {
    param (
        [int] $process_id
    )
    try{
    $process = Get-Process -Id $process_id -ErrorAction Stop 
    return $true
    }catch{
    return $false
    }
}

# Leer el PID de localtunnel si existe
if (Test-Path $pidPath) {
    $pidlocaltunnel = Get-Content -Path $pidPath
    $pidlocaltunnel_int = [int] $pidlocaltunnel  # Se castea como INT
    $result = Check-ProcessById -process_id $pidlocaltunnel_int
    if ($result) {
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
        Write-Error "El proceso localtunnel con PID $($process.Id) se cerró. Reiniciando..."
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
