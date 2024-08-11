# Recupera el contenido de localtunnel_url.txt y ngrok_url.txt los cuales contienen las url de los últimos tuneles generados.
# Esto luego se sube a github para compartirlo con las aplicaciones que lo utilizan.
# FALTA EL DE NGROK.
$localtunnel_path_url = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_url.txt"
$endpointsJSON_path = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\endpoints.json"
$addcommitpush_path = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub"

if (Test-Path $localtunnel_path_url) {
    $localtunnel_content = Get-Content -Path $localtunnel_path_url
    $localtunnel_content -match 'https:\/\/[^\s]*' | Out-Null
    $localtunnel_url_sola = $matches[0]
    $contenido_json = "{`"url_localtunnel`": `"$localtunnel_url_sola`"}"

    try{
        $contenido_json | Out-File -FilePath $endpointsJSON_path -Encoding utf8
        Write-Output "$localtunnel_url_sola ESCRITA EN $endpointsJSON_path CORRECTAMENTE"
    }catch{
        Write-Warning "ERROR ESCRIBBIENDO $localtunnel_url_sola EN $endpointsJSON_path"
    }

    Start-Sleep -Seconds 5

    try{
      Set-Location -Path $addcommitpush_path
      git add .
      git commit -m "Actualización de los endpoints."
      git push origin master
      Write-Output "ARCHIVO JSON CON LOS ENDPOINTS SUBIDOS CORRECTAMENTE"
    }catch{
      Write-Output "ERROR SUBIENDO EL JSON CON LOS ENDPOINTS"      
    }  
}

