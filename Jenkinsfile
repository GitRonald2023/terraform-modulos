#!/usr/bin/env groovy
properties([parameters([booleanParam(defaultValue: false, name: 'destroy')]), pipelineTriggers([GenericTrigger(causeString: 'Generic Cause', regexpFilterExpression: '', regexpFilterText: '', token: 'terraform-pipeline', tokenCredentialId: '')])])
node ("Jenkins-Pipeline"){
    echo "Hello, World"
    stage ('Checkout'){
        checkout changelog: false, poll: false, scm: scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'Git-credentials', url: 'https://github.com/GitRonald2023/terraform-modulos.git']])
    }
    stage ('Init'){
        sh 'terraform init'
    }
    stage ('Validate'){
        sh '''terraform fmt
            terraform validate'''
    }
    withCredentials([[
            $class: 'AmazonWebServicesCredentialsBinding',
            credentialsId: "aws-credentials",
            accessKeyVariable: 'AWS_ACCESS_KEY_ID',
            secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
        ]]) 
        {
            stage ('Plan'){        
                sh 'terraform plan -out tfplan'     
            }
            if (params.destroy){
                stage ('Destroy'){
                    sh "terraform destroy"
                }
            }
            else {
                stage ('Apply') {
                    sh "terraform apply 'tfplan'"
                }    
            }
        }
    stage ('Clean'){
        cleanWs()
    }
}