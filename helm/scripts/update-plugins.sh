#!/bin/bash

plugin_folder="$( eval echo $plugin_folder)"
ext_folder="$(eval echo $ext_folder)"
temp_folder="/tmp/rustplugins"

plugin_link="https://umod.org/plugins"
ext_link="https://umod.org/extensions"



download_file() {
    suffix=$1
    file_path=$2
    url="$3/$suffix"
    mkdir -p $(dirname $file_path)
    echo ">>>>>>>>>>using $url"
    curl -Ls $url -o $file_path
    if [ $? -eq 0 ]; then
	if grep -qv "Too Many Requests" $file_path; then
	   echo "Successfully downloaded $file_path"
	else
	   echo "too many requests"
	   rm $file_path
	fi
    else
        echo "Failed to download file"
    fi
}

update_assets() {

   search_path="$1"
   tmp_target="$2"
   base_url="$3"
   # special care for extensions
   is_ext="$4"

   mkdir -p $temp_folder
    
   for asset in $search_path; do
        local asset_name=$(basename $asset)
        local temp_path="$tmp_target/$asset_name"
	if [ "$asset_name" ==  "Oxide.Ext.RustIO.dll" ];then
		echo "RustIO special treatment"
		download_file "" $temp_path "http://playrust.io/latest"
	else
		if [ "$is_ext" == "True" ]; then
			dl_suffix="$(echo $asset_name | sed -e "s/Oxide.Ext.//g" -e "s/.dll//g" | tr '[:upper:]' '[:lower:]')/download"
			download_file $dl_suffix $temp_path $base_url
		else
        		download_file $asset_name $temp_path $base_url
		fi
	fi
        if [ -f $temp_path ]; then
            local remote_checksum=$(md5sum $temp_path | cut -f1 -d' ')
            local local_checksum=$(md5sum $asset | cut -f1 -d' ')
            if [ "$remote_checksum" != "$local_checksum" ]; then
                echo "Updating plugin $asset_name"
                mv $temp_path $asset
            else
                echo "Plugin $asset_name is up to date"
                rm $temp_path
            fi
        else
            echo "Failed to download plugin $asset_name"
        fi
    sleep 5
    done
}

echo "Updating Oxide Plugins on ------------$(date)------------"
update_assets "$ext_folder/Oxide.Ext.*.dll" "$temp_folder" "$ext_link" True
update_assets "$plugin_folder/*.cs" "$temp_folder" "$plugin_link"

