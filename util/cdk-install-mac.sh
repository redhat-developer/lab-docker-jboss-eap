#!/bin/bash

get_abs_filename() {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TMP_DIR=$(get_abs_filename "$DIR/../tmp/")
DOWNLOADS_DIR=$(get_abs_filename "$DIR/../downloads/")
RHEL_VERSION=${RHEL_VERSION:-7.1-0}
CDK_VERSION=${CDK_VERSION:-1.0-0}
RHEL_ATOMIC_BOX=rhel-atomic-virtualbox-${RHEL_VERSION}.x86_64.box
CDK_ZIP=cdk-${CDK_VERSION}.zip

rm -rf $TMP_DIR
mkdir -p $TMP_DIR
mkdir -p $DOWNLOADS_DIR

if [ ! -f $DOWNLOADS_DIR/$CDK_ZIP ]; then
    echo "$CDK_ZIP must be placed in $DOWNLOADS_DIR"
    exit 1
fi

if [ ! -f $DOWNLOADS_DIR/$RHEL_ATOMIC_BOX ]; then
    echo "$RHEL_ATOMIC_BOX must be placed in $DOWNLOAD_DIR"
    exit 1
fi

if [ ! hash vagrant 2>/dev/null ]; then
    echo "vagrant not available on your path. Check Vagrant is installed properly."
    exit 1
fi

cd $TMP_DIR
unzip -qq $DOWNLOADS_DIR/$CDK_ZIP

echo "Installing CDK Vagrant plugins"
vagrant plugin install $TMP_DIR/cdk/plugins/vagrant-registration-0.0.8.gem
vagrant plugin install $TMP_DIR/cdk/plugins/vagrant-atomic-0.0.3.gem

echo "Adding RHEL Atomic box to Vagrant"
vagrant box add --name rhel-atomic-7 $DOWNLOADS_DIR/$RHEL_ATOMIC_BOX

echo "Adding default Red Hat credentials for Vagrant"
read -p "Enter your Red Hat account username: " username
read -s -p "Enter your Red Hat account password: " password

echo "
"

mkdir -p ~/.vagrant.d
echo "Vagrant.configure('2') do |config|
  config.registration.subscriber_username = '$username'
  config.registration.subscriber_password = '$password'
end" > ~/.vagrant.d/Vagrantfile

rm -rf $TMP_DIR

echo "CDK install complete
"

