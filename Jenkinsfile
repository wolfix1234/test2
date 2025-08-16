pipeline {
    agent any

    environment {
        REGISTRY = "docker.io/wolfix1245"
        APP_NAME = "jen"
        KUBE_NAMESPACE = "mamad"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/wolfix1234/test2.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("${REGISTRY}/${APP_NAME}:${BUILD_NUMBER}")
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-creds') {
                        dockerImage.push()
                        dockerImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    kubectl set image deployment/${APP_NAME} ${APP_NAME}=${REGISTRY}/${APP_NAME}:${BUILD_NUMBER} -n ${KUBE_NAMESPACE} --record || \
                    kubectl create deployment ${APP_NAME} --image=${REGISTRY}/${APP_NAME}:${BUILD_NUMBER} -n ${KUBE_NAMESPACE}
                    
                    kubectl expose deployment ${APP_NAME} --type=NodePort --port=3000 -n ${KUBE_NAMESPACE} || true
                    """
                }
            }
        }
    }
}
