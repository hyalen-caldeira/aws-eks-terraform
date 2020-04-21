# ---------------------------------------------------------------------------------------------------------------------
# OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "eks_cluster_name" {
    value = module.eks_cluster.eks_cluster_name
    description = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# KUBECONFIG & KUBERNETES AUTH CONFIGURATION
# Use:
#   terraform output kubeconfig > ~/.kube/config
#   terraform output config_map_aws_auth > configmap.yml
#   kubectl apply -f configmap.yml
/*
kubectl create namespace test-environment
kubectl create deploy nginx --image=nginx -n test-environment
kubectl get all -n test-environment
*/
# ---------------------------------------------------------------------------------------------------------------------

locals {
    config_map_aws_auth = <<CONFIGMAPAWSAUTH
        apiVersion: v1
        kind: ConfigMap
        metadata:
            name: aws-auth
            namespace: kube-system
        data:
            mapRoles: 
                - rolearn: ${module.iam_roles.eks_node_group_service_role_arn}
                username: system:node:{{EC2PrivateDNSName}}
                groups:
                    - system:bootstrappers
                    - system:nodes
    CONFIGMAPAWSAUTH

    kubeconfig = <<KUBECONFIG
        apiVersion: v1
        clusters:
        - cluster:
            server: ${module.eks_cluster.eks_cluster_endpoint}
            certificate-authority-data: ${module.eks_cluster.certificate_authority}
          name: kubernetes
        contexts:
        - context:
            cluster: kubernetes
            user: aws
          name: aws
        current-context: aws
        kind: Config
        preferences: {}
        users:
        - name: aws
          user:
            exec:
              apiVersion: client.authentication.k8s.io/v1alpha1
              command: aws-iam-authenticator
              args:
              - "token"
              - "-i"
              - "${module.eks_cluster.eks_cluster_name}"
    KUBECONFIG
}

output "config_map_aws_auth" {
    value = local.config_map_aws_auth
}

output "kubeconfig" {
    value = local.kubeconfig
}