env.AWS_DEFAULT_REGION = 'us-west-1'
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
                        sh label: 'terraform apply', script: "/tmp/terraform apply -lock=false -input=false tfplan"
                    }
					stage('Destroy') {
                        sh label: 'terraform destroy', script: "/tmp/terraform destroy -out=tfplan -input=false"
                        script {
                            timeout(time: 10, unit: 'MINUTES') {
                                input(id: "Deploy Gate", message: "Destroy environment?", ok: 'Destroy')
                            }
                        }
                    }
                }
}
