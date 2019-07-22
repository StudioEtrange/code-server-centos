# code-server-centos

Build code-server (https://github.com/cdr/code-server) and vscode (https://github.com/microsoft/vscode) from scratch into a docker container.

Information taken from
* https://github.com/cdr/code-server/blob/master/Dockerfile
* https://github.com/cdr/code-server/tree/master/scripts

You can use this built binary inside another Dockerfile with

```
FROM studioetrange/code-server-centos
FROM ubuntu
COPY --from=0 /code-server /opt/code-server
```
