pipeline {
  agent any
  
  options {
  timestamps ()
  buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '4')
  }

  stages {

   stage('Initial cleanup') {
        steps {
          dir("${WORKSPACE}") {
            deleteDir()
          }
        }
      }

  stage('Checkout SCM') {
    steps {
          git branch: 'main', credentialsId: 'local-exec', url: 'https://github.com/TheCountt/simple-mern-app.git'
      }
    }

   // Scan Packaged code using sonarqube
  stage('SonarQube Quality Gate') {
      when { branch pattern: "^main*|^isaac*", comparator: "REGEXP"}
        environment {
          scannerHome = tool 'SonarQubeScanner'
        }
        steps {
            withSonarQubeEnv(credentialsId: 'sonaqube-token', installationName: 'sonarqube') {
                sh '${scannerHome}/bin/sonar-scanner -Dproject.settings=sonar-project.properties'
            }
            timeout(time: 4, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
               }
            }
         }


  }
}