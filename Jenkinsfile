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
        stage('Environment Preparation') {
            steps {
                echo 'Preparing environment for app and docker build'
                script {
                    //env.SERVICE = "${params.ecs_service}"
                    env.COMPONENT = "gps"
                    //env.ECR_TAG = "${params.ecr_tag}"
                    //env.ENVIRONMENT = "${params.environment}"
                    env.IMAGE = "${env.COMPONENT}/${env.SERVICE}"
                    //env.ECS_SERVICE_NAME = "${params.ecs_service}"
                    //env.ECS_TASK_DEFINITION_NAME = "${params.ecs_service}"
                    //env.NETWORK_MODE = "awsvpc"
                    //env.TASK_ROLE = "gsam-container-role"
                   	 env.CURRENT_SCM= scm.getUserRemoteConfigs()[0].getUrl()
                   	 env.REGISTRY_URL="tcp://192.168.0.106:2375"
                }
            }
        }
		stage("Build") {
			agent {
				docker {
					image 'adoptopenjdk/openjdk8:latest'
					args '-v ${JENKINS_HOME}/.m2:/tmp/jenkins-home/.m2'
					reuseNode true
				}
			}
			options { timeout(time: 30, unit: 'MINUTES') }
			steps {
			    sh "chmod +x -R ${env.WORKSPACE}"
				sh './gradlew build -x test'
			}
		}
		
		stage("Scan gitleaks") {
			steps {
				buildAndRegisterDockerImage()
					withDockerRegistry(credentialsId:"",url: "${env.REGISTRY_URL}") {
						script{
							sh "echo $docker"
						}
						withDockerContainer(image:"zricethezav/gitleaks",args:"-d=true -p 8888:8080"){
							sh "gitleaks  --repo-url=${env.CURRENT_SCM} --verbose --report=analytics-${env.JOB_NAME}-repo.json"
						}
	      			}
      		}
		}
		

        stage ('Build & Push docker image') {
            steps {
                withDockerRegistry(credentialsId:"",url: "${env.REGISTRY_URL}") {
				    echo "Current workspace is ${env.WORKSPACE}"
				    echo "Current workspace is $WORKSPACE"
      				sh 'docker build --rm --progress plain --no-cache -t rpsinghk/jenkins_helloworld .'
                }
            }
        }
		
		stage ('Deploy') {
    		steps {
    			
        		sh 'echo "deploy"'
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


def buildAndRegisterDockerImage() {
    def buildResult
    docker.withRegistry(env.REGISTRY_URL) {
        echo "Connect to registry at ${env.REGISTRY_URL}"
        dockerRegistryLogin()
        echo "Build ${env.IMAGE_NAME}"
        buildResult = docker.build(env.IMAGE_NAME)
        echo "Register ${env.IMAGE_NAME} at ${env.REGISTRY_URL}"
        buildResult.push()
        echo "Disconnect from registry at ${env.REGISTRY_URL}"
        sh "docker logout ${env.REGISTRY_URL}"
    }
}