pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'wolfix1245/jen:latest'
        KUBE_DEPLOYMENT = 'jeny.yaml'
    }
    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/wolfix1234/test2.git', branch: 'main'
            }
        }
        stage('Build Image') {
            steps {
                script {
                    docker.build(DOCKER_IMAGE)
                }
            }
        }
        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-creds') {
                        docker.image(DOCKER_IMAGE).push()
                    }
                }
            }
        }
        stage('Deploy to K8s') {
            steps {
                sh "kubectl apply -f ${KUBE_DEPLOYMENT}"
            }
        }
    }
}