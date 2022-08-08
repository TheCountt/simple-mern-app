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
                DATE = new Date().format('yy.M.dd')
                TAG = "${DATE}.${BUILD_NUMBER}"
                // here we create `env.TAG` variable that can be access in the later stages
                env.TAG = "${DATE}.${BUILD_NUMBER}"
                registry = "anpbucket/multistage-mern"
                registryCredential = 'docker-cred'
                dockerImage = ''
	              dockerImage = docker.build registry + ":${env.BRANCH_NAME}${TAG}"
                
          }
       }
     }


    // stage('Run Vulnerability Scan') {
    //   steps {
    //     sh 'grype anpbucket/multistage-mern:${env.BRANCH_NAME}${TAG} --only-notfixed --scope AllLayers' 
    //   }
    // }

       // Build Image from Dockerfile
  // stage('Read variables from properties file') {
  //       steps {
  //         script {
  //               def props = ( file: 'config.properties' ) //readProperties is a step in Pipeline Utility Steps plugin
  //               env.DB_PORT = props.DB_PORT //assuming the key name is DB_PORT in properties file
  //               env.SERVER_PORT = props.SERVER_PORT
  //               env.CLIENT_PORT = props.CLIENT_PORT
  //           }
  //       }
  //   }

    stage("Start the app") {
        steps {
              sh 'docker-compose up -d'
        }
    }	



    stage("Test endpoint") {
            steps {
                script {
                    while (true) {
                        def response = httpRequest 'localhost:3000'

                        if (code == 200) {
                            echo response
                        break
                        }
                    }
                }
            }
        }
    

    stage('Push Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }
            }
        }

    
     // Scan Pushed Image for security purposes
  //  stage('Anchore analyse') {
  //    steps {
  //     script {
  //        def path = sh returnStdout: true, script: "pwd"
  //            path = path.trim()
  //            dockerfile = path + "/Dockerfile"
  //        def imageLine = 'docker.io/anpbucket/multistage' + ":${env.BRANCH_NAME}-${env.TAG}"
  //            writeFile file: 'anchore_images', text: imageLine + " " + dockerfile
  //            anchore name: 'anchore_images', engineCredentialsId: 'anchore-credentials', annotations: [[key: 'admin', value: 'spring-petclinic']]
  //       }
  //    }
  //  }    


  }
}