# Recupera el contenido de localtunnel_url.txt y ngrok_url.txt los cuales contienen las url de los últimos tuneles generados.
# Esto luego se sube a github para compartirlo con las aplicaciones que lo utilizan.
$localtunnel_path_url = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\localtunnel_url.txt"
$ngrok_path_url = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\archivosTemp\ngrok_url.txt"
$endpointsJSON_path = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub\endpoints.json"
$addcommitpush_path = "C:\Users\Server\Desktop\scriptsTunnels\endpointsParaGithub"

if ((Test-Path $localtunnel_path_url) -and (Test-Path $ngrok_path_url)) {
    $localtunnel_content = Get-Content -Path $localtunnel_path_url
    $localtunnel_content -match 'https:\/\/[^\s]*' | Out-Null
    $localtunnel_url_sola = $matches[0]
    $ngrok_url_sola = Get-Content -Path $ngrok_path_url
    $contenido_json = "{`"url_localtunnel`": `"$localtunnel_url_sola`",`"url_ngrok`": `"$ngrok_url_sola`"}"

    try{
        $contenido_json | Out-File -FilePath $endpointsJSON_path -Encoding utf8
        Write-Host "+ -------------------------------------------------------------------------------- +"
        Write-Host "$ngrok_url_sola ESCRITA EN $endpointsJSON_path CORRECTAMENTE"
        Write-Host "$localtunnel_url_sola ESCRITA EN $endpointsJSON_path CORRECTAMENTE"
        Write-Host "+ -------------------------------------------------------------------------------- +"
    }catch{
        Write-Error "ERROR ESCRIBIENDO $localtunnel_url_sola y $ngrok_url_sola EN $endpointsJSON_path"
    }

    Start-Sleep -Seconds 5

    try{
      Set-Location -Path $addcommitpush_path
      git add .
      git commit -m "Actualización de los endpoints."
      git push origin master
      Write-Host "ARCHIVO JSON CON LOS ENDPOINTS SUBIDOS CORRECTAMENTE"
    }catch{
      Write-Error "ERROR SUBIENDO EL JSON CON LOS ENDPOINTS"      
    }  
}

