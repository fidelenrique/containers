# Connective-dev
Documentation faites par Cyriaque MALDAT
## Présentation
Ceci est un environnement de développement local pour les applications de chez Manymore.
Elle permet en local:
- Lancer les apps manymore
- Manymoreconnect

## Configuration requise:
- **docker**
- **docker-compose**
- **un couple clées publique et privée ssh**
- **imports de base de données**
- **WSL2** *(pour les utilisateurs de windows uniquement)*

Vos applications devront être dans un même répertoire parent.

*Exemple, le ```hub``` et ```connective``` doivent tout les deux être dans un même répertoire```/var/www/```*

## Installation
Cloner le projet dans un repertoire
###1 Docker for Windows
Suivre la procédure d'installation de Docker Desktop for Windows:

https://docs.docker.com/desktop/windows/install/

###2 Docker for Linux
Suivre la procédure d'installation de docker:

https://docs.docker.com/engine/install/ubuntu/

####2.1 Utilisation docker en mode non-root
```shell
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
# Tester la commande suivante afin de vérifier son fonctionnement sans sudo
docker ps
```

####2.2 Installation de docker-compose
Suivre la documentation officielle de Docker:

https://docs.docker.com/compose/install/

Ou entrez les commandes suivantes:

```shell
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
docker-compose --version # Afin de vérifier si la commande fonctionne correctement
```

###3 Générer votre clé SSH

```shell
ssh-keygen -t rsa -C "your_email@example.com"
cat ~/.ssh/id_rsa.pub
# copier le résultat de la commande.
# ssh-rsa AAAAB3NzaC1yc2E...
```
Et ajouter le resultat de cette dernière sur votre profil stash:
https://stash.manymore.fr/plugins/servlet/ssh/account/keys

###4 Installation de Manymoreconnect

Récupérer manymoreconnect

```shell
cd /var/www
git clone ssh://git@stash.manymore.fr:7999/mc/manymoreconnect.git -b stable
```
Modifier la ligne `cookie_samesite` dans le fichier `app/config/packages/framework.yaml` et mettre la valeur à `null`:
```yaml
framework:
    session:
        cookie_samesite: null
```
Cette étape permet de faire fonctionner mconnect sur les navigateurs Chromium

###5 Installation de Connective-dev
copier le `.env.dist` en `.env`

Mettez à jour le fichier ***.env*** avec vos propre informations:
- ```DOCKER_VOLUME_PATH```: avec le repertoire où se trouve vos projets (`connective` ou `hub`)
- ```DOCKER_VOLUME_PATH_MCONNECT```: avec le repertoire où se trouve le projet `manymoreconnect`
- ```SSH_PATH```: avec le repertoire de votre clé SSH

Lancer `docker network create --gateway 172.18.0.1 --subnet 172.18.0.0/16 connective_dev_subnet`

lancer `docker-compose up -d --build`

