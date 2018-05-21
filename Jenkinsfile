node {
    dir('demo') {
        // Mark the code checkout 'stage'....
        stage('Checkout from GitHub') {
            git url: 'https://github.com/franciscolopezv/azure-voting-app-redis'
        }

        // Build and Deploy to ACR 'stage'... 
        stage('Build and Push to Azure Container Registry') {

                sh ‘docker-compose build’

                app = docker.build("creuvoted01.azurecr.io/azure-vote-front")

                docker.withRegistry('https://creuvoted01.azurecr.io', 'acr_credentials') {
                app.push("${env.BUILD_NUMBER}")
                app.push("latest") 
            }
        }
    }
}