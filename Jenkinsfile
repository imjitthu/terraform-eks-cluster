pipeline {
    agent any

// tools {
//     terraform 'terraformtool'
// }

    stages ('AWS EKS Cluster') {
        stage ('Creating AWS EKS Cluster') {
            steps {
                
                sh """
                terraform init
                terraform apply -auto-approve
                eksctl get nodes
                eksctl get pods
                eksctl get svc
                """
            }
        }
    }
}