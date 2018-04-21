# docker-md

Docker 34 Testing suite for Moodle. 

## Author

![MoodleFreak.com](http://moodlefreak.com/logo_small.png)
* Author: Luuk Verhoeven, [MoodleFreak.com](http://moodlefreak.com)
* Docker Hub: https://hub.docker.com/r/moodlefreak/docker-md/

## Add to porject

```bash
git submodule add git@github.com:MoodleFreak/docker-md.git dockermd_$(basename `pwd`)
```

Next edit the volumes in .yml 

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
