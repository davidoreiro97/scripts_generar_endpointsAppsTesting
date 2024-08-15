$title = "Servidor Precios Backend Rosario redundancia"
$colorLetras = "Green"
$colorFondo = "Black"
$Host.UI.RawUI.BackgroundColor = $colorFondo
$Host.UI.RawUI.ForegroundColor = $colorLetras
Clear-Host
$path_errores_redundancia = "C:\Users\Server\Desktop\scriptsTunnels\scripts\errores\errores_redundancia.txt"
Start-Process -FilePath "npm" -ArgumentList "run start" -WorkingDirectory "A:\proyectos\BuscadorPreciosRosarioBackend_redundancia" -NoNewWindow -RedirectStandardError $path_errores_redundancia
#npm --prefix A:\proyectos\BuscadorPreciosRosarioBackend_redundancia  run start
