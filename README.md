# Dockerfile Best Practice with the Flask

## Build the docker image

```
docker build -t <image name>:<version tag> /<dockerfile path>
```

## Run the container with the image

```
docker run -d -p <localhost poer>:<container port> <image name>:<version tag>
```