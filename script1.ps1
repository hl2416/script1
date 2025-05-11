$option

while ($option -ne "7")
{
    Clear-Host
    Write-Host "Script 1 Menu"
    Write-Host ""
    Write-Host "1 - Create a VM"
    Write-Host "2 - List the available VMs"
    Write-Host "3 - Start a VM"
    Write-Host "4 - Stop a VM"
    Write-Host "5 - List the settings of a particular VM"
    Write-Host "6 - Delete a VM"
    Write-Host "7 - End the program"
    Write-Host ""

    $option = Read-Host "Enter the number of an option"

    switch ($option)
    {
        "1"
        {
	    $name = Read-Host "Please enter a name for your VM"
	    $memory = Read-Host "Please enter the amount of memory for your VM"
	    $vhdPath = "C:\$name.vhdx"
	    $storage = Read-Host "Please enter the amount of storage for your VM"
            New-VM -Name $name -MemoryStartupBytes ([uint64] ($memory / 1)) -NewVHDPath $vhdPath -NewVHDSizeBytes ([uint64] ($storage / 1))
        }
        "2"
        {
            Get-VM | Out-Default
        }
        "3"
        {
	    $name = Read-Host "Please enter the Name of the VM that you would like to start"
	    Start-VM -Name $name
        }
        "4"
        {
            $name = Read-Host "Please enter the Name of the VM that you would like to stop"
	    Stop-VM -Name $name -TurnOff
        }
        "5"
        {
	    $name = Read-Host "Please enter the Name of the VM whos settings you would like to view"
            Get-VMProcessor $name | Out-Default
	    Get-VMMemory $name | Out-Default
	    Get-VHD -Path "C:\$name.vhdx" | Select-Object @{Name="Storage Size GB";Expression={$_.Size/1GB}} | Out-Default
	    Get-VMNetworkAdapter $name | Out-Default
        }
        "6"
        {
            $name = Read-Host "Please enter the Name of the VM that you would like to delete"
	    $vm = Get-VM -Name $name
	    if ($vm.State -ne 'Running')
	    {
		Remove-Item "C:\$name.vhdx"
	    	Remove-VM -Name $name
	    }
	    else
	    {
		Write-Host "Please turn off VM before deleting"
	    }
        }
        "7"
        {
            "Program Ended"
        }
        Default
        {
            "Please enter one of the number options"
        }
    }
    pause
}

Clear-Host