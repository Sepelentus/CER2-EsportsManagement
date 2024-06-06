# CER2-EsportsManagement
Certamen realizado para desarrollo de aplicaciones moviles, basado en Flutter y FastAPI para la DB

Se utiliza "venv" para la API, debe crearse el entorno para luego poder instalar FastAPI

> python -m venv {path} | 
> pip install -r requirements.txt (Dentro de venv)

Recordar iniciar el entorno (venv) para poder instalar los paquetes de python!

> venv/scripts/activate (En powershell)

Para partir el servidor
Requisitos:
> Docker
Comandos utilizados para crear bd en mysql:
> docker run --name mysqldatabase -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=test mysql
Una vez creada la bd dentro de docker, puedes correr el servidor utilizando el comando:
>uvicorn server:app --reload
Este comando debe ser ejecutado dentro de la carpeta FastAPI_DB.