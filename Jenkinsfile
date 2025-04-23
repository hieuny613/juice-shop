pipeline {
    agent any

    stages {
        stage('Gitleaks Scan'){
            steps {
                script {
                    try {
                        sh 'gitleaks detect --source . --config .gitleaks.toml --report-path gitleaks-report.json'
                    } catch (e) {
                        echo "Gitleaks failed, but we are ignoring the error."
                    }
                }
                archiveArtifacts artifacts: 'gitleaks-report.json', allowEmptyArchive: true
            }
        }
    }
}