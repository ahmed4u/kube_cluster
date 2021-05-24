env.AWS_DEFAULT_REGION = 'us-west-1'
node {
    environment {
        KUBE_MASTER_NODE = ''
    }
  git 'https://github.com/ahmed4u/kube_cluster.git'
  withCredentials([[
                $class: 'AmazonWebServicesCredentialsBinding',
                credentialsId: 'shifa4u_credentials',
                accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
            ]]){
				if(Terraform_Action == 'Deploy') {
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
                                                        def kube_master = sh(script: 'grep master kubebuildlog.txt -A2| grep public| awk \'{print $3}\'| sed \'s/"//g\'', returnStdout: true).trim()
                                                        KUBE_MASTER_NODE = kube_master
                                                        println KUBE_MASTER_NODE
                                                }
                    }
                    stage('Configuring K8s') {
                        script {
                            //sh "ssh -o StrictHostKeyChecking=no ubuntu@$KUBE_MASTER_NODE \"sudo kubeadm init --pod-network-cidr 10.244.0.0/16 > /tmp/kube.conf\""
                            //sh "ssh -o StrictHostKeyChecking=no ubuntu@$KUBE_MASTER_NODE \"mkdir -p /home/ubuntu/.kube;sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config;sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config\""
                            //sh "ssh -o StrictHostKeyChecking=no ubuntu@$KUBE_MASTER_NODE \"kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml --kubeconfig /home/ubuntu/.kube/config\""
                            //sh "ssh -o StrictHostKeyChecking=no ubuntu@$KUBE_MASTER_NODE \"kubectl taint nodes --all node-role.kubernetes.io/master-\""
                            sh "rsync ubuntu@$KUBE_MASTER_NODE:/home/ubuntu/.kube/config $JENKINS_HOME/kubeconfig_file > /dev/null"
                        }
                    }}
					if(Terraform_Action == 'Destroy') {
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
}
