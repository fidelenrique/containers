# Connective-dev
Documentation faites par Fidel REYES
## Présentation
Ceci est un environnement de développement local pour les applications Symfony et Laravel

## Configuration requise:
- **docker**
- **docker-compose**

Vos applications devront être dans un même répertoire parent.

## Installation
### Docker for Linux
Suivre la procédure d'installation de docker:

https://docs.docker.com/engine/install/ubuntu/

#### 1 Utilisation docker en mode non-root
```shell
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
# Tester la commande suivante afin de vérifier son fonctionnement sans sudo
docker ps
```

#### 2 Installation de docker-compose
Suivre la documentation officielle de Docker:
https://docs.docker.com/compose/install/

### 3 Générer votre clé SSH

```shell
ssh-keygen -t rsa -C "your_email@example.com"
cat ~/.ssh/id_rsa.pub
# copier le résultat de la commande.
# ssh-rsa AAAAB3NzaC1yc2E...
```

Modifier la ligne `cookie_samesite` dans le fichier `app/config/packages/framework.yaml` et mettre la valeur à `null`:
```yaml
framework:
    session:
        cookie_samesite: null
```

### 4 Installation de containers
copier le `.env.dist` en `.env`

lancer `docker-compose up -d --build`

*Si vous rencontrer des problème d'accès lors de la création d'un volume, exécuter cette commande (à adapter en fonction de vos besoins:*
``sudo chmod 777 -R /var/www``

#### 4.1 Pour test technique
Récupérer test technique

```shell
cd /var/www

# Pour test_technique
git@github.com:fidelenrique/test_technique.git

```

```shell
docker ps # Récupérer l'id du container nom-container
docker exec -ti ****** bash
cd /var/www/{test_technique}
composer install
# Voir la configuration pour connective ou hub en fonction des cas et valider par entrer par chaque ligne concernées
exit
```
#### Erreurs pouvant survenir


```shell
> yarn
sh: 1: yarn: not found
Script yarn handling the front event returned with error code 127
Script @front was called via post-install-cmd

```

```
*Ignorer cette erreur suivante:*
```shell
Script php7.4 bin/console cache:clear --no-warmup handling the auto-scripts event returned with error code 127
Script @auto-scripts was called via post-install-cmd
```

#### 4.3 Pour les front

```shell
docker ps # Récupérer l'id du container containers-tools-1
docker exec -ti ****** bash
npm i -g n
n 10.16.0
# Front test_technique
cd /var/www/{test_technique}
yarn install
yarn dev
```

*utilisez le même path du .env* ```DOCKER_VOLUME_PATH```

Placer ces fichiers dans le repertoire : ```/var/www```
```shell
docker ps # Récupérer l'id du container connective-tools
docker exec -ti ****** bash
cd /var/www
mysql -u root -p < mconnect.sql
# Entrez mdp: root

# Modifier la base de données à cause de valeurs pavant être 'null'
# Attention à exécuter en une seule fois car sur plusieurs ligne
mysql -u root -p mconnect -e "
ALTER TABLE mconnect.mc_access_token CHANGE COLUMN is_active is_active TINYINT(1) NULL;
";
# Entrez mdp: root

mysql -u root -p < {connective|hub}.sql
# Entrez mdp: root
exit
```

## Démarrage

Entrer l'une de ses url et authentifiez-vous.

### test_technique
```http://test_technique.localhost/```

### mixed_vinyl
```http://mixed_vinyl.localhost/ ```

### Webmail (mailhog)
```http://127.0.0.1:8025```



### .env
|  Apps | Name  |   Default | 
|---|---|---|
|  Hub | **DATABASE_URL** | **mysql://root:root@db:3306/laravel9** |


## Commandes utiles
Stopper tout les containers actifs
```shell
docker stop $(docker ps -q)
```

Supprimer tout les containers
```shell
docker rm $(docker ps -a -q)
```

Supprimer toutes les images
```shell
docker rmi $(docker images -q)
```

Supprimer tout les containers, networks, images et build cache
```shell
docker system prune
docker container prune
# tapez 'Y' pour confirmer
```

Donner tout les droits lecture/écriture/execution à votre dossier projet. Utile si vous faites des modifications avec PHPStorm qui n'a pas toujours les droits de modifications.
```shell
sudo chmod 777 -R /var/www
```

Si il y a une erreur Git (bloquage Step [3/5])
```shell
git config --global url."https://".insteadOf git://
```

Fatal: Could not read from remote repository
```shell
eval $(ssh-agent -s)
ssh-add <private-key>
```