pipeline {
    agent {label "node-1"}

    stages{
        stage('deploy proxy infra') {
            steps {

                withAWS(credentials: 'terraform') {
                    withEnv(['key-name = "DevOps-KeyPair"']) {
                        sh "terraform init"
                        sh "terraform apply -var "key-pair=${key-name}" -auto-approve"
                    }
                }

            }
            post {
                success {
                    sh "terraform output alb-dns"
                }
            }

            // post {
            //     success {
            //         slackSend color: 'good', message: "${terraform output alb-dns} Build successfully", tokenCredentialId: 'slack'
            //     }
            //     failure {
            //         slackSend color: 'good', message: "Build failed", tokenCredentialId: 'slack'
            //     }
            // }

        }
    }
}