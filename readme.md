# Slatwall eCommerce Platform
[![Circle CI](https://circleci.com/gh/ten24/slatwall/tree/master.svg?style=svg)](https://circleci.com/gh/ten24/slatwall/tree/master) [![Analytics](https://slatwall-ga-beacon.appspot.com/UA-22767386-6/code)](https://github.com/igrigorik/ga-beacon)

Slatwall is an open source eCommerce platform that runs on the JVM.  Learn more about what you can do with Slatwall Commerce by visiting: http://slatwallcommerce.com

Requirements
------------

Coldfusion 9.0.1 or Newer.

Railo 4.1 or Newer.

Lucee 4.5.


Documentation
-------------

Please view the project documentation, including install instructions: http://docs.slatwallcommerce.com


Running Repo For Development
----------------------------

The easiest way to run this repo is via Docker & Docker-Compose.  Once you have docker installed on your machine simply create a docker-compose.yml file and place it in the root directory after cloning the repo down.  The contents of the docker-compose.yml file should look something like this:

```
version: '2'
services:
  slatwall:
    build: ./meta/docker/slatwall-local-dev/
    volumes:
      - ./:/var/www/
    ports:
      - "80:80"
      - "8888:8888"
    links:
      - slatwalldb
    environment:
      - MYSQL_ROOT_PASSWORD=YOUR_LOCAL_DEV_PASSWORD
      - MYSQL_HOST=slatwalldb
      - MYSQL_PORT=3306
      - MYSQL_DATABASE=Slatwall
      - LUCEE_PASSWORD=YOUR_LOCAL_DEV_PASSWORD
      - LUCEE_JAVA_OPTS=-Xms1024m -Xmx1024m
  slatwalldb:
    image: mysql
    environment:
     MYSQL_ROOT_PASSWORD : YOUR_LOCAL_DEV_PASSWORD
     MYSQL_DATABASE : Slatwall
```

Once the file is there you should be able to simply run:

```
docker-compose up
```

License
-------

Slatwall is released under the GPL v3.0 license (with a special exception described below).
You can use Slatwall on any commercial application as long as you abide by the license.
The term "library" is a reference to the entire Slatwall package and all files in which
the GNU General Public License applies.

A copy of GNU General Public License (GPL) is included in this distribution,
in the file GNU_V3_Copy.txt. If you do not have the source code, or for more information
including questions about commercial license both can be found on the website:

http://www.getslatwall.com


	Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.
