# BUSSKILL
This is a lightweight tool that locks your Windows PC whenever a specific USB flash drive is disconnected using simple PowerShell scripts and a scheduled task.

Once the configured drive is connected to the device with the scheduled task, the task is thus triggered and the PowerShell script is armed. Whenever, the drive is removed, the script requests a Windows lock, similar to when you press Win + L. Your applications stay running in the background even though you PC is now locked.

You can modify the script to request a shutdown, or a complete wiping of your PC.

