$title = "Servidor Precios Backend Rosario main"
$colorLetras = "Cyan"
$colorFondo = "Black"
$Host.UI.RawUI.BackgroundColor = $colorFondo
$Host.UI.RawUI.ForegroundColor = $colorLetras
$Host.UI.RawUI.WindowTitle = $title
Clear-Host
Function Prompt{
    $Host.UI.RawUI.WindowTitle = $title
    "PS> "
}
$path_errores_main = "C:\Users\Server\Desktop\scriptsTunnels\scripts\errores\errores_main.txt"
npm --prefix A:\proyectos\BuscadorPreciosRosarioBackend\ run start 2> $path_errores_main