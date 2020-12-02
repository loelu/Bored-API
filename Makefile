clair-up:
	@cd clair && docker-compose up -d

clair-stop:
	@cd clair && docker-compose down

clair-run-test:
	@cd clair && CLAIR_ADDR=localhost DOCKER_USER=$DOCKER_CREDS_USR DOCKER_PASSWORD=$DOCKER_CREDS_PSW ./klar viclo/boredapi:test
