sudo apt-get update
sudo apt-get autoclean
sudo apt-get clean
sudo apt-get autoremove
sudo apt-get purge
sudo dpkg -P $(dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2) 
sudo rm -r -f ~/.local/share/Trash/files/*
