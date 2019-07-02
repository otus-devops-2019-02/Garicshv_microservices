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
  
**ВЫПОЛНЕНО ДЗ №14**  
  
* Созданые Dockerfile's для post, comment, ui и исправлены ошибки отсутствия зависимостей
* Скачан образ mongo:latest и созданы образы garicshv/post:1.0, garicshv/comment:1.0, garicshv/ui:2.0
* Создан bridge network reddit, добавили сетевые алиасы, которые могут использоваться как доменные имена для сетевых соединений
* Создан новый образ ui:2.0 на основе ubuntu:16.04. В результате размер образа уменьшился существенно.
* Создан persistent volume и применен для команды run контейнера с mongodb. Проверить можно по адресу: http://35.233.100.182:9292/  

**ВЫПОЛНЕНО ДЗ №14**
**HOST NETWORK DRIVER**
**Задача**: Запустите несколько раз (2-4): 
```
> docker run --network host -d nginx
```
Каков результат? Что выдал docker ps? Как думаете почему?  
Ответ: остался один запущенный nginx контейнер, т.к. остальные (последующие) завершили свою работу (при попытке старта) из-за занятости портов в рамках одного namespace
Если выполнять запуск контейнеров командой
```
> docker run --network none -d nginx
```
то мы можем видеть, что новые контейнеры успешно стартуют. Команда ip netns на doocker-host при этом показывает создание новых net-namespaces.
