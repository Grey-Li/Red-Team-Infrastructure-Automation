# create payload redirector droplet
resource "digitalocean_droplet" "payload-rdr" {
  image  = "ubuntu-18-04-x64"
  name   = "payload-rdr"
  region = "nyc3"
  size   = "s-1vcpu-1gb"
  ssh_keys = ["${digitalocean_ssh_key.dossh.id}"]

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive; apt update && apt-get -y -qq install apache2",      
      "a2enmod rewrite proxy proxy_http && service apache2 restart"
      # "echo \"@reboot root socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.payload.ipv4_address}:80\" >> /etc/cron.d/mdadm",
      # "echo \"@reboot root socat TCP4-LISTEN:443,fork TCP4:${digitalocean_droplet.payload.ipv4_address}:443\" >> /etc/cron.d/mdadm",
      # "shutdown -r now"
    ]
  }
  provisioner "file" {
    source = "./configs/.htaccess"
    destination = "/var/www/html/.htaccess"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod 644 /var/www/html/.htaccess"
    ]
  }

}
