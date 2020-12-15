build-local:
	docker build -t presentation -f Dockerfile.local .

run-local:
	docker run -p 8080:80 presentation

VM_IP:=104.236.4.10
IMAGE_TAG:=sidpalas/devops-directive-codechef:v0.1

build-production:
	docker build -t $(IMAGE_TAG) -f Dockerfile .

push-production:
	docker push $(IMAGE_TAG)

ssh:
	ssh root@$(VM_IP)

# docker run -p 80:80 -p 443:443 -v /caddy-data:/data -v /caddy-config:/config sidpalas/devops-directive-codechef:v0.1
