pipeline {
    agent any
    environment {
        SECRET_KEY = credentials('slack-token')
    }
    stages {
        stage('Initialize') {
            steps {
                script {
                    sh 'terraform init'
                }
            }
        }

        stage('Create Terraform Plan') {
            steps {
                script {
                    sh 'terraform plan -out tfplan'
                }
            }
        }

        stage('Convert Plan to JSON') {
            steps {
                script {
                    sh 'terraform show -json tfplan > tfplan.json'
                }
            }
        }

        stage('Check Compliance') {
            steps {
                script {
                    sh 'checkov -f tfplan.json --external-checks-dir custom_policies/ --check CKV2_AWS_1001,CKV2_AWS_1002,CKV2_AWS_1003,CKV2_AWS_1004,CKV2_AWS_1005 > checkov_output.txt || true'
                    sh 'cat checkov_output.txt'
                    def failedChecks = sh(script: 'grep -o "Failed checks: [1-9]*" checkov_output.txt | grep -o "[1-9]*" || true', returnStdout: true).trim()

                    if (failedChecks) {
                    slackSend(channel: "checkov", message: "There are $failedChecks failed policies in your code, please review and update", sendAsText: true)
                    } else {
                        echo "All checks passed. Proceeding to apply changes."
                        sh 'terraform apply tfplan'
                    }
                }
            }
        }
    }
}

