#!/bin/bash

insert_debug_string()
{
    file=$1
    line=$2
    debug_string=$3
    debug=$4

    value=`sed -n ${line}p "$file"`

    if [ "$value" != "$debug_string" ] && [ "$debug" = debug ]
    then
    echo "++Insert $debug_string in line_${line}++"

    sed "${line}s/^/\n/" -i $file
    sed -i "${line}s:^:${debug_string}:" "$file"
    fi
}

delete_debug_string()
{
    file=$1
    line=$2
    debug_string=$3

    value=`sed -n ${line}p "$file"`
    if [ "$value" = "$debug_string" ]
    then
    echo "--Delete $debug_string in line_${line}--"
    sed "${line}d" -i "$file"
    fi
}

make_build_dir()
{
    buildPath=$1
    rebuild=$2

    if [ -d "$buildPath" ] && [ "$rebuild" = rebuild ]
    then
    rm -rf "$buildPath"
    fi

    if [ ! -d "$buildPath" ]
    then
    mkdir -p "$buildPath"
    fi
}

if [ "$1" = build ]
then
#   ./run.sh build rebuild
    buildPath=build
    rebuild=$2
    cd build
    make_build_dir $buildPath "$rebuild"
    cmake -DCAFFE_SRC=/home/shhs/Desktop/user/code/caffe ..

elif [ $1 = manual ]
then
#   ./run.sh manual
    caffe_path=../caffe
    cp bilateralnn_code/include $caffe_path -r
    cp bilateralnn_code/examples $caffe_path -r
    cp bilateralnn_code/src/caffe/layers $caffe_path/src/caffe -r
    cp bilateralnn_code/src/caffe/test $caffe_path/src/caffe -r
    cp bilateralnn_code/src/caffe/util $caffe_path/src/caffe -r

    caffe_proto="${caffe_path}/src/caffe/proto/caffe.proto"
#    message LayerParameter
    caffe_proto_str1="optional PermutohedralParameter permutohedral_param = 149;optional PixelFeatureParameter pixel_feature_param = 150;"
    insert_debug_string "$caffe_proto" 424 "$caffe_proto_str1" debug

    if ! grep -q "message PermutohedralParameter" "$caffe_proto";
    then
        caffe_proto_str2=`sed -n 854,922p bilateralnn_code/src/caffe/proto/caffe.proto`
        echo "$caffe_proto_str2" >> "$caffe_proto"
        echo "**Insert message PermutohedralParameter**"
    fi

fi