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




