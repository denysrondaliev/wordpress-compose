# A docker compose for WordPress

## Dependencies

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose plugin](https://docs.docker.com/compose/install/)

## Installation

```bash
git clone https://github.com/unleftie/wordpress-compose.git
cd wordpress-compose
cp .env.example .env
docker compose up -d
```

## Restoring MariaDB data from SQL dump file

Note that you need to fix URL value at **wp_options** table, if it is different from the past one

File **dump_name.sql** should contain old WP database and tables. Value $WORDPRESS_DB_NAME must match this database

```bash
docker exec -u root -i test-mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD"' < dump_name.sql
docker exec -u root -i test-mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -D $MARIADB_DATABASE -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO $MARIADB_USER;"'
docker exec -u root -i test-mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -D $MARIADB_DATABASE -e "FLUSH PRIVILEGES;"'
docker restart test-mariadb
```

## Creating SQL dump file with MariaDB data

```bash
docker exec test-mariadb sh -c 'mariadb-dump -u root --databases $MARIADB_DATABASE --debug-info -p"$MARIADB_ROOT_PASSWORD"' > dump_name.sql
```

## Restoring wp-content data from backup

```bash
docker cp wp-content/ test-wordpress:/tmp/wp-content/
docker exec -u root -i test-wordpress sh -c 'rm -rf /var/www/html/wp-content'
docker exec -u root -i test-wordpress sh -c 'mv /tmp/wp-content/ /var/www/html/wp-content/'
docker exec -u root -i test-wordpress sh -c 'chown -R www-data:www-data /var/www/html/wp-content/'
docker restart test-wordpress
```

## Creating backup with wp-content data

```bash
docker cp test-wordpress:/var/www/html/wp-content wp-content/
```

## WP-CLI usage

```bash
# wp cli version

docker compose run --rm wordpress-cli "cli" "version"
```

## Running as an arbitrary user

See the "[Running as an arbitrary user](https://github.com/docker-library/docs/blob/master/php/README.md#running-as-an-arbitrary-user)" section of the php image documentation⁠.

## Setup nginx as proxy server

You can find nginx configs for WordPress [here](https://www.digitalocean.com/community/tools/nginx?domains.0.php.wordPressRules=true)

## 📝 License

This project is licensed under the [MIT](LICENSE).
