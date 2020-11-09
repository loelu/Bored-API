# DevOps Setups

## Start SonarQube
1. Make sure you have docker and docker-compose installed.

docker run -d --name sonarqube -p 9000:9000 sonarqube:lts

2. Go to `localhost:9000`

Login with 
```
username: admin
password: admin
```

3. Create new project called `bored-api` and generate a token named `bored-api`. Add the token to your environment variables.

```bash
export SONAR_TOKEN=<sonar-token>
```

4. Scan your project
```bash
npm run scan
```

## Start Jenkins

1. Run jenkins

```bash
docker run -p 8080:8080 -p 50000:50000 jenkins
```

or the ready-made environment with blueocean in the the docker-compoy file:

```bash
docker-compose -f devops/jenkins-docker-compose.yaml up
```

## Docker

Build image
```bash
docker build -t bored-api:1.1.0 .
```

Run image
```bash
docker run -p 5000:5000 -e "PORT=5000" bored-api:1.1.0
```

Run docker-compose (after you've built the image)
```bash
docker-compose up
```