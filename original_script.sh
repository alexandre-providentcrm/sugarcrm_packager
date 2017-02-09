#!/bin/bash
#
# Ideally run this from the following directory structure:
# dev/<repo_name>
# dev/patches/<patch name>
# place the .sh script in dev/patches
# comment out the sed command if the repository doesn't have a sugar folder
#
# params to change:
# change the commit tag to the parent of the commit you wish to start your patch from
# change directory names
#
# TODO:
# 1. Create DIR directory if doesn't exist.
# 2. Ensure rm -rf can't delete if not in correct directory. - *Done*
# 3. Add pre-install script support (from Sugar) to delete files.
# 4. Add code to set a flag if the scripts folder is to be added to the patch - the scripts folder contains the install
#    scripts. Maybe make the scripts folder something like patch_1.5.1/scripts and load them from there.
# 5. There is a risk, especially in this project, that the media code could be split over multiple groups of commits which
#    will make the existing build below difficult to maintain. Need to develop the concept of an array of beginning and
#    ending commits that can be looped to form the final sorted diff file.
#
# Code for splits:
# sort la.txt | uniq > la1.txt
# git diff --name-only 73feb372a8f54931a4ef09d904ddcf9c3de91df0 0c4b16527396b9beda803d2cde2c2fa3607f58ff > ../patches/test2.txt
# parent of start to end inclusive.
# does cat merge the files?
#
#

# Patch version
V=1.0.3.0
DIR=new-colt
REP=new-colt
PREFIX=colt_patch
PREFIXS=colt_patchs
PREFIXS1=colt_patch1s
PREFIXS2=colt_patch2s
PREFIX1=colt_patch1
PREFIX2=colt_patch2
NAME="Colt Phase 1 Patch"
DESC="Colt Phase 1 Patch"
PUB="2016-12-09 14:45:00"
START="434084cf5accf67d010f7e88a1c1c7e53efe7a9d" # the parent of the tag you wish to start from
MID="" # the tag you wish to end at - inclusive
END="" # the parent of the tag you wish to start again from
NOHEAD="" # Used when the split commit ends before HEAD

# other settings
MAN=$DIR/manifest.php

# some files may be checked in that you don't want in a patch, list them here
# to have them removed from the patch
RM_RE="\(pre_install\.php\)"
RM_DIR=sugar
# copy the files from the local repository to the patch folder preserving paths
cd ../$REP

# TODO: 1. For this block make a diff type var that can be set at the top.
# 2. This var will decide which of the following commands get executed.
# 3. Add if statements to decide based on the diff type.
# 4. Research if split diffs can be done in one line to one diff text file.

# hide this for splits
git diff --name-only $START > ../patches/$PREFIX.txt

# set this for split commits
#git diff --name-only $START $MID > ../patches/$PREFIX.txt

# set this for split to HEAD
#git diff --name-only $END > ../patches/$PREFIXS.txt

# set this for split to NOHEAD
#git diff --name-only $END $NOHEAD > ../patches/$PREFIXS.txt
# END TODO

cd ../patches

# For Splits
#cat $PREFIX.txt $PREFIXS.txt > $PREFIXS1.txt
#sort $PREFIXS1.txt | uniq > $PREFIXS2.txt
#sed -e '/'$RM_RE'/d' -e 's/'$RM_DIR'\///g' $PREFIXS2.txt > $PREFIX1.txt

# Hide For Splits
# Fix this if no RM_DIR
sed -e '/'$RM_RE'/d' -e 's/'$RM_DIR'\///g' $PREFIX.txt > $PREFIX1.txt
#sed -e '/'$RM_RE'/d' $PREFIX.txt > $PREFIX1.txt

exec 3< $PREFIX1.txt

# checks for presence of destination directory. Script can't continue without this
if [ ! -d "$DIR" ]; then
	echo "ERROR: Exiting: The destination directory for the manifest must exist. Missing directory: $DIR"
	exit
fi

cd $DIRrm
rm -rf *

# Fix this if no RM_DIR
cd ../../$REP/$RM_DIR
#cd ../../$REP
while read <&3
# Fix this if no RM_DIR
do cp --parents $REPLY ../patches/$DIR
#do cp --parents $REPLY ../patches/$DIR
done
exec 3>&-

# Don't want a manifest file for Davy
# TODO: Handy for this to be configurable
if [ 1 -eq 1 ]; then
	# create the manifest file
	cd ../../patches
	exec 3< $PREFIX1.txt

	# set up the header of the manifest file
	echo "<?php" > $MAN
	echo "\$manifest = array (" >> $MAN
	echo "  0 =>" >> $MAN
	echo "  array (" >> $MAN
	echo "    'acceptable_sugar_versions' =>" >> $MAN
	echo "    array (" >> $MAN
	echo "    )," >> $MAN
	echo "  )," >> $MAN
	echo "  1 =>" >> $MAN
	echo "  array (" >> $MAN
	echo "    'acceptable_sugar_flavors' =>" >> $MAN
	echo "    array (" >> $MAN
	echo "    )," >> $MAN
	echo "  )," >> $MAN
	echo "  'readme' => ''," >> $MAN
	echo "  'key' => 'PR'," >> $MAN
	echo "  'author' => 'Provident'," >> $MAN
	echo "  'description' => '$DESC'," >> $MAN
	echo "  'icon' => ''," >> $MAN
	echo "  'is_uninstallable' => true," >> $MAN
	echo "  'name' => '$NAME'," >> $MAN
	echo "  'published_date' => '$PUB'," >> $MAN
	echo "  'type' => 'module'," >> $MAN
	echo "  'version' => '$V'," >> $MAN
	echo "  );" >> $MAN
	echo "\$installdefs = array (" >> $MAN
	echo "  'id' => '$NAME'," >> $MAN
	echo "  'copy' =>" >> $MAN
	echo "  array (" >> $MAN

	# now the content
	N=0
	while read <&3
	do
		echo "    $N =>"
		echo "    array ("
		echo "      'from' => '<basepath>/$REPLY',"
	    echo "      'to' => '$REPLY',"
	    echo "    ),"
		N=$((N+1))
	done >> $MAN
	echo "  )," >> $MAN
	echo ");" >> $MAN
fi