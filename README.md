# Scripts para reiniciar tuneles locales (localtunnel y ngrok)

---

## Proposito

- _Reiniciar los tuneles creados por localtunnel y ngrok en el servidor local_; debido a que en el plan gratuito estos tuneles vecen cada ciertas horas hice estos scripts para reiniciar sus servicios, lo cual genera un nuevo tunel, luego se suben los enlaces de dichos tuneles a un repositorio de GitHub ( [Repositorio](https://github.com/davidoreiro97/endpointsAppsTesting.git) ). Estos enlaces luego serán utilizados por los proyectos de prueba que hago.

---

## Contenido

- Carpeta "scripts"

  - reset_localtunnel.ps1 : Este script de Powershell tiene por objetivo : detener localtunnel si está funcionando
    , generar dos documentos de texto en la ruta ./endpointsParaGithub/archivosTemp llamados "localtunnel_pid.txt" y "localtunnel_url.txt", estos contienen el número de proceso de localtunnel para matarlo luego y volverlo a iniciar y
    la url del tunnel generado.

  - reset_ngrok.ps1 : Hace lo mismo que el script de localtunnel solo que para ngrok, se utilizan dos tuneles ya que no son
    muy estables al ser gratuitos.

  - generar_endpointsjson_y_git_push.ps1 : Este script utiliza una ER para obtener la urls guardadas en localtunnel_url.txt y
    nrgok_url.txt, luego de esto arma un json con las dos rutas de los tuneles y los sube al repositorio (el cual previamente)
    se debe configurar ( [Repositorio](https://github.com/davidoreiro97/endpointsAppsTesting.git) ).

- Carpeta "endpointsParaGithub"

  - Carpeta archivosTemp : Contiene documentos de texto generados por los scripts en los cuales se guardan los PID y las url
    a los tuneles, con los PID se puede reiniciar los procesos, con las url se arma el json para subir a GitHub.

  - endpoints.json : Este archivo es el resultado final de generar_endpointsjson_y_git_push.ps1 el cual se sube a GitHub cada
    vez que se actualizan los endpoints.

---

## Configuración

- Iniciar el repositorio de GitHub y agregar como origen remoto donde se guardarán los endpoints para luego poder hacer el push
  en el script generar_endpointsjson_y_git_push.ps1 .
- Previamente debe estar instalado ngrok([ngrok](https://ngrok.com/)) y localtunnel([localtunnel](https://theboroer.github.io/localtunnel-www/))
- Editar dentro del script "reset_localtunnel.ps1" :

  - $nodePath : Cambiar la ruta hacia donde esté instalado node.exe .
  - $ltPath : Cambiar la ruta hacia donde estén los binarios de localtunnel.
  - $port_lt : Puerto donde correra localtunnel
  - $urlPath_lt : Ruta donde se guardará la url del tunel de localtunnel.
  - $pidPath_lt : Ruta donde se guardará el PID de localtunnel.
  - $script_generar_endpoint_push : Ruta donde se guardará el script que generará el json y hará el push.

- Editar dentro del script "generar_endpointsjson_y_git_push.ps1" :

  - $localtunnel_path_url : Ruta donde se guardará el archivo de texto que contiene la url de localtunnel.
  - $endpointsJSON_path : Ruta donde se guardará el archivo json con las url, el cual luego será subido a github.
  - $addcommitpush_path : Ruta donde está el archivo json y en donde se realizará el push.

- Crear tareas programadas en Windows :
  - Se debe crear dos tareas programadas, una que ejecute "reset_localtunnel.ps1" cada 12h y otra que ejecute "reset_ngrok.ps1" cada 6h o menos.

---

#### Programar las tareas para ejecutarlas en Windows

[Video tutorial](https://youtu.be/CJw_JEt_L6I?t=258)
