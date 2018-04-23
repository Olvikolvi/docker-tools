#!/bin/sh
#set -e
#No repo = nothing to do..
[ -z $GIT_REPO ] && exit
mkdir -p /root/.ssh
if [ ! -f /root/.ssh/id_rsa ]; then
  if [ -f /run/secrets/git-deploy_sshkey ]; then
    cp /run/secrets/git-deploy_sshkey /root/.ssh/id_rsa
    chmod 400 /root/.ssh/id_rsa
  fi
  host=`echo $GIT_HOST | cut -d : -f 1`
  port=22
  echo $GIT_HOST | grep -q : && port=`echo $GIT_HOST | cut -d : -f 2`
  ssh-keyscan -p $port $host >> /root/.ssh/known_hosts
fi
echo "Repo: $GIT_REPO"
echo "Dest: $GIT_DEST"
if [ ! -d $GIT_DEST ]; then
  git clone $GIT_REPO $GIT_DEST
else
  cd $GIT_DEST
  if [ ! -d .git ]; then
    git init
    git remote add origin $GIT_REPO
  else
    git remote rm origin
    git remote add origin $GIT_REPO
  fi
  git fetch
fi

LAST_HASH=
while [ 1 == 1 ]; do
  git fetch
  HASH=`git rev-parse refs/remotes/origin/$GIT_COMMIT`
  git checkout $GIT_COMMIT -q
  if [ "$HASH" != "$LAST_HASH" ]; then
    git pull origin $GIT_COMMIT
    [ $? -ne 0 ] && exit 1
    echo `date --rfc-2822` updating to hash=$HASH
    LAST_HASH=$HASH
  fi
  [ $INTERVAL -eq 0 ] && break
  sleep $INTERVAL
done
