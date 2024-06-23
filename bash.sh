#!/bin/bash

project="monitoringproj"


#sed -i '/backend/ s/^/\/\//' versions.tf
#terraform init
#terraform apply -auto-approve --target=google_storage_bucket.tf-state
#sed -i 's,//,,g' versions.tf
#sed -i "/backend \"gcs\" {/a\ \ \ bucket = \"tf-state-$project\"\n }" versions.tf
terraform init -force-copy -migrate-state -lock=false
terraform apply -auto-approve
[ -e terraform.tfstate ] && rm terraform.tfstate && echo "terraform.tfstate removed" || echo "terraform.tfstate not found"
[ -e terraform.tfstate.backup ] && rm terraform.tfstate.backup && echo "terraform.tfstate.backup removed" || echo "terraform.tfstate.backup not found"
[ -d .terraform ] && rm -rf .terraform && echo ".terraform directory removed" || echo ".terraform directory not found"
#sed -i '/^ *bucket *=/d' versions.tf

echo "You are now ready to commit this code to your Github repo & you can delete me (bash.sh)"








