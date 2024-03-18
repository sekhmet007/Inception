all:
	@docker-compose -f ./srcs/docker-compose.yml up -d --build

down:
	@docker-compose -f ./srcs/docker-compose.yml down

stop:
	@docker stop $$(docker ps -qa)

re: down all

clean:
	@docker stop $$(docker ps -qa);\
	docker rm $$(docker ps -qa);\
	docker rmi -f $$(docker images -qa);\
	docker network rm $$(docker network ls -q);\
	docker system prune -a --force

fclean: clean
	@docker volume rm $$(docker volume ls -q);\
	sudo rm -rf /home/ecullier/data/mysql/*;\
	sudo rm -rf /home/ecullier/data/wordpress/*;\
	sudo rm -rf /home/ecullier/data/mariadb/*;

.PHONY: all re down stop clean fclean
