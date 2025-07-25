pipeline {
    agent any

    environment {
        TRIVY_VERSION = "0.51.1"
        DEP_CHECK_VERSION = "9.2.0"
       // INSTANCE_IP = credentials('ec2-instance-ip') // replace with your Jenkins credential ID for EC2 IP or define manually
    }

    stages {

        stage('Checkout Source') {
            steps {
                echo "✅ Checking out source code..."
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "✅ Running Maven clean package..."
                sh 'mvn clean package'
            }
        }

        stage('Test') {
            steps {
                echo "✅ Running Maven tests..."
                sh 'mvn test'
            }
        }

        stage('Trivy Source Scan') {
            steps {
                script {
                    echo "✅ Starting Trivy source scan..."
                    sh """
                    if [ ! -f "./trivy" ]; then
                        echo "Trivy not found, downloading v${TRIVY_VERSION}..."
                        wget -qO trivy.tar.gz https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz
                        tar zxvf trivy.tar.gz
                        chmod +x trivy
                        ./trivy --version
                    else
                        echo "Trivy is already downloaded."
                        ./trivy --version
                    fi

                    echo "Running Trivy scan on source with HIGH,CRITICAL severity for vuln,secret,config..."
                    ./trivy fs --exit-code 0 --scanners vuln,secret,config --severity HIGH,CRITICAL .
                    echo "✅ Trivy source scan completed successfully."
                    """
                }
            }
        }

        stage('Dependency Check') {
            steps {
                script {
                    echo "✅ Starting OWASP Dependency-Check..."
                    sh """
                    mkdir -p tools

                    if [ ! -d "tools/dependency-check" ]; then
                        echo "Downloading Dependency-Check v${DEP_CHECK_VERSION}..."
                        wget https://github.com/jeremylong/DependencyCheck/releases/download/v${DEP_CHECK_VERSION}/dependency-check-${DEP_CHECK_VERSION}-release.zip -O tools/dependency-check.zip
                        unzip -q tools/dependency-check.zip -d tools/
                        mv tools/dependency-check-${DEP_CHECK_VERSION} tools/dependency-check
                    else
                        echo "Dependency-Check is already downloaded."
                    fi

                    echo "Running Dependency-Check scan for BoardGame-App..."
                    tools/dependency-check/bin/dependency-check.sh --project "BoardGame-App" --scan . --format "HTML" --out "dependency-check-report"
                    echo "✅ Dependency-Check scan completed successfully."
                    """
                }
            }
        }

        // stage('Deploy') {
        //     steps {
        //         echo "✅ Starting deployment to EC2..."
        //         sshagent(['ec2-ssh']) { // Replace 'ec2-ssh' with your SSH credential ID in Jenkins
        //             sh 'scp target/boardgame-app.jar ec2-user@${INSTANCE_IP}:/home/ec2-user/app.jar'
        //             sh 'ssh ec2-user@${INSTANCE_IP} "nohup java -jar app.jar &"'
        //         }
        //         echo "✅ Deployment completed."
        //     }
        // }

    }

    post {
        always {
            echo "✅ Archiving Dependency-Check report..."
            archiveArtifacts artifacts: 'dependency-check-report/dependency-check-report.html', fingerprint: true
            echo "✅ Pipeline execution completed."
        }
    }
}
