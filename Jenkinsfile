pipeline {
    agent any

    stages {
        stage('SAST Scan'){
            parallel {
                stage('Gitleaks Scan Secret'){
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
                    steps {
                        script {
                            sh 'ls -al'
                            sh 'njsscan . --json -o njsscan.json '
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
        }
    }
}