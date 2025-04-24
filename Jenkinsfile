pipeline {
    agent any

    stages {
        stage('SAST Scan'){
            parallel {
                stage('Gitleaks Scan'){
                    steps {
                        script {
                            try {
                                sh 'gitleaks detect --source . --config .gitleaks.toml --report-path gitleaks.json'
                            } catch (e) {
                                echo "Gitleaks failed, but we are ignoring the error." 
                            }
                        }
                    }
                }
                stage('NJSSCAN Scan') {
                    steps {
                        script {
                            sh 'njsscan . --json -o njsscan.json'
                        }
                    }
                }
                stage('SEMGREP Scan') {
                    steps {
                        script {
                            sh 'semgrep scan --json --json-output=semgrep.json'
                        }
                    }
                }
                stage('SonarQube Scan') {
                    steps {
                        script {
                            sh '/opt/sonar-scanner/bin/sonar-scanner   -Dsonar.projectKey=juice-shop   -Dsonar.sources=.   -Dsonar.host.url=http://192.168.153.128:9000   -Dsonar.token=sqp_65bee64ad42e6d9be9192f35bcb4c1a5ca514732'
                        }
                    }
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'gitleaks.json', allowEmptyArchive: true
            archiveArtifacts artifacts: 'njsscan.json', allowEmptyArchive: true
            archiveArtifacts artifacts: 'semgrep.json', allowEmptyArchive: true
        }
    }
}