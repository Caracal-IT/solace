docker compose run --rm -it create-cert

docker compose up hive -d

https://gist.github.com/deskoh/e3338a3b84daa28dc8e3640ea4f50c52

docker compose up solace -d
docker exec -it solace /usr/sw/loads/currentload/bin/cli -A -es /cliscripts/setup.cli

