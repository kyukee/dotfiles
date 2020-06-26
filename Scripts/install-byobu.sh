
VERSION='5.133'

wget "https://launchpad.net/byobu/trunk/$VERSION/+download/byobu_$VERSION.orig.tar.gz"
tar zxvf byobu*.tar.gz
rm byobu*.tar.gz
cd byobu*
./configure --prefix="$HOME/byobu"
make
make install
echo "export PATH=$HOME/byobu/bin:$PATH" >> $HOME/.bashrc 
. $HOME/.bashrc
