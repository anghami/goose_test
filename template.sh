#!/bin/bash

# This accepts two arguments, first one is the app name, second one
# is the builder type (one of python, go, nodejs)

APP_NAME=$1
BUILDER=$2

[ -z "$APP_NAME" ] && echo "Missing APP_NAME!" && exit
[ -z "$BUILDER" ] && echo "Missing BUILDER!" && exit


echo APP_NAME=$APP_NAME
echo BUILDER=$BUILDER

mv charts/RENAME_ME_APP_NAME/ charts/$APP_NAME/
grep -rl REPLACE_ME_APP_NAME charts/ | xargs -I{} sed -i "" -e "s/REPLACE_ME_APP_NAME/$APP_NAME/g" {}
grep -rl REPLACE_ME_APP_NAME Jenkinsfile | xargs -I{} sed -i "" -e "s/REPLACE_ME_APP_NAME/$APP_NAME/g" {}
grep -rl REPLACE_ME_BUILDER Jenkinsfile | xargs -I{} sed -i "" -e "s/REPLACE_ME_BUILDER/$BUILDER/g" {}

git add charts/ Jenkinsfile
git commit -m "Replace app name and builder in charts and Jenkinsfile"
