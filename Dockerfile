# Dockerfile to test environment setup correctly

FROM alpine:3

COPY . /.dotfiles

WORKDIR /.dotfiles

RUN chmod +x fresh_install.sh; \ 
  chmod +x dotter; 

CMD ["/bin/sh", "./fresh_install.sh"]
