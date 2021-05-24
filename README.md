# too-many-open-files-reproducer
Demo of a file limits on a mac

The default max open file limit on a mac per process is 10240. This value can be changed by changing `ulimit -n 20000` for the current shell session.
To make the limit persistent the values must be stored in `/Library/LaunchDaemons/limit.maxfiles.plist` and loaded via
```bash
sudo launchctl load -w /Library/LaunchDaemons/limit.maxfiles.plist
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple/DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
    <dict>
      <key>Label</key>
        <string>limit.maxfiles</string>
      <key>ProgramArguments</key>
        <array>
	  <string>sudo</string>
          <string>launchctl</string>
          <string>limit</string>
          <string>maxfiles</string>
          <string>655360</string>
          <string>1048576</string>
        </array>
      <key>RunAtLoad</key>
        <true />
    </dict>
  </plist>
```

## Running Java Program

`max-open-files.sh` executes the `MaxOpenFiles` java program with different settings showing
the effect of `-XX:-MaxFDLimit`

```bash
./gradlew installDist
./max-open-files.sh
```
results in

```text
MaxFDLimit - The only time that you may need to disable this is on Mac OS, where its use imposes a maximum of 10240, which is lower than the actual system maximum [https://docs.oracle.com/en/java/javase/11/tools/java.html]
Setting '-XX:-MaxFDLimit' respects the session limit even though its lower than the default
Java Executable max files:  10240
Java Executable max files:  5000
Higher session ulimit (21000) only has an effect when in conjunction with '-XX:-MaxFDLimit'
Java Executable max files:  10240
Java Executable max files:  21000
```

## Running Gradle

### No effect
Channing the `ulimit`does not have any impact on the Gradle task. But running without the daemon `--no-daemon` results in
a slightly lower value for the file limit

```bash
❯ ulimit -n 5000
❯ ./gradlew --rerun-tasks -i test  | grep "max files"
Gradle Build script max files: 12544
    Test max files: 12544
❯ ./gradlew --rerun-tasks -i test --no-daemon | grep "max files"
Gradle Build script max files: 10240
    Test max files: 12544
❯ ulimit -n 21000
❯ ./gradlew --rerun-tasks -i test  | grep "max files"
Gradle Build script max files: 12544
    Test max files: 12544
❯ ./gradlew --rerun-tasks -i test --no-daemon | grep "max files"
Gradle Build script max files: 10240
    Test max files: 12544
```

### Increase file limits
To actually make the new files limits become active both `JAVA_OPTS=-XX:-MaxFDLimit` AND `org.gradle.jvmargs=-XX:-MaxFDLimit` in `gradle.properties`
must be active.

```zsh
export JAVA_OPTS=-XX:-MaxFDLimit
echo "org.gradle.jvmargs=-XX:-MaxFDLimit" > gradle.properties
```

```text
❯ ./gradlew --rerun-tasks -i test | grep "max files"
Gradle Build script max files: 23304
    Test max files: 23304
❯ ./gradlew --rerun-tasks -i test --no-daemon | grep "max files"
Gradle Build script max files: 21000
    Test max files: 23304
```
