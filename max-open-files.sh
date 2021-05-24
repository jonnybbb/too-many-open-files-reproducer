#!/bin/zsh
javaExecCommand="$(pwd)/build/install/too-many-open-files-reproducer/bin/too-many-open-files-reproducer"

echo "MaxFDLimit - The only time that you may need to disable this is on Mac OS, where its use imposes a maximum of 10240, which is lower than the actual system maximum [https://docs.oracle.com/en/java/javase/11/tools/java.html]"
echo "Setting '-XX:-MaxFDLimit' respects the session limit even though its lower than the default"
ulimit -n 5000
$javaExecCommand

export JAVA_OPTS=-XX:-MaxFDLimit
$javaExecCommand

echo "Higher session ulimit (21000) only has an effect when in conjunction with '-XX:-MaxFDLimit'"

unset JAVA_OPTS
ulimit -n 21000
$javaExecCommand

export JAVA_OPTS=-XX:-MaxFDLimit
$javaExecCommand