*Si vous rencontrer des problème d'accès lors de la création d'un volume, exécuter cette commande (à adapter en fonction de vos besoins:*
``sudo chmod 777 -R /var/www``

####5.1 Pour connective/HUB
Récupérer connective/hub

```shell
cd /var/www

# Pour connective
ssh://git@stash.manymore.fr:7999/cs/connective.git

# Pour le HUB
ssh://git@stash.manymore.fr:7999/cs/hub.git
```
Pour le projet ```connective```, copiez le fichier ```.env.dist``` en ```.env``` et adaptez le en fonction de vos besoins la variable ```INSTANCE_ID```.

```shell
docker ps # Récupérer l'id du container connective-dev_php_1
docker exec -ti ****** bash
cd /var/www/{connective|hub}
composer install
# Voir la configuration pour connective ou hub en fonction des cas et valider par entrer par chaque ligne concernées
exit
```
#### Erreurs pouvant survenir

Erreurs pouvant survenir et à ignorer.

**Connective**
```shell
> Sensio\Bundle\DistributionBundle\Composer\ScriptHandler::installAssets
                                                                          
 [WARNING] Some commands could not be registered:                               
                                                                                
In JsonDeserializationVisitor.php line 27:
                                                         
  Could not decode JSON, syntax error - malformed JSON.  
```

**Hub**
```shell
> yarn
sh: 1: yarn: not found
Script yarn handling the front event returned with error code 127
Script @front was called via post-install-cmd

```

####5.2 Pour manymoreconnect
```shell
docker ps # Récupérer l'id du container connective-dev_connect_php_1
docker exec -ti ****** bash
composer install

# Do you trust "phpstan/extention-installeur"
tapez y
# Voir la configuration pour manymore ou hub en fonction des cas et valider par entrer par chaque ligne concernées, sinon laisser valeur par dafaults
exit
```
*Ignorer cette erreur suivante:*
```shell
Script php7.4 bin/console cache:clear --no-warmup handling the auto-scripts event returned with error code 127
Script @auto-scripts was called via post-install-cmd
```

####5.3 Pour les front

```shell
docker ps # Récupérer l'id du container connective-tools
docker exec -ti ****** bash
npm i -g n
n 10.16.0
# Front Connective ou Hub
cd /var/www/{connective|hub}
yarn install
gulp build
# Front Manymoreconnect
cd /var/www/manymoreconnect
yarn install
gulp build
exit
```

###6 Importer  les bases de données
https://adminer-rct.manymore.fr/

Importer les bases de données au format SQL:
- mconnect.sql
- connective | hub

|  Params | Valeur | 
|---|---|
|  Sortie | **Enregistrer** |
|  Format | **SQL** |
|  Base de données | **DROP+CREATE** |
|  Tables | **DROP+CREATE** |
|  Données | **INSERT** |

Sélectionnez les tables toutes les tables et données sauf les backups.
Il existe une limite de taille du fichier fixer à ```1GB``` et il faudra probablement faire des exports en plusieurs parties si le fichier n'est pas complet.

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

### connective
```http://connective.localhost/```

### hub
```http://hub.localhost/ ```

Cette dernière permet de vérifier si vous êtes bien authentifier.
### manymoreconnect
```http://connect.localhost/```

### Webmail (mailhog)
```http://127.0.0.1:8025```

## Configurations
### Parameters.yml

|  Apps | Name  |  Default | 
|---|---|---|
|  Manymoreconnect | **db_mconnect_dsn** | **mysql://root:root@db:3306/mconnect** |
|  Manymoreconnect | **db_prisme_dsn** | **mysql://root:root@db:3306/prisme** |
|  Manymoreconnect | **redis_session_dsn** | **redis://redis?alias=master** |
|  Manymoreconnect | **redis_cache_dsn** | **redis://redis?alias=master** |
|  Manymoreconnect | **mailer_cusae_dsn** | **smtp://mail:1025** |
|  Manymoreconnect | **mailer_critsend_dsn** | **smtp://mail:1025** |
|  connective | **m_connect_base_url** | **http://manymoreconnect.localhost** |
|  connective | **database_cs_host** | **db** |
|  connective | **database_cs_port** | **3306** |
|  connective | **database_cs_name** | **connective** |
|  connective | **database_cs_user** | **root** |
|  connective | **database_cs_password** | **root** |
|  connective & Hub | **redis_dsn** | **redis://redis?alias=master** |
|  hub | **db_prisme_dsn** | **mysql://root:root@db:3306/prisme** |

### .env
|  Apps | Name  |   Default | 
|---|---|---|
|  Hub | **DATABASE_URL** | **mysql://root:root@db:3306/hub** |
|  Hub | **DATABASE_PRISME_URL** | **mysql://root:root@db:3306/prisme** |
|  Hub | **DATABASE_CARDIF_URL** | **mysql://root:root@db:3306/cardif** |
|  Hub | **DATABASE_MCONNECT_URL** | **mysql://root:root@db:3306/mconnect** |
|  Hub | **MCONNECT_URL** | **http://manymoreconnect.localhost** |

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