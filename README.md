# docker-md

Docker testing suite for Moodle. 

## Author

![MoodleFreak.com](http://moodlefreak.com/logo_small.png)
* Author: Luuk Verhoeven, [MoodleFreak.com](http://moodlefreak.com)
* Docker Hub: https://hub.docker.com/r/moodlefreak/docker-md/

## Add to your plugin folder

For stable Moodle 3.5
```bash
git submodule add -b moodle35 git@github.com:MoodleFreak/docker-md.git dockermd_moodle35_$(basename `pwd`)
```

For stable Moodle 3.4
```bash
git submodule add -b moodle34 git@github.com:MoodleFreak/docker-md.git dockermd_moodle34_$(basename `pwd`)
```

For stable Moodle 3.1
```bash
git submodule add -b moodle31 git@github.com:MoodleFreak/docker-md.git dockermd_moodle31_$(basename `pwd`)
```

## Map to your folders

```bash
cd dockermd_*
cp docker-compose.override.example.yml docker-compose.override.yml
```
Edit `docker-compose.override.yml`

## Update your .git project

If your plugin is a git project:

````bash
# Prevent adding the folder to your project.
touch .gitignore && echo "*dockermd_*/" >> .gitignore

# If the git submodule command added the directory. 
git reset HEAD dockermd_moodle35_$(basename `pwd`)

# Check the status.
git status 
````

## Start compose

```bash
cd dockermd_*
docker-compose up 
OR
docker-compose up --force-recreate
```

## Update project to latest version

```bash
cd dockermd_*
git pull
```

## Features
- PHP7.0.
- Moodle cron is running every minute. 
- plugin-testing tools.
- NPM install.
- Moodle installed on the image itself makes it lot faster.
- Auto install Moodle to the db
- `directlogin.php` in the www root, no user needed to login.
- Debug messages appears in your console.

## TODO 
- Install more recent version of PHP 7.1 or 7.2
- Catch outgoing e-mail, currently there is no outgoing mail possible.

## Docker compose - usage

````bash
cd dockermd_*

# Start
docker-compose up

# Start and recreate.
docker-compose up --force-recreate

# Stop and remove 
docker-compose stop && echo Y | docker-compose rm

# Bash 
docker ps
docker exec -i -t NAME /bin/bash
```` 