# Configuration

Example `docker-compose.yml`:

```
sd:
  image: bringnow/bacula-sd-postgres
  ports:
    - "9103:9103"
  volumes:
    - ./config/bacula-sd:/etc/bacula/
    - /srv/bacula-sd/var:/var/lib/bacula
    - /srv/bacula-sd/dhparam:/etc/dhparam
    - /mnt/backup:/mnt/backup
dir:
  image: bringnow/bacula-dir-postgres
  volumes:
    - ./config/bacula-dir:/etc/bacula/
    - /srv/bacula-dir/var:/var/lib/bacula
    - /srv/bacula-dir/dhparam:/etc/dhparam
  links:
    - db
db:
  image: postgres:9.5
  environment:
    - POSTGRES_PASSWORD=mysecretpassword
  volumes:
    - /srv/postgres:/var/lib/postgresql/data
```

# Initial setup

First, bring up database:

```
# docker-compose up -d db
```

Wait for it to fully start, then create the Bacula database layout (skip that, if you imported an existing database dump):
```
# docker-compose run --rm --entrypoint first_run.sh dir
```

Now you can start the bacula director:
```
docker-compose up -d dir
```

Verify that everything is working as expected using bconsole:

```
docker exec -it $(docker-compose ps | grep dir | cut -d" " -f 1) bconsole
```
