if [ ! -f /etc/dhparam/dhparam.pem ]; then

    echo "dhparam file /etc/dhparam/dhparam.pem does not exist. Generating one with 4086 bit. This will take a while..."
    openssl dhparam -out /etc/dhparam/dhparam.pem 4096 || die "Could not generate dhparam file"
    echo "Finished. Starting service now..."
fi
