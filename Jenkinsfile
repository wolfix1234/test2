pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'wolfix1245/jenkins-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        KUBE_NAMESPACE = 'mamad'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Wrap in node block to get executor
                    node {
                        git(
                            url: 'https://github.com/wolfix1234/test2.git',
                            branch: 'main'
                        )
                    }
                }
            }
        }

        stage('Build & Push with Kaniko') {
            steps {
                script {
                    // Use podTemplate with node wrapper
                    podTemplate(
                        containers: [
                            containerTemplate(
                                name: 'kaniko', 
                                image: 'gcr.io/kaniko-project/executor:latest',
                                command: 'sleep',
                                args: '999999',
                                ttyEnabled: true
                            )
                        ],
                        volumes: [
                            secretVolume(
                                secretName: 'docker-credentials',
                                mountPath: '/kaniko/.docker'
                            )
                        ]
                    ) {
                        node(POD_LABEL) {
                            container('kaniko') {
                                sh """
                                /kaniko/executor \
                                    --context=\$(pwd) \
                                    --dockerfile=Dockerfile \
                                    --destination=${env.DOCKER_IMAGE}:${env.DOCKER_TAG} \
                                    --cache=true \
                                    --verbosity=info
                                """
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    node {
                        sh """
                        kubectl apply -f deployment.yaml -n ${env.KUBE_NAMESPACE}
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            script {
                // Simple echo without container for post actions
                echo "Build completed with status: ${currentBuild.currentResult}"
            }
        }
        success {
            echo "✅ Pipeline succeeded! Image: ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
        }
        failure {
            echo "❌ Pipeline failed!"
        }
    }
}