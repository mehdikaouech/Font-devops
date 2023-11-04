pipeline {
    agent any

    stages {
        stage('Git Checkout Front') {
            steps {
                echo 'Pulling from Git...'
                git credentialsId: 'GitHubCred', url: 'https://github.com/mehdikaouech/Font-devops.git'
            }
        }
    stage('Préparation de l'environnement') {
            steps {
                sh '''
                source ~/.bashrc  # Assurez-vous que NVM est activé
                nvm use 14  # Sélectionnez la version de Node.js
                npm install  # Installez les dépendances du projet
                '''
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
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
