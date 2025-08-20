pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: jnlp
    image: jenkins/inbound-agent:latest
    args: ['\$(JENKINS_SECRET)', '\$(JENKINS_NAME)']
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
      limits:
        memory: "512Mi"
        cpu: "500m"
  
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    command: ["/busybox/sleep", "9999"]
    resources:
      requests:
        memory: "1Gi"
        cpu: "500m"
      limits:
        memory: "2Gi"
        cpu: "1"
    volumeMounts:
      - name: kaniko-secret
        mountPath: /kaniko/.docker
    env:
      - name: DOCKER_CONFIG
        value: /kaniko/.docker
  
  - name: kubectl
    image: bitnami/kubectl:latest
    command: ["/bin/bash", "-c", "sleep 9999"]
    resources:
      requests:
        memory: "256Mi"
        cpu: "100m"
      limits:
        memory: "512Mi"
        cpu: "500m"

  volumes:
  - name: kaniko-secret
    secret:
      secretName: docker-credentials
      items:
        - key: .dockerconfigjson
          path: config.json
'''
        }
    }

    environment {
        DOCKER_IMAGE = 'wolfix1245/jenkins-app'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        KUBE_NAMESPACE = 'mamad'
        KUBE_MANIFEST = 'deployment.yaml'
    }

    stages {
        stage('Checkout') {
            steps {
                container('jnlp') {
                    git(
                        url: 'https://github.com/wolfix1234/test2.git',
                        branch: 'main',
                        credentialsId: 'github-credentials'
                    )
                }
            }
        }

        stage('Test') {
            steps {
                container('jnlp') {
                    sh 'echo "Running tests..."'
                    // Add your test commands here
                }
            }
        }

        stage('Build & Push Image') {
            steps {
                container('kaniko') {
                    script {
                        def fullImageName = "${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
                        sh """
                        /kaniko/executor \
                            --context=\$(pwd) \
                            --dockerfile=Dockerfile \
                            --destination=${fullImageName} \
                            --cache=true \
                            --cache-ttl=72h \
                            --verbosity=info
                        """
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                container('kubectl') {
                    script {
                        // Update image in deployment
                        sh """
                        kubectl set image deployment/my-app \
                          my-app-container=${env.DOCKER_IMAGE}:${env.DOCKER_TAG} \
                          -n ${env.KUBE_NAMESPACE}
                        """
                        
                        // Or apply full manifest
                        sh "kubectl apply -f ${env.KUBE_MANIFEST} -n ${env.KUBE_NAMESPACE}"
                    }
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                container('kubectl') {
                    sh """
                    kubectl rollout status deployment/my-app -n ${env.KUBE_NAMESPACE} --timeout=300s
                    """
                }
            }
        }
    }

    post {
        success {
            container('jnlp') {
                echo "✅ Pipeline completed successfully!"
                echo "📦 Image: ${env.DOCKER_IMAGE}:${env.DOCKER_TAG}"
            }
        }
        failure {
            container('jnlp') {
                echo "❌ Pipeline failed!"
            }
        }
    }
}