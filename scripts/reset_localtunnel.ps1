# Este script detiene localtunnel si está funcionando, genera dos txt con su PID y la url obtenida.
$nodePath = "C:\Program Files\nodejs\node.exe"
$ltPath = "C:\Users\Server\AppData\Roaming\npm\node_modules\localtunnel\bin\lt.js"
$port = 3000
$urlPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_url.txt"
$pidPath = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_pid.txt"
$script_generar_endpoint_push = "C:\Users\Server\Desktop\scriptsTunnels\scripts\generar_endpointsjson_y_git_push.ps1"

# Leer el PID de localtunnel si existe
if (Test-Path $pidPath) {
    $pidlocaltunnel = Get-Content -Path $pidPath

    if ($pidlocaltunnel -ne $null -and $pidlocaltunnel -ne "") {
        try {
            Stop-Process -Id $pidlocaltunnel -ErrorAction Stop
            Write-Output "Proceso localtunnel con PID $pidlocaltunnel detenido."
        } catch {
            Write-Warning "No se pudo detener el proceso localtunnel con PID $pidlocaltunnel. Puede que ya esté detenido."
        }
    }
}

# Ejecutar localtunnel y redirigir la salida
$process = Start-Process -FilePath $nodePath -ArgumentList "`"$ltPath`" --port $port" -RedirectStandardOutput $urlPath -PassThru -NoNewWindow

# Guardar el nuevo PID en un archivo
$process.Id | Out-File -FilePath $pidPath

Write-Output "Nuevo proceso localtunnel iniciado con PID $($process.Id)."

#Esperamos 5s y ejecutamos el script para generar el json y subirlo a Github.
Start-Sleep -Seconds 5
&$script_generar_endpoint_push