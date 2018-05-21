node {
    dir('demo') {
        // Mark the code checkout 'stage'....
        stage('Checkout from GitHub') {
            git url: 'https://github.com/franciscolopezv/azure-voting-app-redis'
        }

        // Build and Deploy to ACR 'stage'... 
        stage('Build and Push to Azure Container Registry') {

                sh ‘docker-compose build’

                docker.withRegistry('https://creuvoted01.azurecr.io', 'acr_credentials') {
                
                sh ‘docker push creuvoted01.azurecr.io/azure-vote-front:latest’

                }
        }
    }
}