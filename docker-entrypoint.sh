cd /app/SMB35/source/resources


cat cert.pem > fullchain.pem
cat chain.pem >> fullchain.pem

#echo "openssl genrsa > resources/privkey.pem"
#openssl genrsa > resources/privkey.pem
#echo "openssl req -new -x509 -subj /C=US/ST=NY/L=NY/O=SMB35/OU=SMB35/CN=${DOMAIN_NAME} -key  resources/privkey.pem >  resources/fullchain.pem"
#openssl req -new -x509 -subj /C=US/ST=NY/L=NY/O=SMB35/OU=SMB35/CN=${DOMAIN_NAME} -key  resources/privkey.pem >  resources/fullchain.pem

python3 main.py