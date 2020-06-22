CI CD demo

# Create Projects
oc new-project dev --display-name="Tasks - Dev"
oc new-project stage --display-name="Tasks - Stage"
oc new-project cicd --display-name="CI/CD"

# Grant Jenkins Access to Projects
oc policy add-role-to-group edit system:serviceaccounts:cicd -n dev
oc policy add-role-to-group edit system:serviceaccounts:cicd -n stage

# Deploy Demo
oc new-app -n cicd -f cicd-template.yaml


or with che


# Deploy Demo woth Eclipse Che
oc new-app -n cicd -f cicd-template.yaml --param=DEPLOY_CHE=true

# for custom project to use-
oc new-app -n cicd -f cicd-template.yaml --param DEV_PROJECT=dev-project-name --param STAGE_PROJECT=stage-project-name




Take note of these credentials and then follow the demo guide below:

    Gogs: gogs/gogs
    Nexus: admin/admin123
    SonarQube: admin/admin



Runtime Note fix--

repo migrate to gogs 
https://github.com/OpenShiftDemos/openshift-tasks
as gogs/openshift-tasks
Run bellow task if image not pulled.
cd /etc/rhsm/ca/
touch redhat-uep.pem
