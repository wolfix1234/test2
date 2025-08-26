pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - sleep
    args:
    - 99d
    volumeMounts:
    - name: docker-config
      mountPath: /kaniko/.docker
  volumes:
  - name: docker-config
    secret:
      secretName: docker-config
'''
        }
    }
    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/wolfix1234/test2.git', branch: 'main'
            }
        }
        stage('Build and Push with Kaniko') {
            steps {
                container('kaniko') {
                    sh '''
                    /kaniko/executor --dockerfile=Dockerfile --context=. --destination=wolfix1245/jen:latest
                    '''
                }
            }
        }
        stage('Deploy to Cluster') {
            steps {
                sh 'kubectl apply -f deployment.yaml -n mamad'
            }
        }
    }
}