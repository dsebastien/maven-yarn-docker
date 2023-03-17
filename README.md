# maven-yarn-docker
Dockerfile which builds an image containing maven and yarn build tools

## Releasing a new version
- Make your changes
- Edit `build-and-push.sh` to set the new version in `IMAGE_VERSION`
- Commit/Tag/Push
- Draft a new release on Github
- run `./build-and-push.sh` to build the image and push it to DockerHub

## TODO
Evaluate `alpine-sdk` as replacement for `g++ make gcc`
