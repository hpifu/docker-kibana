repository=kibana

.PHONY: deploy remove build push

deploy:
	mkdir -p /var/docker/${repository}/data
	mkdir -p /var/docker/${repository}/log
	chown -R 1000:1000 /var/docker/${repository}/data
	chown -R 1000:1000 /var/docker/${repository}/log
	docker stack deploy -c stack.yml ${repository}

remove:
	docker stack rm ${repository}

logs:
	docker logs $$(docker ps --filter name=$(repository) -q)
