pipeline{
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{


    stage('Cleanup workspace') {
                steps {
                    cleanWs()
            }
        stage('Cloning Git') {
            steps{
                     checkout changelog: false, poll: false, scm: [$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'azureDevOps', url: 'git@ssh.dev.azure.com:v3/rsavchu/test/Automation.Server']]]
                }
            }
        stage('Check files') {
            steps{sh 'ls -la'}
              }
        stage('Terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform plan'){
            steps{
                 sh 'terraform plan'
            }
        }
        stage('Terraform apply'){
            steps{
                sh 'terraform apply -auto-approve'
            }
        }


    }
}