Jenkinsfile


pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/wolfix1234/test2.git'
            }
        }
        stage('Build') {
            steps {
                echo 'Simulating a build step...'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
            }
        }
    }
}
