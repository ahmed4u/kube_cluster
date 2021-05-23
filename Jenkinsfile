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
						script {
							def logContent = Jenkins.getInstance().getItemByFullName(env.JOB_NAME).getBuildByNumber(Integer.parseInt(env.BUILD_NUMBER)).logFile.text
							writeFile file: "kubebuildlog.txt", text: logContent
						}
                    }
                    stage('Destroy') {
                        script {
                            timeout(time: 10, unit: 'MINUTES') {
                                input(id: "Destroy Gate", message: "Destroy environment?", ok: 'Destroy')
                            }
                        }
                        sh label: 'Destroy environment', script: "/tmp/terraform destroy -lock=false -auto-approve"
                    }
                }
}

