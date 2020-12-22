build-local:
	docker build -t presentation -f Dockerfile.local .

run-local:
	docker run -p 8080:80 presentation

###

GITHUB_SHA?=latest
IMAGE_TAG=sidpalas/codu-intro-to-devops:$(GITHUB_SHA)

build-production:
	docker build -t $(IMAGE_TAG) -f Dockerfile .

push-production:
	docker push $(IMAGE_TAG)

SSH_STRING:=root@134.122.14.216
CONTAINER_NAME:=presentation-caddy

ssh:
	ssh $(SSH_STRING)

ssh-cmd:
	ssh $(SSH_STRING) '$(CMD)'

stop-production:
	-$(MAKE) ssh-cmd CMD='docker pull $(IMAGE_TAG)'
	-$(MAKE) ssh-cmd CMD='docker stop $(CONTAINER_NAME)'
	-$(MAKE) ssh-cmd CMD='docker rm $(CONTAINER_NAME)'

run-production:
	-$(MAKE) stop-production
	$(MAKE) ssh-cmd CMD=' \
		docker run \
		--name=$(CONTAINER_NAME) \
		--restart=unless-stopped \
		-d \
		-p 80:80 \
		-p 443:443 \
		-v /caddy-data:/data \
		-v /caddy-config:/config \
		$(IMAGE_TAG) \
	'



