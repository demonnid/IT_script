#This application will pull basic inventory information from a list of devices.  The devices list is sent <file_path>\names.txt and the output is pushed to a file <file_path>\computers.txt

function Get-EnterpriseEnvironment{
	param(
		[Parameter(ValueFromPipeline=$true)]
		[string[]]$Computer=$env:computername
	)
    Process{
        $computer |
        	ForEach-Object{
				$name=Get-WmiObject -Class Win32_ComputerSystem -Computername $_
                $proc=Get-WmiObject -Class Win32_Processor -Computername $_
				$bios =Get-WmiObject -Class Win32_BIOS -Computername $_
                $os =Get-WmiObject -Class Win32_operatingsystem -Computername $_
                $monitor=Get-WMIObject -Class Win32_DesktopMonitor -Computername $_


                                
    			$prop= [ordered]  @{
        			Name =$name.name 
                    Make = $name.manufacturer
                    Model = $name.model
                    Serial = $bios.SerialNumber
                    Domain =$name.domain
                    UserName =$name.Username
                    Processors = $name.NumberofProcessors
                    Logical = $name.NumberofLogicalProcessors
                    Processor = $proc.Name
                    Memory =[System.Math]::round($name.TotalPhysicalMemory/1MB)
                    OS = $os.Caption
                    SP = $os.ServicePackMajorVersion
                    Installed = $os.InstallDate

                    	                   
                    
   			}
   			New-Object PSCustomObject -Property   $prop
			}
	}
}

Get-Content <file_path>\names.txt | Get-EnterpriseEnvironment | Export-csv <file_path>\devices.csv 
