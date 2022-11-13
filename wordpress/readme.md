# Setup wordpress with helm chart

  - this folder have a wordpress values.yaml, which you can modify based on your need. No need to give any DB password as this generates one during initialization.
  - this helm chart command will setup mariadb Statefullset also, so no need to setup seperatly.
  - if your wordpress pod is crashing and restarting initially, dont worry about it, it may restart atleast 6+ times to get stable so just wait.
  - To run the helm command use bellow 

### Repo add by bitnami

```BASH
helm repo add bitnami https://charts.bitnami.com/bitnami
```

### Check the versions available

```BASH
helm search repo wordpress --versions
```

### Choose desired version to setup and run this

```BASH
kubectl create namespace nswordpress

helm install wordpress wordpress --values=wordpress-values.yaml --namespace nswordpress --version 15.2.14 --repo=https://charts.bitnami.com/bitnami
```

### If you wish to see the readme of any particuler version do this

```BASH
helm show readme bitnami/wordpress --version 15.2.14
```

### If you wish to see the values.yaml of any particuler version do this

```BASH
helm show values bitnami/wordpress --version 15.2.14
```

### required sql query

- Check the current urls

```SQL
SELECT options_value FROM wp_options WHERE option_name = 'home' OR option_name = 'siteurl';
```
- Update urls 


```SQL
UPDATE wp_options SET option_value = replace(option_value, 'oldurl.com', 'newurl.com') WHERE option_name = 'home' OR option_name = 'siteurl';
UPDATE wp_posts SET guid = replace(guid, 'oldurl.com','newurl.com');
UPDATE wp_posts SET post_content = replace(post_content, 'oldurl.com', 'newurl.com'); 
UPDATE wp_postmeta SET meta_value = replace(meta_value,'oldurl.com','newurl.com');
```
