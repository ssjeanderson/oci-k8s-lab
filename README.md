# oci-k8s-lab

This project aims the automated creation of a minimal infrastructure on the Oracle Cloud to run an ARM based k8s cluster, only using Always-Free elegible resources.

## Preparation

Git clone this repo:
```bash
git clone https://github.com/ssjeanderson/oci-k8s-lab.git
```

### Creating keys 

```bash
openssl genrsa -out oci-key.pem 2048
openssl rsa -in oci-key.pem -outform PEM -pubout -out oci-pub.pem
ssh-keygen -f oci-key.pem -y > oci-ssh-pub.pem
```
Ends up with three files:
- oci-key.pem: Private RSA key
- oci-pub.pem: Public RSA key
- oci-ssh-pub.pem: SSH Public key
> The same private key is used for OCI API Access and SSH VM Access

Upload the public RSA key to the OCI Console (User > My Profile > API Keys). Make note of the resource IDs outputed as we'll need them to fill out the environment file (.env.example).

### Fill out enviroment file

```bash
cp .env.example .env
```
Complete the terraform vars section with the data outputed in the keys upload step. It's also needed to inform the ID of the parent resource compartment.

## Running terraform

As a container maniac, I prefer running terraform by using docker:

```bash
alias terraform="docker run --rm -it -v $PWD:/oci-k8s-lab -w /oci-k8s-lab --env-file $PWD/.env hashicorp/terraform -chdir=terraform"

terraform init
terraform apply
```

At this point (and wether everything went well), there will be an ```inventory``` file in the current dir. This same file will be used by ansible for setting up de cluster.

## Running ansible

```bash
alias ansible-playbook="docker run --rm -it -v $PWD:/oci-k8s-lab -w /oci-k8s-lab --env-file $PWD/.env willhallonline/ansible ansible-playbook"

ansible-playbook ansible/playbook_setup-k8s.yml
```

Then we got a kube ```config``` file in the current dir. Move it to default location and kubectl will be ready to go.

```bash
mkdir -p ~/.kube/
mv config ~/.kube/
kubectl cluster-info
```

## Destroy

Just run the destroy command to delete all resources created by terraform.

```bash
terraform destroy
```



