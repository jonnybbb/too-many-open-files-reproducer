#!/bin/zsh
java -cp app/build/classes/java/main com.gradle.toomanyfiles.MaxOpenFiles
java -XX:-MaxFDLimit -cp app/build/classes/java/main com.gradle.toomanyfiles.MaxOpenFiles

ulimit -n 21000

java -cp app/build/classes/java/main com.gradle.toomanyfiles.MaxOpenFiles
java -XX:-MaxFDLimit -cp app/build/classes/java/main com.gradle.toomanyfiles.MaxOpenFiles
