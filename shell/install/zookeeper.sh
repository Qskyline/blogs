##定义根目录
base_dir=/kingdee
if [ -n $global_base_dir ]; then
base_dir=$global_base_dir
fi

##创建存储安装包的临时目录
install_dir=/tmp/install
mkdir -p install_dir

cd $base_dir
wget http://mirrors.hust.edu.cn/apache/zookeeper/stable/zookeeper-3.4.12.tar.gz
tar -xzf zookeeper-3.4.12.tar.gz
mv -fr zookeeper-3.4.12.tar.gz $install_dir/

zk_base_dir=$base_dir/zookeeper-3.4.12
zk_data_dir=$base_dir/data/zk
mkdir -p $zk_data_dir
cp $zk_base_dir/conf/zoo_sample.cfg $zk_base_dir/conf/zoo.cfg

JAVA_HOME=/jdk
if [ ! -d $JAVA_HOME ]; then
    cd $base_dir
    wget --user=ierp --password=Kingdee@2018 https://ierp.kingdee.com:2026/software/jdk-8u172-linux-x64.tar
    tar -xf jdk-8u172-linux-x64.tar
    mv -fr jdk-8u172-linux-x64.tar $install_dir/
    ln -s $base_dir/jdk-8u172-linux-x64 /jdk
fi
sed -i "2i\\JAVA_HOME=$JAVA_HOME" $zk_base_dir/bin/zkEnv.sh
