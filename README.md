# **Remote eXecution Server Maintenance (RXSM)**
**Remote eXecution Server Maintenance** (RXSM, pronounced \ˈrɑksɪm\\) is a small bundle of scripts used to manage services and run reports on the Raritan Public Library's main server.

## **Installation**
First, download or clone the latest version of the RXSM script bundle from this repository.

### **WinSCP**
If you are running Windows, we will need **WinSCP** in order to communicate with the server. [Install it](https://winscp.net/eng/download.php) and test it via the command line (below is the default install location):
```
"C:\Program Files (x86)\WinSCP\WinSCP.com"
```
If you are using macOS or a Linux distribution, you can modify these scripts to use **`ssh`** rather than WinSCP.

### **7zip**
Next, we will need to download **7zip** in order to package and send our distribution directory. If you are using Windows, [install it](https://www.7-zip.org/download.html) and test it via the command line:
```
7z
```
If you are using macOS or a Linux distribution, you can modify these scripts to use the **`zip`** command rather than 7zip.

### **Environment variables**
Once you have the repository downloaded in a suitable location, you'll need to set up an `.env` file with the following variables before running any scripts.
- **`h`** - The hostname for the SSH server to connect to
- **`u`** - The username to use to connect to the server
- **`k`** - The `.ppk` ([PuTTY](https://www.putty.org/) private key) file to authenticate your identity
- **`root`** - The root folder containing this repository (UNIX-style)

## **Usage**

### **Generate a webstat report**
```
./scripts/report.sh
```
The resulting report will be placed in the `reports` directory under a subdirectory named for the date the report was run (for example, running a report on November 2019 would write the report to the `reports/1911` directory). Running this command will also archive the Apache access log and create a new access log.

### **Restart/start/stop a service**
```
./scripts/service.sh <service_name> <action>
```
`service_name` is a required parameter. `action` is an optional parameter; if not defined, the server will restart.

### **Check for new versions**
```
./scripts/version.sh
```
A table containing version information for Apache, FreeSSHD, and Destiny will be printed to the terminal.

## **Other Useful Commands**
Due to the nature of some software used on the server, you will need to run these commands in specific circumstances.

### **Renew HTTPS certificate**
*This command should be run directly in the server's terminal.*
```
certbot renew --pre-hook "C:/Apache24/bin/httpd.exe -k stop" --post-hook "C:/Apache24/bin/httpd.exe -k runservice
```

### **Run report script monthly**
You can run the report script at the end of the month using scheduled tasks.

First, create a batch file on your local Windows machine:
```cmd
@echo off
setlocal
FOR /F "tokens=*" %%i in ('type <DOTENV_LOCATION>') do SET %%i
"<SH.EXE_LOCATION>" -c "cd %root% && ./scripts/report.sh"
endlocal
```
Then, run this command in an elevated instance of Command Prompt.
```cmd
schtasks /create /tn rpl_webstat /tr "<BATCH_FILE_PATH>" /sc monthly /mo lastday /m * /st 23:55 /ru "<COMPUTER_NAME>\<USERNAME>"
```
## **Issues and Contributing**
Pull requests are encouraged by the Raritan Public Library to ensure our software is of the highest quality possible. If you would like to suggest major changes or restructuring of this repository, please [open an issue](https://github.com/raritanlibrary/rxsm/issues/new). It is also strongly suggested you email us at [raritanlibrary54@aol.com](mailto:raritanlibrary54@aol.com) with any additional questions or concerns.

## **License**

[MIT](LICENSE)