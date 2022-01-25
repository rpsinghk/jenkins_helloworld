pipeline {
	agent any

	triggers {
		pollSCM 'H/10 * * * *'
	}
	
	environment {
        MESG = "REPLACE_WITH_REMOTE_ADDRESS"
    }

	options {
		disableConcurrentBuilds()
		buildDiscarder(logRotator(numToKeepStr: '14'))
	}

	stages {
		stage("Build") {
			agent {
				docker {
					image 'adoptopenjdk/openjdk8:latest'
					args '-v $HOME/.m2:/tmp/jenkins-home/.m2'
					reuseNode true
				}
			}
			options { timeout(time: 30, unit: 'MINUTES') }
			steps {
			    sh "chmod +x -R ${env.WORKSPACE}"
				sh './gradlew build -x test'
			}
		}
		

        stage ('Build & Push docker image') {
            steps {
                withDockerRegistry(credentialsId:"",url: 'tcp://192.168.0.106:2375') {
				    //def workspace = WORKSPACE
				    // ${workspace} will now contain an absolute path to job workspace on slave
				
				   // workspace = env.WORKSPACE
				    // ${workspace} will still contain an absolute path to job workspace on slave
				
				    // When using a GString at least later Jenkins versions could only handle the env.WORKSPACE variant:
				    echo "Current workspace is ${env.WORKSPACE}"
				
				    // the current Jenkins instances will support the short syntax, too:
				    echo "Current workspace is $WORKSPACE"
				    
				    def PWD = pwd();
				    
				    dir('jenkins_helloworld') {
				    	echo "PWD :  $PWD"
      					sh 'docker build -t rpsinghk/jenkins_helloworld .'
   					}
				    
                	
                    //sh 'docker push rpsinghk/jenkins_helloworld'
                }
            }
        }
		
		stage ('Deploy') {
    		steps {
        		echo("deploy")
    		}
		}
	}

	post {
		changed {
			script {
				echo("in post script")
			}
		}
	}
}
