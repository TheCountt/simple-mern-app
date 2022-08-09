pipeline {
  agent any
  
      environment {
        registry = "anpbucket/multistage-mern"
        DATE = new Date().format('yy.M.dd')
        TAG = "${env.BRANCH_NAME}.${DATE}.${BUILD_NUMBER}"
        registryCredential = 'docker-cred'
      }

  
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

//    // Scan Packaged code using sonarqube
//   stage('SonarQube Quality Gate') {
//       when { branch pattern: "^main*|^isaac*", comparator: "REGEXP"}
//         environment {
//           scannerHome = tool 'SonarQubeScanner'
//         }
//         steps {
//             withSonarQubeEnv(credentialsId: 'sonaqube-token', installationName: 'sonarqube') {
//                 sh '${scannerHome}/bin/sonar-scanner -Dproject.settings=sonar-project.properties'
//             }
//             timeout(time: 3, unit: 'MINUTES') {
//                 waitForQualityGate abortPipeline: true
//                }
//             }
//          }


    // Build Image from Dockerfile
  stage('Build image') {
        steps {
	          script {
                dockerImage = ''
	              dockerImage = docker.build registry + ":${TAG}"
                
          }
       }
     }



 stage('Analyze with grype') {
      steps {
        script {
          try {
            sh 'grype --fail-on critical --quiet ${registry}:${TAG} --scope AllLayers --exclude grype.yml'
          } catch (err) {
            // if scan fails, clean up (delete the image) and fail the build
            sh """
              echo "Vulnerabilities detected in ${registry}:${TAG}, cleaning up and failing build."
              docker rmi ${registry}:${TAG}
              exit 1
            """
          }
        } 
      } 
    }  


    stage("Start the app") {
        steps {
              sh 'docker-compose up -d'
        }
    }	



    stage("Test endpoint") {
            steps {
                script {
                    while (true) {
                        def response = httpRequest 'http://localhost:3000'
                        break
                    }
                }
            }
        }
    

    stage('Re-tag and Push Image to repository') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push('prod')
                    }
                }
            }
        } 



  }
}

