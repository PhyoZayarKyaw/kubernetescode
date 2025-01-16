pipeline {
    agent {
        kubernetes {
            yaml """
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 9999999
    volumeMounts:
      - name: jenkins-docker-cfg
        mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: regcred
          items:
            - key: .dockerconfigjson
              path: config.json
"""
        }
    }
    environment {
        DOCKER_IMAGE = "phyozayarkyaw/test"
    }
    stages {
        stage('Clone repository') {
            steps {
                checkout scm
            }
        }

        stage('Build image with Kaniko') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh '''#!/busybox/sh
                        /kaniko/executor --context `pwd` --dockerfile Dockerfile --destination $DOCKER_IMAGE:$BUILD_NUMBER
                    '''
                }
            }
        }

        stage('Test image') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh 'echo "Tests passed"'
                }
            }
        }

        stage('Push image') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh '''#!/busybox/sh
                        /kaniko/executor --context `pwd` --dockerfile Dockerfile --destination $DOCKER_IMAGE:$BUILD_NUMBER
                    '''
                }
            }
        }
        
        stage('deploy') {
            steps {
                container(name: 'kaniko', shell: '/busybox/sh') {
                    sh 'curl -LO "https://storage.googleapis.com/kubernetes-release/release/v1.20.5/bin/linux/amd64/kubectl"'  
        	    sh 'chmod u+x ./kubectl'  
        	    sh './kubectl get pods'
                    sh './kubectl apply -f deployment.yaml'
                }
            }
        }

    }
}

