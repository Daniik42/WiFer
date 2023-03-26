@echo off & cls

if %~1 == -wifi (
	goto :wifi
) else (
	if %~1 == -ethernet (
		goto :ethernet
	) else (
		if %~1 == -powercfg (
			goto :powercfg
		) else (
			if %~1 == -cores (
				wmic cpu get NumberOfCores
				exit /b
			) else (
				if %~1 == -help (
					goto :help
				) else (
					echo Wrong parameters
					exit /b
				)
			)
		)
	)
)
:help
echo USAGE:
echo.
echo wifer -wifi /on
echo wifer -wifi /off
echo.
echo wifer -ethernet /on
echo wifer -ethernet /off
echo wifer -ethernet /reset
echo.
echo wifer -powercfg /ps (set powercfg to power saver)
echo wifer -powercfg /b (set powercfg balanced)
echo wifer -powercfg /up (set powercfg to ultimate performance)
echo.
echo wifer -cores (gets list of cores)

:wifi
if %~2 == /on (
	goto :enablewifi
) else (
	if %~2 == /off (
		goto :disablewifi
	) else (
		echo Wrong command
		exit /b
	)
)

:enablewifi
cls
netsh interface set interface name="%~3" enable
echo Done
exit /b

:disablewifi
cls
netsh interface set interface name="%~3" disable
echo Done
exit /b

:ethernet
if %~2 == /reset (
	goto :ethernetreset
) else (
	if %~2 == /on (
		goto :etherneton
	) else (
		if %~2 == /off (
			goto :ethernetoff
		) else (
			echo Wrong parameters
			exit /b
		)
	)
)
:etherneton
cls
netsh interface set interface "Ethernet" admin=enable
echo Done
exit /b

:ethernetoff
cls
netsh interface set interface "Ethernet" admin=disable
echo Done
exit /b

:ethernetreset
ipconfig /release >nul
ipconfig /renew >nul
netsh int ip delete arpcache >nul
netsh int ip reset >nul
netsh winsock reset >nul
netsh winsock reset proxy >nul
echo Done!
exit /b

:powercfg
cls
if %~2 == /ps (
	goto:powercfg_powersaver
) else (
	if %~2 == /b (
		goto :powercfg_balanced
	) else (
		if %~2 == /up (
			goto :ultimate_per
		) else (
			echo Wrong command
			exit /b
		)
	)
)
:powercfg_powersaver
powercfg -setactive a1841308-3541-4fab-bc81-f71556f20b4a >nul
echo Done
exit /b
:powercfg_balanced
powercfg -setactive 381b4222-f694-41f0-9685-ff5bb260df2e >nul
echo Done
exit /b
:ultimate_per
powercfg -setactive 8190c3c3-c112-4c7c-81b4-74ef884e0fe2 >nul
if %errorlevel% equ 0 (
	cls
	powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
	echo Done
	exit /b
) else (
	echo Done
	exit /b
)