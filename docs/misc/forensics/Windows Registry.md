
|Hive Name|Contains|Location|
|---|---|---|
|SYSTEM|- Services<br>- Mounted Devices<br>- Boot Configuration<br>- Drivers<br>- Hardware|`C:\Windows\System32\config\SYSTEM`|
|SECURITY|- Local Security Policies<br>- Audit Policy Settings|`C:\Windows\System32\config\SECURITY`|
|SOFTWARE|- Installed Programs<br>- OS Version and other info<br>- Autostarts<br>- Program Settings|`C:\Windows\System32\config\SOFTWARE`|
|SAM|- Usernames and their Metadata<br>- Password Hashes<br>- Group Memberships<br>- Account Statuses|`C:\Windows\System32\config\SAM`|
|NTUSER.DAT|- Recent Files<br>- User Preferences<br>- User-specific Autostarts|`C:\Users\username\NTUSER.DAT`|
|USRCLASS.DAT|- Shellbags<br>- Jump Lists|`C:\Users\username\AppData\Local\Microsoft\Windows\USRCLASS.DAT`|
The Windows OS has a built-in tool known as the **Registry Editor**, which allows you to view all the registry data available in these hives.

Windows organizes all the Registry Hives into these structured **Root Keys**.

|Hive on Disk|Where You See It in Registry Editor|
|---|---|
|SYSTEM|`HKEY_LOCAL_MACHINE\SYSTEM`|
|SECURITY|`HKEY_LOCAL_MACHINE\SECURITY`|
|SOFTWARE|`HKEY_LOCAL_MACHINE\SOFTWARE`|
|SAM|`HKEY_LOCAL_MACHINE\SAM`|
|NTUSER.DAT|`HKEY_USERS\<SID> and HKEY_CURRENT_USER`|
|USRCLASS.DAT|`HKEY_USERS\<SID>\Software\Classes`|
## Example 1: View Connected USB Devices

**Note:** The registry key contents explained in this example are not available in the attached VM.

The registry stores information on the USB devices that have been connected to the system. This information is present in the `SYSTEM` hive. To view it:

1. Open the Registry Editor.
2. Navigate to the following path: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USBSTOR`.
3. Here you will see the USB devices' information (make, model, and device ID).
4. Each device will have the following:
    1. A main subkey that is the identification of the type and manufacturer of the USB device.
    2. A subkey under the above (for example) that represents the unique devices under this model.

![Registry Editor screenshot showing the resgitry key that has the information of the USBs that have been attached.](https://tryhackme-images.s3.amazonaws.com/user-uploads/68d2c1e7ab94268f6271de1d/room-content/68d2c1e7ab94268f6271de1d-1761292172298.png)

## Example 2: View Programs Run by the User

The registry stores information on the programs that the user ran using the Run dialog `Win + R`. This information is present in the `NTUSER.DAT` hive. To view it:

1. Open the Registry Editor.
2. Navigate to the following path: `HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU`.
3. Here you will see the list of commands typed by the user in the Run dialog to run applications.

![Registry Editor screenshot showing the resgitry key that has the information of the commands typed by the user in the Run Dialog.](https://tryhackme-images.s3.amazonaws.com/user-uploads/68d2c1e7ab94268f6271de1d/room-content/68d2c1e7ab94268f6271de1d-1761292172317.png)

## Registry Forensics

Since the registry contains a wide range of data about the Windows system, it plays a crucial role in forensic investigations. Registry forensics is the process of extracting and analyzing evidence from the registry. In Windows digital forensic investigations, investigators analyze registry, event logs, file system data, memory data, and other relevant data to construct the whole incident timeline. 

The table below lists some registry keys that are particularly useful during forensic investigations.

| Registry Key                                                             | Importance                                                                                                           |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------- |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist`     | It stores information on recently accessed applications launched via the GUI.                                        |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths`     | It stores all the paths and locations typed by the user inside the Explorer address bar.                             |
| `HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths`               | It stores the path of the applications.                                                                              |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\WordWheelQuery` | It stores all the search terms typed by the user in the Explorer search bar.                                         |
| `HKLM\Software\Microsoft\Windows\CurrentVersion\Run`                     | It stores information on the programs that are set to automatically start (startup programs) when the users logs in. |
| `HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs`     | It stores information on the files that the user has recently accessed.                                              |
| `HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName`        | It stores the computer's name (hostname).                                                                            |
| `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall`               | It stores information on the installed programs.                                                                     |
The investigation of these registry keys during forensics cannot be done via the built-in Registry Editor tool. Use the [**Registry Explorer**](https://ericzimmerman.github.io/) tool which is a registry forensics tool
## Registry Explorer
While loading Registry Hives, it is important to know that these Registry Hives can sometimes be "dirty" when collected from live systems, meaning they may have incomplete transactions. To ensure clean loading:

1.On the **Load hives** pop-up, navigate to `C:\Users\Administrator\Desktop\Registry Hives   `
2. Select the desired hive file (e.g., SYSTEM)  
**3. Hold SHIFT**, then press **Open** to load associated transaction log files. This ensures you get a clean, consistent hive state for analysis.
4. You'll be prompted with a message indicating successful replay for transaction logs  
5. Repeat the same process for all the other hives you want to load

full path where the user launched the application
`ROOT\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Compatibility Assistant\Store`