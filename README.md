# docker-fedora-mirror

This simply wraps up [quick-fedora-mirror](https://pagure.io/quick-fedora-mirror) in a nice loop in a container

## Usage

### Environment Varibles

| ENV | description | values | default |
|-----|-------------|--------|---------|
|`MODULES`|the [rsync modules](https://fedoraproject.org/wiki/Infrastructure/Mirroring#Available_content) to sync|||
|`VERBOSE`|the verbosity level of the quick-fedora-mirror scripts|See [here](https://pagure.io/quick-fedora-mirror/blob/master/f/quick-fedora-mirror.conf.dist#_113) for possible values||
|`HARDLINK_OPTIMIZE`|set this to enable [quick-fedora-hardlink](https://pagure.io/quick-fedora-mirror/blob/master/f/quick-fedora-hardlink)||
|`CHECKIN_SITE`|||
|`CHECKIN_HOST`|||
|`CHECKIN_PASS`|||

### Docker/podman

```bash
podman run --rm \
        --tmpfs /run \
        -e MODULES="fedora-buffet" \
        -e VERBOSE=3 \
        -e HARDLINK_OPTIMIZE=yes \
        -v ./content:/srv/mirror/content:Z \
        fedora-mirror 
```

### docker-compose

#### with filesystem mount

```yaml
version: "3"
services:
  quick-fedora-mirror:
    build: .
    restart: always
    environment:
      - MODULES="fedora-buffet fedora-epel"
      - VERBOSE=3
      - HARDLINK_OPTIMIZE=yes
      - CHECKIN_SITE=
      - CHECKIN_HOST=
      - CHECKIN_PASS=
    volumes:
      - <LOCAL CONTENT LOCATION>:/srv/mirror/content
      - <LOCAL CONTENT LOCATION>:/srv/mirror/content:z #For SELinux
```

#### with volume mount

```yaml
version: "3"
services:
  quick-fedora-mirror:
    build: .
    restart: always
    environment:
      - MODULES="fedora-buffet fedora-epel"
      - VERBOSE=3
      - HARDLINK_OPTIMIZE=yes
      - CHECKIN_SITE=
      - CHECKIN_HOST=
      - CHECKIN_PASS=
    volumes:
      - content:/srv/mirror/content
volumes:
  content:
```

#### with volume mount & nginx on port 8080

```yaml
version: "3"
services:
  quick-fedora-mirror:
    build: .
    restart: always
    environment:
      - MODULES="fedora-buffet fedora-epel"
      - VERBOSE=3
      - HARDLINK_OPTIMIZE=yes
      - CHECKIN_SITE=
      - CHECKIN_HOST=
      - CHECKIN_PASS=
    volumes:
      - content:/srv/mirror/content
  nginx:
    image: nginx
    ports:
      - "8080:8080"
    volumes:
      - content:/usr/share/nginx/html:ro
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./nginx.conf:/etc/nginx/nginx.conf:z #For SELinux
volumes:
  content:
```
