$title = "Servidor Precios Backend Rosario redundancia"
$colorLetras = "Green"
$colorFondo = "Black"
$Host.UI.RawUI.BackgroundColor = $colorFondo
$Host.UI.RawUI.ForegroundColor = $colorLetras
$Host.UI.RawUI.WindowTitle = $title
Clear-Host
Function Prompt{
    $Host.UI.RawUI.WindowTitle = $title
    "PS> "
}
$path_errores_main = "C:\Users\Server\Desktop\scriptsTunnels\scripts\errores\errores_redundancia.txt"
npm --prefix A:\proyectos\BuscadorPreciosRosarioBackend_redundancia  run start
