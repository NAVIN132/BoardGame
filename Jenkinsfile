pipeline {
    agent any

    environment {
        TRIVY_VERSION = "0.51.1"
    }

    stages {
        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

     stage('Trivy Source Scan') {
    steps {
        script {
            sh '''
            # Check if Trivy is already present locally
            if [ ! -f "./trivy" ]; then
                echo "Trivy not found, downloading locally..."
                wget -qO trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
                tar zxvf trivy.tar.gz
                chmod +x trivy
                ./trivy --version
            else
                echo "Trivy is already downloaded."
                ./trivy --version
            fi

            echo "Running Trivy scan on source..."

            # Scan source for vulnerabilities and secrets
            ./trivy fs --exit-code 0 --scanners vuln,secret,config --severity HIGH,CRITICAL .

            echo "Trivy source scan completed successfully."
            '''
        }
    }
}


        stage('Dependency Check') {
            steps {
                sh 'chmod +x ./security/dependency-check.sh'
                sh './security/dependency-check.sh'
            }
        }

        // stage('Deploy') {
        //     steps {
        //         sshagent(['ec2-ssh']) {
        //             sh 'scp target/boardgame-app.jar ec2-user@${INSTANCE_IP}:/home/ec2-user/app.jar'
        //             sh 'ssh ec2-user@${INSTANCE_IP} "nohup java -jar app.jar &"'
        //         }
        //     }
        // }
    }
}
