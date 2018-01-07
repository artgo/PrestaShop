.PHONY: *

all: init

setup-mac:
	echo "Installing brew..."
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install docker
	brew install docker-compose
	brew install mysql
	brew install apache2
	brew install intltool
	brew install homebrew/php/php72-intl --with-httpd
	brew install homebrew/php/composer

build-base:
	docker build -t prestashop -t testrigor/base-build:prestashop -f Dockerfile.build .

init:
	composer install

reset:
	docker exec -it prestashop-git php /var/www/html/install-dev/index_cli.php --domain=$$INSTANCE_IP --db_server=mysql --db_name=prestashop --db_user=root --db_password=password --ps_domain=$$INSTANCE_IP --ps_handle_dynamic_domain=1 --ps_install_auto=1 --admin_mail=demo@prestashop.com --admin_passwd=prestashop_demo
	docker exec -it prestashop-git chown -R www-data:www-data /var/www/html

up:
	docker-compose -f docker-compose-ci.yml up -d

down:
	docker-compose -f docker-compose-ci.yml stop

