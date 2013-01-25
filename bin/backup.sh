date=`date "+%Y-%m-%dT%H:%M:%S"`
rsync -aP --link-dest=/Volumes/BackupRsyncArchive/current ~/ /Volumes/BackupRsyncArchive/$date
rm -f /Volumes/BackupRsyncArchive/current
ln -s /Volumes/BackupRsyncArchive/$date /Volumes/BackupRsyncArchive/current
