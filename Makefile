.PHONY: docker

all: docker/srv6 docker/srv6-ctrl
docker/%:
	docker buildx build -t louisroyer/dev-nextmn-$(@F) ./$(@F)
