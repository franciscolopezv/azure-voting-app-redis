node {
    dir('demo') {
        def app

        // Mark the code checkout 'stage'....
        stage('Checkout from GitHub') {
            git url: 'https://github.com/franciscolopezv/azure-voting-app-redis'
        }

        // Build and Deploy to ACR 'stage'... 
        stage('Build and Push to Azure Container Registry') {
                withCredentials(
                        [string(credentialsId: 'azure-client-id', variable: 'azure_client_id'), 
                        string(credentialsId: 'azure-client-secret', variable: 'azure_client_secret_value'), 
                        string(credentialsId: 'azure-tenant-id', variable: 'azure_tenant_id_value')]) {

                sh(script:'''az login --service-principal -u ${azure_client_id} -p ${azure_client_secret_value} --tenant ${azure_tenant_id_value}
                      docker-compose build
                      az acr login --name creuvoted01
                      docker push creuvoted01.azurecr.io/azure-vote-front:latest
                ''', returnStdout:true)

                }
        }

        stage('Deliver new version of app') {

                sh(script:'''
                      az aks get-credentials --resource-group RGEUVOTED01 --name aksEUVOTEd01
                      kubectl replace -f azure-vote-all-in-one-redis.yaml --force
                ''', returnStdout:true)
        }
    }
}