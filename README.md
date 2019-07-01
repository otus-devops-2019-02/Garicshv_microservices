# Garicshv_microservices
Garicshv microservices repository

**ВЫПОЛНЕНО ДЗ №12**  
Вывод команды docker images сохранен в файл docker-monolith/docker-1.log
Изучены:  
* docker run и docker start и docker attach
* docker exec -it <container> <command> # выполнение команды в контецнере в foreground режиме 
* docker commit # commit изменений в образ и его сохранение
* docker system df # информация о занимаемом месте инфраструктурой docker
* docker rm и docker rmi -f # удаление imgaes
* docker rm $(docker ps -a -q) # удаление всех незапущенных конейнеров


**ВЫПОЛНЕНО ДЗ №13**  
**Docker Machine**  
* Выполнен Init проетка для google cloud 
* Выполнена аутентификация в gcloud 
* Установлены локально пакеты docker-machine
* Создана docker machine с именем docker-host
* Подготовлены скрипты mongod.conf, db_config, start.sh
* Создан свой Dockerfile
* Создан image reddit:latest из Dockerfile
* Проверен запуск кнтейнера в docker machine
* Через GCP создано правило firewall reddit-app для открытия порта 9292
* Проверена работа контейнера в docker machine на порту 9292
  
**Docker Hub**  
* Произведена регистрация в hub.docker.com и последующая локальная аутентификация
* Создан и загружен в hub.docker.com образ. Затем образ загружен локально при выполнении команды docker run (т.к. локального образа не оказалось).
* Выполнена проверка контейнеров после после манипуляций внутри и снаружи
  
