#!/usr/bin/env bash

default_out=`tput sgr0` # white

describe () {
    local msg info_out
    msg=$1
    info_out=`tput setaf 3` # yellow
    echo "${info_out} $msg${default_out}"
}

describe_suite(){
    local msg info_out
    msg=$@
    info_out=`tput setaf 6` # blue
    echo "${info_out}$msg${default_out}"   
}

describe_success(){
    local msg success_out
    msg=$1
    success_out=`tput setaf 2` # green
    echo "${success_out}  $msg${default_out}"
}

describe_failure(){
    local msg failure_out
    msg=$1
    failure_out=`tput setaf 1` # red
    echo "${failure_out}  $msg${default_out}"
}

should() {
    local  container is_success msg 
    container=$1
    is_success=$2
    msg=$3

    if [[ "$is_success" = "0" ]]; then
        describe_success "Successful: $msg"
    else
        describe_failure "Fail: $msg"
        destroy_container $container
        exit 1
    fi
}

run_test_container(){
    local container
    container=$(docker run --privileged -d --rm redpandaci/ubuntu-dind:test sleep 300)
    echo $container
}

destroy_container(){
  local container destroy 
  container=$1  
  destroy=$(docker rm -f $container)
  echo $destroy
}

docker_version_test(){
    local container expected_version
    container=$1
    expected_version="17.12.0-ce"
    version=$(docker exec $container docker -v | cut -d "," -f 1 | cut -d " " -f 3)

    if [[ "$expected_version" = "$version" ]]; then
        echo 0
    else   
        echo 1
    fi
}

docker_compose_version_test(){
    local container expected_version
    container=$1
    expected_version="1.18.0"
    version=$(docker exec $container docker-compose -v | cut -d "," -f 1 | cut -d " " -f 3)

    if [[ "$expected_version" = "$version" ]]; then
        echo 0
    else   
        echo 1
    fi
}

rancher_compose_version_test(){
    local container expected_version
    container=$1
    expected_version="v0.12.5"
    version=$(docker exec $container rancher-compose -v | cut -d " " -f 3)

    if [[ "$expected_version" = "$version" ]]; then
        echo 0
    else   
        echo 1
    fi
}

node_version_test(){
    local container expected_version
    container=$1
    expected_version="v8.9.4"
    version=$(docker exec $container /root/.nvm/versions/node/v8.9.4/bin/node -v)

    if [[ "$expected_version" = "$version" ]]; then
        echo 0
    else   
        echo 1
    fi
}

main() {
    local ubuntu_dind
    ubuntu_dind=$(run_test_container)

    describe_suite "start ubuntu-dind test suite for container: $ubuntu_dind" 
        describe "docker version test"
            should $ubuntu_dind $(docker_version_test $ubuntu_dind) "Have docker with the correct version"

        describe "docker-compose version test"
            should $ubuntu_dind $(docker_compose_version_test $ubuntu_dind) "Have docker-compose with the correct version" 

        describe "rancher-compose test"
            should $ubuntu_dind $(rancher_compose_version_test $ubuntu_dind) "Have rancher-compose with the correct version" 
        
        describe "node test"
            should $ubuntu_dind $(node_version_test $ubuntu_dind) "Have node with the correct version and nvm is intalled correctly"
    describe_suite "container destroyed" $(destroy_container $ubuntu_dind)

    exit 0
}

main "$@"