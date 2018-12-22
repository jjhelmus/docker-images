docker run --rm --privileged multiarch/qemu-user-static:register --reset
wget https://github.com/multiarch/qemu-user-static/releases/download/v3.0.0/qemu-ppc64le-static
chmod +x qemu-ppc64le-static

DOCKERIMAGE=linux-anvil-ppc64le
docker build -t condaforge/$DOCKERIMAGE -f $DOCKERIMAGE/Dockerfile .