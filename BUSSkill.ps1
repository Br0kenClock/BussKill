#BUSSkill

$targetId = 'USBSTOR\DISK&VEN__USB&PROD__SANDISK_3.2GEN1&REV_1.00\0401A5BB9F06EE1FFB66AE2DAC42F4048122ED654E70CD38C3C63F278D473D9'

$testOnly = $false

Add-Type @'
using System.Runtime.InteropServices;

public static class USBKillSession
{
	[DllImport("user32.dll", SetLastError = true)]
	[return: MarshalAs(UnmanagedType.Bool)]
	public static extern bool LockWorkStation();
}
'@

$armed = $false

Write-Host "Monitoring USB drive. Press CTRL+C to stop."

while ($true) {
	try {
		$disks = @(Get-CimInstance Win32_DIskDrive -ErrorAction Stop)

	}
	catch {
		throw "USB monitoring stopped: $($_.Exception.Message)"
	}

	$present = @(
		$disks |Where-Object { $_.PNPDeviceID -eq $targetId }
	).Count -gt 0

if ($present -and -not $armed) {
        $armed = $true
        Write-Host "ARMED: USB drive detected."
    }
    elseif (-not $present -and $armed) {
        # Disarm before sleeping to prevent repeated sleep on wake.
        $armed = $false

        if ($testOnly) {
            Write-Host "TEST: USB removed. Would request sleep now."
        }
        else {
            Write-Host "USB removed. Requesting sleep..."

            $success = [USBKillSession]::LocKWorkStation()

            if (-not $success) {
                Write-Warning "Windows rejected the sleep request."
            }
        }
    }

    Start-Sleep -Milliseconds 500
}