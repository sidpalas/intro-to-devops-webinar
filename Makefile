build-local:
	docker build -t presentation -f Dockerfile.local .

run-local:
	docker run -p 8080:80 presentation

VM_IP:=104.236.4.10
GITHUB_SHA?=latest
IMAGE_TAG:=sidpalas/devops-directive-codechef:$(GITHUB_SHA)
CONTAINER_NAME:=caddyserver

build-production:
	docker build -t $(IMAGE_TAG) -f Dockerfile .

push-production:
	docker push $(IMAGE_TAG)

ssh:
	ssh root@$(VM_IP)

ssh-cmd:
	ssh root@$(VM_IP) '$(CMD)'

stop-remote:
	-$(MAKE) ssh-cmd CMD='docker pull $(IMAGE_TAG)'
	-$(MAKE) ssh-cmd CMD='docker stop $(CONTAINER_NAME)'
	-$(MAKE) ssh-cmd CMD='docker rm $(CONTAINER_NAME)'

run-remote: 
	-$(MAKE) stop-remote
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