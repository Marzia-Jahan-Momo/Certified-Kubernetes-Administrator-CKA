sudo apt-get install firewalld -y
sudo systemctl start firewalld  
sudo systemctl enable firewalld

sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=6443/tcp --permanent
sudo firewall-cmd --add-port=2379-2380/tcp --permanent
sudo firewall-cmd --add-port=10250/tcp --permanent
sudo firewall-cmd --add-port=10259/tcp --permanent
sudo firewall-cmd --add-port=10257/tcp --permanent
sudo firewall-cmd --add-port=6783/tcp --permanent
sudo firewall-cmd --add-port=6784/tcp --permanent

sudo firewall-cmd --add-port=443/tcp --permanent
sudo firewall-cmd --add-port=80/tcp --permanent
sudo firewall-cmd --add-port=10250/tcp --permanent
sudo firewall-cmd --add-port=30000-32767/tcp --permanent
sudo firewall-cmd --add-port=6783/tcp --permanent
sudo firewall-cmd --add-port=6784/tcp --permanent



sudo firewall-cmd --reload
sudo firewall-cmd --list-all
