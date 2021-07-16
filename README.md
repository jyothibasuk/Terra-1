# Terraform-Azure-Linux
Terraform scripts in Azure for Ubuntu linux

while setup.
1) each version had different/ changes in attributes, should be careful
2) should check on os_profile_windows_config
3) *imp: for calling already assigned value = don't keep inverted commas, newly assaining we need to keep in inverted commas".

while terraform init,
1) need to have version in code & each time version is updated try to run init to load plugins ans supporting file.
2) also remember to keep features {} in provide block to avoid error.

while terraform validate
1) try to keep all ip address as ["10.1.0.0/24"], to avoid error.

while destroying 
1) during destroy network interface is not deleted, as it is associated with a resources. we need to disassociate in order to delete it. i have deleted directly from azure website.
2) Network Watcher is also not deleting, manually deleted from portal.


Notes:
1) active directory > app registration >create new registration
2) subscription id from subscription
3) client_id after app registration
4) client_secret after app registration > certificates & secrets
5) tenant_id after app registration
6) provide permissions to app registration from subscriptions > access control (iam) > add > contributor (can do all, butt can't change access of other) > select registered app.


Commands:
terraform init (initial verification)
terraform validate (code check)
terraform plan (dry run - don't execute)
terraform apply (actual execution)
terraform destroy (actual removal)
