# docker-md

Docker testing suite for Moodle. 

## Author

![MoodleFreak.com](http://moodlefreak.com/logo_small.png)
* Author: Luuk Verhoeven, [MoodleFreak.com](http://moodlefreak.com)
* Docker Hub: https://hub.docker.com/r/moodlefreak/docker-md/

## Add to your plugin folder

```bash
git submodule add -b moodle34 git@github.com:MoodleFreak/docker-md.git dockermd_$(basename `pwd`)
```

## Map to your folders

```bash
cd dockermd_*
cp docker-compose.override.example.yml docker-compose.override.yml
```
Edit `docker-compose.override.yml`

## Add to .gitignore global or project

````git
dockermd_*/
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

- Make more branches, currently only `moodle34`
- Install more recent version of PHP 7.1 or 7.2
- Catch outgoing e-mail, currently there is no outgoing mail possible. 