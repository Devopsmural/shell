pipeline {

 agent none

 stages
 {
  stage('Build')
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
  
  stage('Generate Coverage')
  {
   agent { label 'demo' }
   steps { 
        dir ("./proj") {
           sh "/usr/bin/docker run --name democ -itd -v src:/home/demo mycov:demo src/sampleapp.py "
		}
   }
  }
  
  stage('Generate Deployment Image') 
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

  stage('Smoke Test')
  {
    agent { label 'demo' }
    steps {
      sh "echo test"
    }
  }

 } //End of Stages
} //End of Pipeline
