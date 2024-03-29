pipeline {
  agent {
    label "jenkins-REPLACE_ME_BUILDER"
  }
  environment {
    ORG = 'anghami'
    APP_NAME = 'REPLACE_ME_APP_NAME'
    CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    DOCKER_REGISTRY_ORG = 'jx'
    SOURCE_URL = 'https://github.com/anghami/REPLACE_ME_APP_NAME'
  }
  stages {
    stage('Docker Build') {
      when {
        anyOf {
          branch 'master';
          branch 'PR-*'
        }
      }
      steps {
        container('REPLACE_ME_BUILDER') {
          sh "bash docker_build.sh"
        }
      }
    }
    stage('Run Tests') {
      when {
        anyOf {
          branch 'master';
          branch 'PR-*'
        }
      }
      steps {
        container('REPLACE_ME_BUILDER') {
        }
      }
    }
    stage('CI Build and push snapshot') {
      when {
        branch 'PR-*'
      }
      environment {
        PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
        PREVIEW_NAMESPACE = "jx-$APP_NAME-$BRANCH_NAME".toLowerCase()
        HELM_RELEASE = "$APP_NAME-$BRANCH_NAME".toLowerCase()
      }
      steps {
        container('REPLACE_ME_BUILDER') {
          sh "export VERSION=$PREVIEW_VERSION"
          sh "docker tag $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:stage_serve $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:$PREVIEW_VERSION"
          sh "docker push $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:$PREVIEW_VERSION"
          sh "jx step post build --image $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:$PREVIEW_VERSION"
          dir('./charts/preview') {
            sh 'helm init --client-only --stable-repo-url https://charts.helm.sh/stable'
            sh "make preview"
            sh "jx preview --release $HELM_RELEASE --namespace $PREVIEW_NAMESPACE --app $APP_NAME --dir ../.."
          }
        }
      }
    }
    stage('Build Release') {
      when {
        branch 'master'
      }
      steps {
        container('REPLACE_ME_BUILDER') {

          // ensure we're not on a detached head
          sh "git checkout master"
          sh "git config --global credential.helper store"
          sh "jx step git credentials"

          // so we can retrieve the version in later steps
          sh "echo \$(jx-release-version) > VERSION"
          sh "jx step tag --version \$(cat VERSION)"
          sh "docker tag $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:stage_serve $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:\$(cat VERSION)"
          sh "docker push $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:\$(cat VERSION)"
          sh "jx step post build --image $DOCKER_REGISTRY/$DOCKER_REGISTRY_ORG/$APP_NAME:\$(cat VERSION)"
        }
      }
    }
    stage('Promote to Environments') {
      when {
        branch 'master'
      }
      steps {
        container('REPLACE_ME_BUILDER') {
          dir('./charts/REPLACE_ME_APP_NAME') {
            sh "jx step changelog --version v\$(cat ../../VERSION)"

            // release the helm chart
            sh 'helm init --client-only --stable-repo-url https://charts.helm.sh/stable'
            sh "jx step helm release"

            // promote through all 'Auto' promotion Environments
            sh "jx promote -b --all-auto --timeout 1h --version \$(cat ../../VERSION)"
          }
        }
      }
    }
  }
  post {
        always {
          cleanWs()
        }
  }
}
