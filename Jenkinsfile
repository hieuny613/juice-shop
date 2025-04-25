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
        stage('Test') {
            steps {
                sh 'npm install'
            }
        }
        stage('SAST Scan'){
            parallel {
                stage('SEMGREP Scan') {
                    steps {
                        script {
                            sh 'semgrep scan --json --json-output=semgrep.json'
                        }
                    }
                }
                stage('SonarQube Scan') {
                    steps {
                        withSonarQubeEnv('SonarQube Server') {
                            sh '/opt/sonar-scanner/bin/sonar-scanner   -Dsonar.projectKey=juice-shop   -Dsonar.sources=.   -Dsonar.host.url=http://192.168.153.128:9000'
                        }
                    }
                }
                
            }
        }
        stage('Dependency Check Scan'){
            steps {
                sh '/opt/dependency-check/bin/dependency-check.sh --scan . --format XML --out dependency-check.xml'
            }
        }
        stage('Trivy check Dockerfile'){
            steps {
                sh 'trivy config . -f json -o trivy-dockerfile.json'
            }
        }
        stage('Trivy check image source'){
            steps {
                sh 'trivy image gcr.io/distroless/nodejs20-debian12 --severity HIGH,CRITICAL -f json -o trivy-image.json'
            }
        }
        stage('Build'){
            steps{
                sh 'docker build -t juice-shop:latest .'
            }
        }
        stage('Trivy Scan image build'){
            steps{
                sh 'trivy image juice-shop:latest  --severity HIGH,CRITICAL -f json -o trivy-image.json'
            }
        }
        stage('Deployment Test'){
            steps{
                echo 'Deployment Test'
            }
        }
        stage('Integration Test'){
            steps{
                echo 'Integration Tests'
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