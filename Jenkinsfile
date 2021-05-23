env.AWS_DEFAULT_REGION = 'ap-southeast-1'
node {
  git 'https://github.com/ahmed4u/kube_cluster.git'
  withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'shifa4u_credentials',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]){
                    stage('Init') {
                        sh label: 'terraform init', script: "/tmp/terraform init -backend-config \"bucket=shifa4u-testbucket\""
                    }
                    stage('Plan') {
                        sh label: 'terraform plan', script: "/tmp/terraform plan -out=tfplan -input=false"
                        script {
                            timeout(time: 10, unit: 'MINUTES') {
                                input(id: "Deploy Gate", message: "Deploy environment?", ok: 'Deploy')
                            }
                        }
                    }
                    stage('Apply') {
                        sh label: 'terraform apply', script: "terraform apply -lock=false -input=false tfplan"
                    }
                }
}
