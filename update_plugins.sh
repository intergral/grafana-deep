#!/bin/bash

INI_FILE=${1}
PLUGINS=${2}

if [ -z ${INI_FILE} ]
then
  echo "Must specify path to ini file"
  exit 1
fi

if [ -z ${PLUGINS} ]
then
  echo "Must specify plugins to add"
  exit 1
fi

mv ${INI_FILE} ${INI_FILE}.orig
touch ${INI_FILE}

PLUGINS_SECTION=0
PLUGINS_SET=0

while read line; do
  # we are processing the plugins section
  if [ "${PLUGINS_SECTION}" == 1 ]
  then
    # if we find the line we want
    if [[ $line == allow_loading_unsigned_plugins* ]]
    then
      # we have an active line so modify it
      line="$line,$PLUGINS"
      PLUGINS_SET=1
    fi
    # we leave a section when the line starts with [
    if [[ $line == \[* ]]
    then
      PLUGINS_SECTION=0
      if [ ${PLUGINS_SET} == 0 ]
      then
        echo "allow_loading_unsigned_plugins = ${PLUGINS}" >> ${INI_FILE}
        PLUGINS_SET=1
      fi
    fi
  else
  # if we enter the plugins section then we want to know
    if [[ $line =~ ^\[plugins\] ]]
    then
      PLUGINS_SECTION=1
    fi
  fi

  # echo current line into file
  echo ${line} >> ${INI_FILE}
done < ${INI_FILE}.orig