# AWS EKS & Secrets Manager (File & Env | Kubernetes | Secrets Store CSI Driver | K8s)

## 1. Create Secret in AWS Secrets Manager
- Select `Other type of secrets`
- Create key: `MY_API_TOKEN` and random value: `7623fd72g3d`
- Give it a name `prod/service/token`
- Open created secret to check ARN

Get the cluster oidc ready..

## 2. Create IAM OIDC Provider for EKS
- Copy `OpenID Connect provider URL`
- Create Identety Provider - select `OpenID Connect`
- Enter `sts.amazonaws.com` for Audience

## 3. Create IAM Policy to Read Secrets
- Create `APITokenReadAccess` IAM policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": "<secret-arn>"
        }
    ]
}
```
## 4. Create IAM Role for a Kubernetes Service Account
- Click `Web identity` and select Identity provider that we created
- Select `APITokenReadAccess` IAM Policy
- Give it a name `api-token-access`
- Update trust relationships on the role 
- Update `aud` -> `sub`
- Update `sts.amazonaws.com` -> `system:serviceaccount:production:nginx`

## 5. Associate an IAM Role with Kubernetes Service Account
- Create `nginx/namespace.yaml`
- Create `nginx/service-account.yaml`

**Note: Before Applying service account please edit the correct role ARN in annotation of service account. i.e. same ARN from above stpe 4. Same would be applicable for more namespaces service accounts.**   

Validate the NS and SA
- Get Kubernetes namespaces
```bash
kubectl get ns
```
- Describe service account
```bash
kubectl get sa -n production
```
***Bellow two steps needs to perform once.***
## 6. Install the Kubernetes Secrets Store CSI Driver

```bash
helm repo add secrets-store-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/secrets-store-csi-driver/master/charts
```
-  install helm chart
```bash
helm -n kube-system install csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver --set syncSecret.enabled=true
```

## 7. Install AWS Secrets & Configuration Provider (ASCP)

```bash
kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml
```
- Check logs
```bash
kubectl logs -n kube-system -f -l app=csi-secrets-store-provider-aws
```

## 8. Create Secret Provider Class
- Create `nginx/2-secret-provider-class.yaml`
```bash
kubectl apply -f nginx
```

## 9. Demo
- Create nginx `3-deployment.yaml`
- Open 2 tabs
```bash
kubectl logs -n kube-system -f -l app=secrets-store-csi-driver
```
Above logs can be checked for any troubleshootings
```bash
kubectl apply -f nginx
```
```bash
kubectl -n production exec -it nginx-<id> -- bash
```
- Print mounted file
```bash
cat /mnt/api-token/secret-token
```
- Print environment variables with a secret
```bash
echo $API_TOKEN
```
