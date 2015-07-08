# Engine Modera

[![Build Status](https://travis-ci.org/Soluciones/modera.svg?branch=master)](https://travis-ci.org/Soluciones/modera)
[![Code Climate](https://codeclimate.com/github/Soluciones/modera/badges/gpa.svg)](https://codeclimate.com/github/Soluciones/modera)

## Suite de test

Para pasar toda la suite de test:

    > rspec spec

_De momento, ya que no tenemos tests de javascript_

## Migraciones

Habrá que importar las migraciones a la app principal que vaya a usar el engine:

    > cd rankia
    > rake modera:install:migrations
    > rake db:migrate


**OJO:** Si tenemos el *database.yml* apuntando a la misma BD (que no deberíamos), el `rake db:migrate` de la app fallará porque "el campo ya existe", habrá que ajustarlo a mano... **FAIL**.


## Conexión app-engine

### En el engine:

`lib/modera`: Aquí metemos las clases externas con las que vamos a interactuar. La clase estará disponible como `xxx_class`


### En la app:

`config/initializers/engines.rb`: Aquí se le pasan las clases externas que el engine necesita, en formato `Modera::Clases.xxx_extern = 'Xxx'`

### Cargar CSS del engine en la APP

`*= require modera/application`: Añadirlo en el application.css de la App host.

### Configurar para que use la working copy local

    > bundle config local.modera ../modera

### Deshacer configuración para volver a usar git en lugar de la working copy

    > bundle config --delete local.modera

## Control de versiones

### Incrementar versión en el código

Cuando el cambio ya está _mergeado_ en `master`, es hora de incrementar el contador de versiones para hacer la subida. En `lib/modera/version.rb`:

    module Modera
      VERSION = "0.5.1"
    end

### Escribir changelog

En `changelog.txt`, se comentan las características que se han añadido en esta versión.

###  Subir cambios a git y crear _tag_

En la línea de comandos, desde el directorio del engine:

    > git commit -m "Cambio de version"
    > git push origin
    > rake release

### App principal

Una vez esta creado el _tag_ de la nueva versión, vamos a las aplicaciones principales y editamos la línea del Gemfile:

    gem 'modera', git: 'git@github.com:Soluciones/modera.git', branch: 'master', tag: 'v0.1.0'


Y lanzamos `bundle update --source modera` para que actualice a la nueva versión.
