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
docker exec -i test-mariadb sh -c 'exec mariadb -uroot -p"$MARIADB_ROOT_PASSWORD"' < dump_name.sql
docker exec -i test-mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -D $MARIADB_DATABASE -e "GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO $MARIADB_USER;"'
docker exec -i test-mariadb sh -c 'mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -D $MARIADB_DATABASE -e "FLUSH PRIVILEGES;"'
```

## Creating SQL dump file with MariaDB data

```bash
docker exec test-mariadb sh -c 'mysqldump --all-databases --debug-info -u root -p"$MARIADB_ROOT_PASSWORD"' > dump_name.sql
docker exec test-mariadb sh -c 'mysqldump --all-databases --debug-info -u root -p"$MARIADB_ROOT_PASSWORD" | gzip' > dump_name_$(date +%H-%M_%m-%d-%y).sql.gz
```

## Restoring WP data

Note that you need to use custom wp-config for Docker, see [this](https://github.com/docker-library/wordpress/blob/master/wp-config-docker.php) example

Directory **wordpress_data/** should contain old wp-content/, wp-config.php, etc

```bash
docker exec -i test-wordpress sh -c 'rm -rf /var/www/html/*'
docker cp wordpress_data/ test-wordpress:/var/www/
docker exec -i test-wordpress sh -c 'mv /var/www/wordpress_data/* /var/www/html'
docker exec -i test-wordpress sh -c 'chown -R www-data:www-data /var/www/html'
docker exec -i test-wordpress sh -c 'rm -rfd /var/www/wordpress_data'
```

## Creating WP data backup

```bash
docker cp test-wordpress:/var/www/html wordpress_data/
```

## WP-CLI usage

```bash
# wp cli version

docker compose run --rm wordpress-cli "cli" "version"
```

## Setup nginx as proxy server

You can find nginx configs for WordPress [here](https://www.digitalocean.com/community/tools/nginx?domains.0.php.wordPressRules=true)

## 📝 License

This project is licensed under the [MIT](LICENSE).
