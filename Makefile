clair-up:
	@cd clair && docker-compose up -d

clair-stop:
	@cd clair && docker-compose down

clair-run:
	@cd clair && CLAIR_ADDR=localhost DOCKER_USER=viclo DOCKER_PASSWORD=172af31c-9dd1-48a1-b922-a8c074006fef ./klar viclo/boredapi