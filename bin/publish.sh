#!/usr/bin/env bash

set -xe

cond(){
    if [ "$1" ] ; then
        echo "$2"
    else
        echo "$3"
    fi
}

update_package_version(){
  local version; version=$1
  npm version --no-git-tag-version $version
}

update_changelog(){
  npm run changelog
}

update_image_version_to_docker_compose(){
  local search replace
  search=$1
  replace=$2
  sed -i -e "s%$search*%$replace%g" docker-compose.yml
}

publish_image(){
  local image; image=$1
  docker build -t $image .
  docker push $image
  docker rmi -f $image
}

update_git_flow_branches(){
  local version commit_msg relelase_branch
  version=$1
  commit_msg="New: Release to $version"
  relelase_branch=$(git rev-parse --abbrev-ref HEAD)

  git add .
  git commit -m "$commit_msg"
  git tag -a v$version -m "$commit_msg"
  git checkout develop
  git merge $relelase_branch
  git checkout master
  git merge $relelase_branch
  git push origin develop
  git push origin master
  git push --tags
  git checkout $relelase_branch
}

main(){
  local RELEASE
  RELEASE=$(cond "$RELEASE" "$RELEASE" "$1")
  IMAGE="redpandaci/ubuntu-dind"

  RELEASE_IMAGE="$IMAGE:$RELEASE"
  LATEST_IMAGE="$IMAGE:latest"

  update_package_version $RELEASE
  update_changelog
  # update_image_version_to_docker_compose $IMAGE $RELEASE_IMAGE
  publish_image $RELEASE_IMAGE
  publish_image $LATEST_IMAGE
  update_git_flow_branches $RELEASE
  
}

main "$@"