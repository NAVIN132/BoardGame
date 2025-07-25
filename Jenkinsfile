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
                    // Dynamically install Trivy if not present
                    sh '''
                    if ! command -v trivy &> /dev/null
                    then
                        echo "Trivy not found, installing..."
                        wget -qO trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
                        tar zxvf trivy.tar.gz
                        sudo mv trivy /usr/local/bin/trivy
                        chmod +x /usr/local/bin/trivy
                        trivy --version
                    else
                        echo "Trivy is already installed."
                    fi
                    '''

                    // Run Trivy source scan
                    sh '''
                    echo "Running Trivy source scan on repository..."

                    # Ensure your workspace is clean to avoid scanning unnecessary files
                    trivy config --exit-code 0 --severity HIGH,CRITICAL .

                    # Run secret scan
                    trivy fs --exit-code 0 --scanners secret --severity HIGH,CRITICAL .

                    echo "Trivy source scanning completed."
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
