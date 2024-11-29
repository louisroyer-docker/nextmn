.PHONY: docker

all: docker/upf docker/srv6 docker/srv6-ctrl docker/ue-lite docker/gnb-lite docker/cp-lite
docker/%:
	docker buildx build -t louisroyer/dev-nextmn-$(@F) ./$(@F)
