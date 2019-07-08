
BUILD_ID ?= ${USER}
VERSION  ?= edge
REPO_VER ?= ${VERSION}

GIT_USER  ?= $(shell git config --get user.name)
GIT_EMAIL ?= $(shell git config --get user.email)

export _repositories
override define _repositories
http://dl-cdn.alpinelinux.org/alpine/${REPO_VER}/main
http://dl-cdn.alpinelinux.org/alpine/${REPO_VER}/community
endef

export _gitconfig
override define _gitconfig
[user]
	name  = ${GIT_USER}
	email = ${GIT_EMAIL}
endef


.PHONY: build
build:
	mkdir -p user.abuild
	echo "$$_gitconfig" > gitconfig
	echo "$$_repositories" > repositories
	docker build --build-arg VERSION=${VERSION} -t apk_builder:${BUILD_ID} .


builder: build
	docker run -it \
		-v ${PWD}/packages:/work \
		-v ${PWD}/user.abuild/:/home/packager/.abuild \
		-v ${PWD}/gitconfig/:/home/packager/.gitconfig \
		apk_builder:${BUILD_ID} \
		sh

clean:
	docker rmi apk_builder:${BUILD_ID}
