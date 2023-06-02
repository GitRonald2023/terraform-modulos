#!/usr/bin/env groovy

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
    stage ('Clean'){
        cleanWs()
    }
    sh "ls"
}