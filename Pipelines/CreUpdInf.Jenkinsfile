pipeline{
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }
    stages{
        stage('Cloning Git') {
                 steps {
                     git url:'https://github.com/Romario11/redmine-demo-2.git', branch:'main'
                 }
            }
        stage('ls') {
                     steps {
              sh 'ls -la'
            }
        stage('terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('terraform plan'){
            steps{
                sh 'terraform plan'
            }
        }
        stage('terraform apply'){
            steps{
                sh 'terraform apply -auto-approve'
            }
        }
        stage('Input') {
            steps {
                input('Do you want to terraform destroy?')
            }
        }

        stage('If Proceed is clicked') {
            steps {
                sh 'terraform apply -destroy -auto-approve'
            }
        }
    }
}