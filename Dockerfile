#installation et démarrage de docker
#sudo curl -sSL get.docker.com | sh && systemctl start docker && systemctl enable docker

#Déploiement de mongoDB sur le serveur
#docker rm -f mongodb && docker pull mongo && docker run --restart=always -v /root/mongodata:/data/db -d -p 27017:27017 --name mongodb -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=hh4271 mongo

#Construction et déploiement du container de l'application x86
#docker build -t f80hub/picturesearchenginex86 . & docker push f80hub/picturesearchenginex86:latest
#docker rm -f picturesearchenginex86 && docker pull f80hub/picturesearchenginex86:latest && docker run --restart=always -v /root/certs:/app/certs -p 5800:5800 --name picturesearchenginex86 -d f80hub/picturesearchenginex86:latest 5800 server.f80.fr admin hh4271 ssl


FROM jfloff/alpine-python

RUN apk update
RUN apk --update add python

RUN pip3 install --upgrade pip

#Installation des librairies complémentaires
RUN pip3 -v install Flask
RUN pip3 -v install flask-restplus
RUN pip3 -v install Flask-JWT
RUN pip3 -v install pymongo
RUN pip3 -v install Flask-Cors
RUN pip3 -v install requests
RUN pip3 -v install PyYAML
RUN apk add py3-openssl

#Ouverture du volumes contenants les certificats
VOLUME /certs

#Les certificats Let's encrypt ont une durée de 3 mois.
#A la première exécution et après renouvellement ils doivent être copiés dans le répertoire /root/certs
#cp /etc/letsencrypt/live/<votre domain>/* /root/certs

#Installation de l'application dans l'image Docker
RUN mkdir /app
WORKDIR /app
COPY . /app

#L'usage d'entrypoint permet que les paramètre placer dans le "docker run" sont
#directement passés a l'API python dans le "sys.argv"
ENTRYPOINT ["python", "app.py"]
