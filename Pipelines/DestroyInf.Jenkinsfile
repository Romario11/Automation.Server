pipeline{
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{
        stage('Cloning Git') {
            steps{
                     checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'azureDevOps', url: 'git@ssh.dev.azure.com:v3/rsavchu/test/Automation.Server']]]
                }
            }
        stage('ls') {
            steps{sh 'ls -la'}
              }
        stage('terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform plan'){
            steps{
                sh 'terraform state pull'
            }
        }
        stage('terraform apply'){
            steps{
                sh 'terraform destroy -auto-approve'
            }
        }


    }
}