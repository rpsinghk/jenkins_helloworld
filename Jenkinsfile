pipeline {
	agent none

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
		stage("test: baseline (jdk8)") {
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
				sh './gradlew clean build -x test'
			}
		}
		

        stage ('Build & Push docker image') {
            steps {
                withDockerRegistry(credentialsId:"",url: 'tcp://192.168.0.106:2375') {
                    sh 'docker push rpsinghk/jenkins_helloworld'
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
