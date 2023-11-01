pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                echo 'Pulling from Git...'
                git credentialsId: 'GitHubCred', url: 'https://github.com/mehdikaouech/Font-devops.git'
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }
stage('Setup Xvfb') {
    steps {
        xvfb(displayName: 'Xvfb', installationName: 'Xvfb', screen: '0 1280x1024x24', timeout: 60)
  sh 'npm run test'
    }
}

       

        stage('Build Docker Image') {
            steps {
                script {
                    buildNumber = currentBuild.number
                    imageTag = "1.0.${buildNumber}"
                    withCredentials([usernamePassword(credentialsId: "DockerHubCredentials", usernameVariable: "DOCKERHUB_USERNAME", passwordVariable: "DOCKERHUB_PASSWORD")]) {
                        dockerImage = docker.build("mehdikaouech/jenkins-front:${imageTag}")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: "DockerHubCredentials", usernameVariable: "DOCKERHUB_USERNAME", passwordVariable: "DOCKERHUB_PASSWORD")]) {
                        sh "docker login --username ${DOCKERHUB_USERNAME} --password ${DOCKERHUB_PASSWORD}"
                        sh "docker push mehdikaouech/jenkins-front:${imageTag}"
                    }
                }
            }
        }
    }
}
