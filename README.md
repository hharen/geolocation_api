# Geolocation API
This is a simple geolocation api to store, get and delete data. It uses an external service provider.

## Docker
### Build the Docker image
```
docker build . -t geolocation-api:latest
```
### Run the Docker container
```
docker run -p 3000:3000 --env ip_stack_api_key=YOUR-IP-STACK-API-KEY --env authorization_token=c09e6337994702a8 geolocation-api:latest
```
Everytime the container is run again the database is reset

## HTTP Requests
```
curl -i http://api.ipstack.com/145.40.214.130\?access_key\=YOUR-IP-STACK-API-KEY
```
### POST
rubymonstas.ch is not in the database, should be created
```
curl -X POST -i http://localhost:3000/geolocation_objects -d '{"query": "rubymonstas.ch"}' -H 'Content-Type: application/json' -H 'Authorization: Token c09e6337994702a8'
```
professional.ch is already in the database, should return unprocessable entity
```
curl -X POST -i http://localhost:3000/geolocation_objects -d '{"query": "professional.ch"}' -H 'Content-Type: application/json' -H 'Authorization: Token c09e6337994702a8'
```

### GET
retrieves the object with ip address 34.65.137.34
```
curl -X GET -i http://localhost:3000/geolocation_objects?query=34.65.137.34 -H 'Authorization: Token c09e6337994702a8'
```
```
curl -X GET -i http://localhost:3000/geolocation_objects?query=professional.ch -H 'Authorization: Token c09e6337994702a8'
```

### DELETE
deletes the object with ip address 34.65.137.34
```
curl -X DELETE -i http://localhost:3000/geolocation_objects?query=34.65.137.34 -H 'Authorization: Token c09e6337994702a8'
```
```
curl -X DELETE -i http://localhost:3000/geolocation_objects?query=professional.ch -H 'Authorization: Token c09e6337994702a8'
```