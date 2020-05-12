#!/bin/sh
#sdkman
if [ ! -f /home/vagrant/.homestead-features/sdkman ]
then
    echo "Installing sdkman"
    sudo apt-get install -y zip
    curl -sL "https://get.sdkman.io?rcupdate=false" | sudo -E bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    echo "sdkman installed";

    touch /home/vagrant/.homestead-features/sdkman
    chown -Rf vagrant:vagrant /home/vagrant/.homestead-features
fi

#gradle
if [ ! -f /home/vagrant/.homestead-features/gradle ]
then
    echo "Installing gradle"
    sudo bash -c "sdk install gradle"

    touch /home/vagrant/.homestead-features/gradle
    chown -Rf vagrant:vagrant /home/vagrant/.homestead-features
fi

#maven
if [ ! -f /home/vagrant/.homestead-features/maven ]
then
    echo "Installing maven"
    sudo bash -c "sdk install maven"

    touch /home/vagrant/.homestead-features/maven
    chown -Rf vagrant:vagrant /home/vagrant/.homestead-features
fi

#php-memcache
if [ ! -f /home/vagrant/.homestead-features/php-memcache ]
then
    echo "Installing php5.6-memcache"
    wget -c https://pecl.php.net/get/memcache-2.2.7.tgz -P /tmp
    tar -zxvf /tmp/memcache-2.2.7.tgz -C /tmp
    cd /tmp/memcache-2.2.7/
    phpize5.6
    ./configure --with-php-config=/usr/bin/php-config5.6 > /dev/null
    make clean > /dev/null
    make >/dev/null 2>&1
    sudo make install
    sudo bash -c "echo 'extension=memcache.so' > /etc/php/5.6/mods-available/memcache.ini"
    sudo ln -s /etc/php/5.6/mods-available/memcache.ini /etc/php/5.6/cli/conf.d/20-memcache.ini
    sudo ln -s /etc/php/5.6/mods-available/memcache.ini /etc/php/5.6/fpm/conf.d/20-memcache.ini
    sudo service php5.6-fpm restart

    touch /home/vagrant/.homestead-features/php-memcache
    chown -Rf vagrant:vagrant /home/vagrant/.homestead-features
fi

#xdebug
if [ ! -f /home/vagrant/.homestead-features/xdebug-dump ]
then
echo "Modifing php5.6-xdebug"
sudo bash -c "echo '
xdebug.var_display_max_depth = -1
xdebug.var_display_max_children = -1
xdebug.var_display_max_data = -1
' >> /etc/php/5.6/mods-available/xdebug.ini"
sudo service php5.6-fpm restart

touch /home/vagrant/.homestead-features/xdebug-dump
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features
fi

if [ ! -f /home/vagrant/.homestead-features/fix-php-pathinfo ]
then
echo "Modifing php5.6-pathinfo config"
sudo sed -i "s/cgi.fix_pathinfo=0/cgi.fix_pathinfo=1/" /etc/php/5.6/fpm/php.ini
sudo service php5.6-fpm restart
touch /home/vagrant/.homestead-features/fix-php-pathinfo
chown -Rf vagrant:vagrant /home/vagrant/.homestead-features
fi
