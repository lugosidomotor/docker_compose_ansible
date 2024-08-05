.PHONY: up ansible

up:
ifndef CONTI_DB_NAME
	$(error You must specify CONTI_DB_NAME in the environment)
endif
	docker-compose up -d --build --force-recreate --no-deps --order-dependencies alpha bravo charlie

ansible:
  ansible-playbook -i inventory.yml playbook.yml