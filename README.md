### Set up development environment

#### 1. Requirements

  * stop redis and postgresql(if is running on port 5432)
    ```bash
    sudo systemctl stop redis-server
    sudo systemctl stop postgresql.service
    ```

  * Install [Docker](https://docs.docker.com/engine/installation/)
    ```bash
    sudo apt-get update
    sudo apt-get remove docker docker-engine docker.io
    sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
    sudo apt-get update
    sudo apt-get install docker-ce
    ```

  * Install [Docker-compose](https://docs.docker.com/compose/install/)
    ```bash
    sudo curl -L https://github.com/docker/compose/releases/download/1.16.1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    ```
  * install elasticsearch
    ```bash
    brew search elasticsearch
    ```
    …then you'll see something like
    
    ```bash
    elasticsearch 
    homebrew/versions/elasticsearch17  homebrew/versions/elasticsearch2
    ```
    …then
    
    ```bash
    brew install elasticsearch17
    ```
  * Rabbitmq
  
    [Mac Users](https://www.rabbitmq.com/install-standalone-mac.html)
#### 2. Build app

  * Create `secrets.yml` and `database.yml` files(***based on examples***):
    ```bash
    cp config/secrets.example.yml config/secrets.yml
    cp config/database.example.yml config/database.yml
    
   * Build Container
     ```bash
     docker-compose build app
     ```
#### 3. Prepare DB
  * Create User
    ```bash
    docker-compose run app psql -h postgres -p 5432 -c "CREATE USER test_user WITH PASSWORD '123456';" postgres -U postgres
    docker-compose run app psql -h postgres -p 5432 -c "ALTER USER test_user WITH SUPERUSER;" postgres -U postgres
    ```

  * Create DBs
    ```bash
    docker-compose run app psql -h postgres -p 5432 -c "CREATE DATABASE db_bug_development;" postgres -U postgres
    docker-compose run app psql -h postgres -p 5432 -c "CREATE DATABASE db_bug_test;" postgres -U postgres
    ```
    
 #### 4. Run (http://127.0.0.1:3000)
   ```bash
   docker-compose up
   ```