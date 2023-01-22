## Notepad

![GitHub repo size](https://img.shields.io/github/repo-size/sharmavijay86/ocexample?style=flat-square) 

take note of multi workspace patch chectl -   
```
kubectl patch checluster/eclipse-che --patch "{\"spec\":{\"server\":{\"customCheProperties\": {\"CHE_LIMITS_USER_WORKSPACES_RUN_COUNT\": \"-1\"}}}}" --type=merge -n che
```
ocbuild from binary
```
 oc new-build --binary=true --name example12
    * A Docker build using binary input will be created
      * The resulting image will be pushed to image stream tag "example12:latest"
      * A binary build was created, use 'oc start-build --from-dir' to trigger a new build

--> Creating resources with label build=example12 ...
    imagestream.image.openshift.io "example12" created
    buildconfig.build.openshift.io "example12" created
--> Success

```
https://secrethub.io/docs/guides/aws-eks/


## problem if mysql bin logs are getting generated and making your disk full.

there is one go query to purge them all .
```SQL
reset master;

reset slave;
```

you can stop it with option to set in mys.cnf file under mysql .

skip-log-bin
