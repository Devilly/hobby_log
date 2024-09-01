# OpenSSH on Windows 10

To enable SSH'ing to a Windows 10 machine follow these steps on the Windows machine:
* Go to (Start > Settings > System) Optional features
    * Install OpenSSH server
* Go to Services
    * Enable OpenSSH SSH server
    * Startup Type can be set to automatic to automatically run the server on restarts

To enable SSH key login:

* Disable the lines

    ```
    Match Group administrators
        AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys
    ```

    in `C:\ProgramData\ssh\sshd_config`

* Add your client public key in `.ssh/authorized_keys` within your user directory
* Restart the OpenSSH service.

## References
* https://learn.microsoft.com/en-us/windows/client-management/client-tools/add-remove-hide-features?pivots=windows-10
* https://superuser.com/questions/1510227/authorized-keys-win-10-ssh-issue/1510364#1510364