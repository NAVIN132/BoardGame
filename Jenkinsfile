pipeline {
  agent any
  stages {
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
    stage('Security Scan') {
      //  agent {
      //   docker {
      //       sh 'docker run --rm aquasec/trivy:latest image trivy'
      //       args '-v /var/run/docker.sock:/var/run/docker.sock'
      //   }
      // }
      steps {
        sh 'chmod +x ./security/trivy-scan.sh'
        sh './security/trivy-scan.sh'
        sh 'chmod +x ./security/dependency-check.sh'
        sh './security/dependency-check.sh'
      }
    }
    // stage('Deploy') {
    //   steps {
    //     sshagent(['ec2-ssh']) {
    //       sh 'scp target/boardgame-app.jar ec2-user@${INSTANCE_IP}:/home/ec2-user/app.jar'
    //       sh 'ssh ec2-user@${INSTANCE_IP} "nohup java -jar app.jar &"'
    //     }
    //   }
    // }
  }
}
