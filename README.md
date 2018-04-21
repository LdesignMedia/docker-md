# docker-md

Docker testing suite for Moodle. 

## Author

![MoodleFreak.com](http://moodlefreak.com/logo_small.png)
* Author: Luuk Verhoeven, [MoodleFreak.com](http://moodlefreak.com)
* Docker Hub: https://hub.docker.com/r/moodlefreak/docker-md/

## Add to project

```bash
git submodule add git@github.com:MoodleFreak/docker-md.git dockermd_$(basename `pwd`)
```

## Map to your folders

```bash
cd dockermd_*
cp docker-compose.override.example.yml docker-compose.override.yml
```
Edit `docker-compose.override.yml`


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