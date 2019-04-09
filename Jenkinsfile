#!groovy

@Library('github.com/red-panda-ci/jenkins-pipeline-library@v2.7.0') _

// Initialize global config
cfg = jplConfig('ubuntu-dind', 'docker', '', [slack: '#integrations', email:'redpandaci+ubuntudind@gmail.com'])

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
        stage ('Release confirm') {
            when { branch 'release/v*' }
            steps {
                jplPromoteBuild(cfg)
            }
        }
        stage ('Release finish') {
            agent { label 'docker' }
            when { expression { cfg.BRANCH_NAME.startsWith('release/v') && cfg.promoteBuild.enabled } }
            steps {
                sh "docker rmi redpandaci/ubuntu-dind:test redpanda-ci/ubuntu-dind:latest redpandaci/ubuntu-dind:16.04 || true"
                jplDockerPush (cfg, "redpandaci/ubuntu-dind", "16.04", "", "https://registry.hub.docker.com", "redpandaci-docker-credentials")
                jplDockerPush (cfg, "redpandaci/ubuntu-dind", "latest", "", "https://registry.hub.docker.com", "redpandaci-docker-credentials")
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
        skipDefaultCheckout()
        timeout(time: 1, unit: 'DAYS')
    }
}
