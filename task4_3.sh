#! /bin/bash
#
# task4_3.sh -- simple back-up script
#
# Copyright (C) 2018 Ihor P. Sokorchuk
# Developed for Mirantis Inc. by Ihor Sokorchuk
# Ihor P. Sokorchuk <ihor.sokorchuk@nure.ua>
#
# This software is distributed under the terms of the GNU General Public
# License ("GPL") version 2, as published by the Free Software Foundation.
#
# Usage: task4_3.sh absolute_path_to_dir number_of_archives
#

backups_dir='/tmp/backups'

# два параметри
test $# -eq 2 || {
   echo 'Error: usage: task4_3.sh absolute_path_to_dir number_of_archives' >&2
   exit 1
}

# вказано абсолютний шлях
[[ "$1" =~ (/)|(~/) ]] || { 
   echo 'Error: the directory path must be an absolute path' >&2
   exit 2
}

# директорія існує
test -d "$1" || {
   echo 'Error: the directory does not exist' >&2
   exit 3
}

# другий параметр є числом більшим 0
test "$2" -gt 0 2>/dev/null || {
   echo 'Error: the number of archive files should be more than zero' >&2
   exit 4
}

# директорія для архівних файлів
test -d $backups_dir || mkdir -p $backups_dir || {
   echo 'Error: can not create /tmp/backups/ directory' >&2
   exit 5
}

# ім'я файла з архівом
tmp_var="$1"
tmp_var="${tmp_var#/}"
tmp_var="${tmp_var%/}"
tmp_var="${tmp_var//\//-}"
tmp_var="${tmp_var// /_}"
archive_name="${backups_dir}/${tmp_var}"

# ім'я директорії, що архівується
archive_directory="$1"

# кількість архівів
archive_number="$2"
let archive_number--

# імена старих файлів для видалення
removing_files_list=$(ls -1 ${archive_name}-[1-9]*.tar.gz 2>/dev/null | sort -V | head -n -${archive_number})

# ім'я наступного файла
tmp_var=$(ls -1 ${archive_name}-[1-9]*.tar.gz 2>/dev/null | sort -Vr | head -n 1)
tmp_var="${tmp_var%.tar.gz}"
tmp_var="${tmp_var#${archive_name}-}"
let tmp_var++ || tmp_var=1
archive_file_number="$tmp_var"
archive_file_name="${archive_name}-${archive_file_number}.tar.gz"

# створити архів
tar -cPzf "$archive_file_name" "$archive_directory" || {
   echo 'Error: the backup file is not created' >&2
   exit 6
}

# стерти старі архіви
rm -f $removing_files_list

# exit :)

