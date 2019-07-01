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
