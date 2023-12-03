## jenkinfile
```groovy
pipeline {
    agent any
    stages {
        stage('analyze') {
            steps {
                sh 'echo "docker.io/sharmavijay86/dockerwebapp:latest `pwd`/Dockerfile" > anchore_images'
                anchore name: 'anchore_images'
            }
        }
        stage('teardown') {
            steps {
                sh'''
                    for i in `cat anchore_images | awk '{print $1}'`;do docker rmi $i; done
                '''
            }
        }
    }
}
```
