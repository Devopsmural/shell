pipeline {

 agent none

 stages
 {
  stage('Build') // Checkout Repo and build Docker Image for running code analysis
  {
  agent { label 'demo' }
   steps { 
      echo "Checkout Python Repo .."
      git branch: 'master', url: 'https://github.com/scmlearningcentre/test.git'
	  echo "Build Python Base Image for Coverage .."
	  dir ("./proj") {
	     sh "/usr/bin/docker build -t mycov:demo -f ./Dockerfile.pycov ."
	  }
   }
  }
  
  stage('Generate Coverage') //Run unit test framework
  {
   agent { label 'demo' }
   steps { 
        dir ("./proj") {
           sh "/usr/bin/docker run --name democ -itd -v `pwd`/src:/home/demo mycov:demo nosetests -sv sampleapp.py --with-xunit --xunit-file=nosetests.xml --with-xcoverage --xcoverage-file=coverage.xml"
		}
   }
  }
  
  stage('SonarQube Analysis') 
  {
    environment {
        scannerHome = tool 'demoscanner'
    }
    agent { label 'demo' }
    steps{
     withSonarQubeEnv('mysonarqube') {
      dir ("./proj") {
       sh 'echo ${scannerHome}'
       sh '${scannerHome}/bin/sonar-scanner'
	  }
     } 
    }
  }
  
  stage('Generate Deployment Image') // Create Application Docker Image
  {
    agent { label 'demo' }
    steps{
      script {
          docker.withRegistry( 'https://registry.hub.docker.com', 'dockerhub' ) {
             /* Build Docker Image locally */
             myImage = docker.build("adamtravis/pyimg")

             /* Push the container to the Registry */
             myImage.push()
          }
      }
    }
  }

  stage('Deploy App')
  {
    agent { label 'demo' }
    steps {
      sh "/usr/bin/docker-compose up"
    }
  }

 } //End of Stages
} //End of Pipeline
