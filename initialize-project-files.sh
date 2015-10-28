#!/bin/sh

if [ ! -d "app/src/" ]; then
    echo "Run in the top-level directory of your project (the one that contains the app directory.)"
    exit 1
fi

mkdir -p app/src/main/assets/metadata
ln -s {../../nativescript-android/,}app/src/main/assets/metadata/treeValueStream.dat
ln -s {../../nativescript-android/,}app/src/main/assets/metadata/treeNodeStream.dat
ln -s {../../nativescript-android/,}app/src/main/assets/metadata/treeStringsStream.dat

mkdir -p app/src/main/jniLibs/x86
ln -s {../../nativescript-android/,}app/src/main/jniLibs/x86/libNativeScript.so
ln -s {../../nativescript-android/,}app/src/main/jniLibs/x86/libAssetExtractor.so

mkdir -p app/src/main/jniLibs/armeabi-v7a
ln -s {../../nativescript-android/,}app/src/main/jniLibs/armeabi-v7a/libNativeScript.so
ln -s {../../nativescript-android/,}app/src/main/jniLibs/armeabi-v7a/libAssetExtractor.so

mkdir -p app/libs
ln -s {../../nativescript-android/,}app/libs/nativescript.jar
ln -s {../../nativescript-android/,}app/libs/widgets.jar
