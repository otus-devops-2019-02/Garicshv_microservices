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
* docker rm $(docker ps -a -q) #  удаление всех незапущенных конейнеров


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

**ВЫПОЛНЕНО ДЗ №15**  
**HOST NETWORK DRIVER**  
* Запустиkb несколько раз: 
```
> docker run --network host -d nginx
```
Каков результат? Что выдал docker ps? Как думаете почему?  
Ответ: остался один запущенный nginx контейнер, т.к. остальные (последующие) завершили свою работу (при попытке старта) из-за занятости namespace
Если выполнять запуск контейнеров командой  
```
> docker run --network none -d nginx
```
то мы можем видеть, что новые контейнеры успешно стартуют. Команда ip netns на doocker-host при этом показывает создание новых net-namespaces.
* Создана bridge сеть
```
docker network create reddit --driver bridge 
```
* Запущены контейнеры с алиасами:
```
docker run -d --network=reddit --network-alias=post_db --networkalias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post garicshv/post:1.0
docker run -d --network=reddit --network-alias=comment garicshv/comment:1.0
docker run -d --network=reddit -p 9292:9292 garicshv/ui:1.0
```
проверена работоспособность веб приложения  
**BRIDGE NETWORK DRIVER**  
* Запущен наш проект в двух сетях. Для этого созданы сети
```
docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24

...
echo "Запускаем контейнеры:"
docker run -d --network=front_net -p 9292:9292 --name ui garicshv/ui:1.0
docker run -d --network=back_net --name comment garicshv/comment:1.0
docker run -d --network=back_net --name post garicshv/post:1.0
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest

...

echo "Подключение контейнеров к сетям"
docker network connect front_net post
...
docker network connect front_net comment

...

echo "Проверяем успешность запуска приложения в web"
curl "http:////35.233.100.182:9292"
...
```
* Проанализирован сетевой стек linux
```
docker-machine ssh docker-host
sudo apt-get update && sudo apt-get install bridge-util

...

docker network ls

...

ifconfig | grep br

...

brctl show br-4ac81d1bf266
bridge name 	bridge id 	STP 	enabled interfaces
br-4ac81d1bf266 8000.0242ae9beade no 	vethaf41855
 					vethe115d8d
# Через iptables проверено создание правило DNAT для цепочки DOCKER:

sudo iptables
sudo iptables -nL -t nat
```
* Выполнена проверка наличия хотя бы одного запущеннго прокси:
```
 ps ax | grep docker-proxy
```

**docker-compose.yml**
* установлен docker-compose
* В директории src создан файл docker-compose.yml
* Создана переменная среды USERNAME и экспортирована. Внесена в файл. Проверена работа:
```
docker-compose up -d
docker compose ls
```
* Изменен docker-compose файл под кейс с множеством сетей (front_net, back_net)
* Параметризован с помощью переменных окружений порт ui, версии сервисов
* Параметры вынесены в файл .env
* Файл .env добавлен в .gitignore
* В репозиторий закоммичен файл .env.example 
При запуске проекта все создаваемые docker-compose сущности имеют одинаковый префикс, явлющийся базовым именем проекта. Чтобы изменить этот префикс, то можно использовать ключ -d:
```
docker-compose -p QQQ up -d
```
**ВЫПОЛНЕНО ДЗ №16**
* создали пайплайн с этапами build, test, deploy
* создали runner
* создали описание пайплайна в .gitlab-ci.yml 
* установлена библиотека для тестирования reddit/Gemfile
**Dev-окружение**
* создали stage review
* сделали deploy_dev_job
* добавили environment
```
deploy_dev_job:
 stage: review
 script:
   - echo 'Deploy'
 environment:
   name: dev
   url: http://dev.example.com
```
**Staging и Production**
* Определены два этапа stagge и production
* Задано ручное выполнение джоба
```
staging:
 stage: stage
 when: manual
 script:
   - echo 'Deploy'
 environment:
   name: stage
   url: https://beta.example.com
```
**Условия и ограничения**   
* Проверена директива only, которая описывает список условий, которые должны быть истинны, чтобы job мог запуститься. Регулярное выражение означает, что должен стоять semver тэг в git, например, 2.4.10: 
```
 stage: production
 when: manual
 only:
   - /^\d+\.\d+\.\d+/
 script:
   - echo 'Deploy'
 environment:
   name: production
   url: https://example.com
```
запукать необходимо так:
```
git commit -a -m ‘#4 add logout button to profile page’
git tag 2.4.10
git push gitlab gitlab-ci-1 --tags
```

**ВЫПОЛНЕНО ДЗ №17**  
* приведена в порядок структура репозитория
* создан docker/docker-compose.yml - который описывает всю инфраструктуру с докерами (сервисы)
* создан monitoring/prometheus/Dockerfile - описывает в паре строк как собирать образ prometheus
* создан monitoring/prometheus/prometheus.yml - описывает конфигурацию (эндпоинты) мониторинга в prometheus
* проверен мониторинг (healthcheck) таргетов ui, comment в prometheues в выключенном состоянии post и включенном по списке эндпоинтов и по графам метрик
* добавлен сервис node-exporter в docker-compose, в proetherus.yml отражен новый таргет для мониторинга, проверен мониторинг CPU
* Образы запушены (по адресу **https://cloud.docker.com/u/garichsv/repository/list**) в docker hub:
	* comment
	* ui
	* prometheus
	* post


