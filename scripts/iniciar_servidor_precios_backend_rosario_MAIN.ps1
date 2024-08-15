$title = "Servidor Precios Backend Rosario main"
$colorLetras = "Cyan"
$colorFondo = "Black"
$Host.UI.RawUI.BackgroundColor = $colorFondo
$Host.UI.RawUI.ForegroundColor = $colorLetras
Clear-Host
$path_errores_main = "C:\Users\Server\Desktop\scriptsTunnels\scripts\errores\errores_main.txt"
Start-Process -FilePath "npm" -ArgumentList "run start" -WorkingDirectory "A:\proyectos\BuscadorPreciosRosarioBackend" -NoNewWindow -RedirectStandardError $path_errores_main
#npm --prefix A:\proyectos\BuscadorPreciosRosarioBackend\ run start 2> $path_errores_main