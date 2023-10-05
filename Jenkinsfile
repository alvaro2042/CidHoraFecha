pipeline {

    agent any {
    
        stages {
        
            stage('Clonar repositorio') {
                steps {
                    scrtipt {
                        git credentialsId: 'GithubSecret', url: 'https://github.com/alvaro2042/CidHoraFecha', branch: 'develop'
                    }
                }
            }
            
            stage('Pruebas Unitarias') {
                steps {
                    sh 'python3 -m unittest discover test'
                    sh 'pwd'
                }
                post {
                    always{
                        sh 'pwd'
                        junit '**/test-*.xml'
                        sh 'pwd'
                    }
                }
            }
            
            stage('Analizar Calidad de Codigo') {
                steps {
                    scrtipt {
                        def scannerHome = tool 'SonarCloud'
                        withSonarQuveEnv('SonarCloud') {
                            hs """
                            ${scannerHome}/bin/sonr-scaner \
                            -Dsonar.projectKey=alvaro2042_CidHoraFecha \
                            -Dsonar.organization=alvaro2042 \
                            -Dsonar.sources=. \
                            -Dsonar.login=bf36a1da232c8d349ad360db3426e731f6c84f20
                            """
                        }
                    }
                }
            }
            
            stage('Construir Imagen') {
                steps {
                    //Eliminar contenedor existente
                    sh 'docker stop app-credibanco || true'
                    sh 'docker rm -f app-credibanco || true'
                    
                    //Eliminar Imagen existente
                    sh 'docker rmi -f alvaro2042/jenkins-credibanco:latest'
                    
                    //Construccion de imagen
                    sh 'Docker buld -t alvaro2042/jenkins-credibanco:latest'
                    
                    //DockerHub login
                    sh 'echo dckr_pat_sIvPJ_rFBpwicBNIi8JTrEaF5ZQ' | docker login --username alvaro2042 --password-stdin
                    
                    //Push a DockerHub
                    sh 'docker push alvaro2042/jenkins-credibanco:latest'
                }
            }
            
            stage('Subir Servicio') {
                steps {
                    sh 'docker rub -d --name app-credibanco -p 5000:5000 alvaro2042/jenkins-credibanco:latest'
                }
            }
        
        }
    
    }

}

