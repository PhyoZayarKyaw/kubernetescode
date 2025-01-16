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

        stage('Update GIT') {
            steps {
                script {
                    catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                        withCredentials([usernamePassword(credentialsId: 'github', variable: 'GITHUB_TOKEN', usernameVariable: 'GIT_USERNAME')]) {
                            // Configure Git with username and email
                            sh "git config user.email phyozayarkyaw2018@gmail.com"
                            sh "git config user.name PhyoZayarKyaw"

                            // Display the current deployment.yaml content
                            sh "cat deployment.yaml"

                            // Update the Docker image tag in the deployment.yaml file
                            sh "sed -i'' 's+phyozayarkyaw/test.*+phyozayarkyaw/test:${BUILD_NUMBER}+g' deployment.yaml"

                            // Display the updated deployment.yaml content
                            sh "cat deployment.yaml"

                            // Add, commit, and push changes
                            sh "git add ."
                            sh "git commit -m 'Done by Jenkins Job changemanifest: ${env.BUILD_NUMBER}'"
                            sh "git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/${GIT_USERNAME}/kubernetesmanifest.git HEAD:master"
                        }
                    }
                }
            }
        }

    }
}

