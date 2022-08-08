Structure

root folder ->

workloads -->>
tf files that describe the service

modules -->>
tf files that declares the resources on the module. 

the motivation was to make the module highly customizable by using vars where possible

usage

deploy.sh

motivation: create the function the deploy module, the function can set TF vars defined in variables.tf
