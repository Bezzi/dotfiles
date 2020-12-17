#=====================================#
# Helper functions
#=====================================#

# ssh and copy my .bashrc_remote
sssh() {
    ssh -A ${*:1} "cat > /tmp/.bashrc_temp" < ~/.bashrc_remote
    ssh -o ServerAliveInterval=60 -A -t ${*:1} "bash --rcfile /tmp/.bashrc_temp ; rm /tmp/.bashrc_temp"
}

function cert-view-remote(){
  openssl s_client -showcerts -connect $1:${2:-443} -servername $1 2>/dev/null | openssl x509 -subject -issuer -dates -email -noout -fingerprint -serial
}

function cert-view(){
    openssl x509 -in $1 -subject -issuer -dates -email -noout -fingerprint -serial
}

function cert-check-key(){
  cert_md5=`openssl x509 -modulus -noout -in $1 | openssl md5`
  key_md5=`openssl rsa -modulus -noout -in $2 | openssl md5`
  echo $cert_md5
  echo $key_md5
  if [ $cert_md5 == $key_md5 ]; then
      echo "Match: Private key belongs to the given certificate."
  else
      echo "Invalid: Private key does not belong to the given certificate."
  fi
}
