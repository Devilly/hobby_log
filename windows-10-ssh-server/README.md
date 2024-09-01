# OpenSSH on Windows 10

To enable SSH'ing to a Windows 10 machine follow these steps:
* Go to...
    * Start
    * Settings
    * System
    * Optional features
* Enable OpenSSH server

To enable SSH key login disable the lines

```
Match Group administrators
       AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
```

in `C:\ProgramData\ssh\sshd_config`.

## References
* https://learn.microsoft.com/en-us/windows/client-management/client-tools/add-remove-hide-features?pivots=windows-10
* https://superuser.com/questions/1510227/authorized-keys-win-10-ssh-issue/1510364#1510364