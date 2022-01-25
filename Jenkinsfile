pipeline {
	agent none

	triggers {
		pollSCM 'H/10 * * * *'
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
				sh 'test/run.sh'
			}
		}

		stage("test: baseline (publish)") {
			
				docker {
					    def customImage = docker.build("my-image:${env.BUILD_ID}")
    					customImage.push("latest")
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
