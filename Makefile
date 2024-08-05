.PHONY: up ansible

up:
	@if [ -z "$$CONTI_DB_NAME" ]; then \
		echo "You must specify CONTI_DB_NAME in the environment."; \
		exit 1; \
	fi
	docker-compose up -d --build

ansible:
	ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
