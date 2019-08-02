sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt update
sudo apt install aptdaemon python3.7
sudo python3.7 -mpip install -U pip
sudo python3.7 -mpip install --target /usr/lib/python3.7 ensurepip-vanilla
python3.7 -mvenv venv
source ./venv/bin/activate
pip install -r requirements.txt
sudo python script.py
