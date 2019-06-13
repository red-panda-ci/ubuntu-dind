#!groovy

@Library('github.com/red-panda-ci/jenkins-pipeline-library@v3.1.6') _

// Initialize global config
cfg = jplConfig('ubuntu-dind', 'docker', '', [slack: '#integrations', email:'redpandaci+ubuntudind@gmail.com'])

def publishDockerImages() {
    sh "docker rmi redpandaci/ubuntu-dind:test redpanda-ci/ubuntu-dind:latest redpandaci/ubuntu-dind:16.04 || true"
    jplDockerPush (cfg, "redpandaci/ubuntu-dind", "16.04", "", "https://registry.hub.docker.com", "redpandaci-docker-credentials")
    jplDockerPush (cfg, "redpandaci/ubuntu-dind", "latest", "", "https://registry.hub.docker.com", "redpandaci-docker-credentials")
}

pipeline {
    agent none

    stages {
        stage ('Initialize') {
            agent { label 'docker' }
            steps  {
                jplStart(cfg)
            }
        }
        stage ('Build') {
            agent { label 'docker' }
            steps {
                script {
                    docker.build('redpandaci/ubuntu-dind:test', '--no-cache .')
                }
            }
        }
        stage ('Test') {
            agent { label 'docker' }
            steps  {
                sh 'bin/test.sh'
            }
        }
        stage ('Make release'){
            // -------------------- automatic release -------------------
            agent { label 'docker' }
            when { branch 'release/new' }
            steps {
                publishDockerImages()
                jplMakeRelease(cfg, true)
            }
        }
        stage ('Release confirm') {
            // -------------------- manual release -------------------
            when { branch 'release/v*' }
            steps {
                publishDockerImages()
                jplPromoteBuild(cfg)
            }
        }
        stage ('Release finish') {
            agent { label 'docker' }
            when { expression { cfg.BRANCH_NAME.startsWith('release/v') && cfg.promoteBuild.enabled } }
            steps {
                publishDockerImages()
                jplCloseRelease(cfg)
            }
        }
    }

    post {
        always {
            jplPostBuild(cfg)
        }
    }

    options {
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(artifactNumToKeepStr: '20',artifactDaysToKeepStr: '30'))
        disableConcurrentBuilds()
        timeout(time: 1, unit: 'DAYS')
    }
}
