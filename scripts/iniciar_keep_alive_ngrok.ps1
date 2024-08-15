#Ngrok ira en el servidor de redundancia que está en el puerto 6000.
$port = 6000

$urlPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\ngrok_url.txt"
$urlPath_errors = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\ngrok_errors.txt"
$pidPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\ngrok_pid.txt"
$script_generar_endpoint_push = "C:\Users\Server\Desktop\scriptsTunnels\scripts\generar_endpointsjson_y_git_push.ps1"


$api_ngrok_url_tuneles = "https://api.ngrok.com/tunnels"
$ngrok_api_token_path = "C:\Users\Server\Desktop\scriptsTunnels\ngrok_api_token.txt"
$ngrok_api_token = Get-Content -Path $ngrok_api_token_path

$restartInterval = 2 * 60 * 60  # 2 * 60 * 60 - 2 horas en segundos
$elapsedTime = 0  # Tiempo transcurrido en segundos para reiniciar.

function Get-Url-Tunel {
    # Funcion que realiza un get a la api de ngrok la cual muestra información sobre los tuneles abiertos
    # Devuelve la url del tunel online.
    $response = Invoke-RestMethod -Uri $api_ngrok_url_tuneles -Method Get `
        -Headers @{
            "Authorization" = "Bearer $ngrok_api_token"
            "Ngrok-Version" = "2"
        }
    return $response.tunnels[0].public_url
}

function Start-Ngrok {
    while ($true) {
        Write-Host "Iniciando ngrok redireccionando al puerto $port"
        $process = Start-Process -FilePath "C:\Windows\System32\cmd.exe" -ArgumentList "/k", "ngrok http 6000" -RedirectStandardError $urlPath_errors -PassThru
        $process.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::High
        Start-Sleep -Seconds 5
        Get-Url-Tunel | Out-File -FilePath $urlPath
        $process.Id | Out-File -FilePath $pidPath
        Start-Sleep -Seconds 5
        $urlGenerada = Get-Content -Path $urlPath
        if($urlGenerada -ne "" -and $urlGenerada -ne $null){
            Write-Warning "Nuevo proceso Ngrok iniciado con PID $($process.Id)."
            Start-Sleep -Seconds 5
            #Script para generar el json y subirlo a Github.
            &$script_generar_endpoint_push
            return $process
        } else {
            Write-Error "El proceso con PID : $($process.Id) se reiniciará ya que no devolvió una URL."
            Stop-Process -Id $process.Id -ErrorAction Stop
            $ngrokProcesses = Get-Process -Name "ngrok" -ErrorAction SilentlyContinue
            if ($ngrokProcesses) {
                foreach ($process in $ngrokProcesses) {
                    Write-Warning "Deteniendo proceso Ngrok con PID $($process.Id)"
                    Stop-Process -Id $process.Id -Force -ErrorAction Continue
                }
            }
            Start-Sleep -Seconds 5  # Espera breve antes de intentar de nuevo
        }
        return $process
    }
}

function Check-ProcessById {
    param (
        [int] $process_id
    )
    try{
    $process = Get-Process -Id $process_id -ErrorAction Continue 
    return $true
    }catch{
    return $false
    }
}

# Leer el PID de ngrok si existe
if (Test-Path $pidPath) {
    $pidNgrok = Get-Content -Path $pidPath
    $pidNgrok_int = [int] $pidNgrok  # Se castea como INT
    $result = Check-ProcessById -process_id $pidNgrok_int
    if ($result) {
        Write-Warning "Proceso Ngrok con PID $pidNgrok detenido (se trata de detener igual aunque no esté)."
        $ngrokProcesses = Get-Process -Name "ngrok" -ErrorAction SilentlyContinue
        if ($ngrokProcesses) {
            foreach ($process in $ngrokProcesses) {
                Write-Warning "Deteniendo proceso Ngrok con PID $($process.Id)"
                Stop-Process -Id $process.Id -Force -ErrorAction Continue
            }
        }
    } else {
        Write-Warning "No se pudo detener el proceso Ngrok con PID $pidNgrok. Puede que ya esté detenido."
    }
    $process = Start-Ngrok
}

# Mantener el proceso vivo y reiniciar cada 2 horas
while ($true) {
    # Comprobar si el proceso se ha cerrado (esto se debería hacer con una matriz obtenida en Get-Process -Name "ngrok", pero me quiero ir a dormir)
    if ($process.HasExited) {
        Write-Error "El proceso Ngrok con PID $($process.Id) se cerró. Reiniciando..."
        $process = Start-Ngrok
        $elapsedTime = 0  # Reiniciar el contador de tiempo
    }
    Start-Sleep -Seconds 1
    $elapsedTime++
    # Comprobar si ha pasado el intervalo de reinicio
    if ($elapsedTime -ge $restartInterval) {
        Write-Warning "Reiniciando el proceso Ngrok con PID $($process.Id) despuesde 2 horas..."
        Stop-Process -Id $process.Id -ErrorAction Continue
        $ngrokProcesses = Get-Process -Name "ngrok" -ErrorAction SilentlyContinue
        if ($ngrokProcesses) {
            foreach ($process in $ngrokProcesses) {
                Write-Warning "Deteniendo proceso Ngrok con PID $($process.Id)"
                Stop-Process -Id $process.Id -Force -ErrorAction Continue
            }
        }
        $process = Start-Ngrok
        $elapsedTime = 0  # Reiniciar el contador de tiempo
    }
}
