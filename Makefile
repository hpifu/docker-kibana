version=$(shell git describe --tags)
repository=kibana
user=hatlonely

.PHONY: deploy remove build push

deploy:
	mkdir -p ${HOME}/var/docker/${repository}/data
	mkdir -p ${HOME}/var/docker/${repository}/log
	chown -R 1000:1000 ${HOME}/var/docker/${repository}/data
	chown -R 1000:1000 ${HOME}/var/docker/${repository}/log
	docker stack deploy -c stack.yml ${repository}

remove:
	docker stack rm ${repository}

build:
	docker build --tag=${user}/${repository}:${version} .
	$(sedi) 's/image: ${user}\/${repository}:.*$$/image: ${user}\/${repository}:${version}/g' stack.tpl.yml > stack.yml

push:
	docker push ${user}/${repository}:${version}

logs:
	docker logs $$(docker ps --filter name=$(repository) -q)