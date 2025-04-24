pipeline {
    agent any

    stages {
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
        stage('njsscan SAST') {
            agent {
                docker {
                    image 'opensecurity/njsscan'
                    args '--entrypoint=""'
                    reuseNode true
                }
            }
            steps {
                script {
                    sh 'njsscan . --json -o njsscan.json '
                }
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'gitleaks.json', allowEmptyArchive: true
            archiveArtifacts artifacts: 'njsscan.json', allowEmptyArchive: true
        }
    }
}