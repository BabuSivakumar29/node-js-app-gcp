export PROJECT_NAME=node-js-app

init:
	terraform init

validate:
	terraform validate
plan:
	terraform plan \
		-out='$(PROJECT_NAME)-plan-file'

plan-destroy:
	terraform plan \
		-destroy \
		-out='$(PROJECT_NAME)-destroy-plan-file'

apply:
	terraform apply $(PROJECT_NAME)-plan-file

destroy:
	terraform apply $(PROJECT_NAME)-destroy-plan-file

refresh:
	terraform apply -refresh-only
