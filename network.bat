@echo off
:start
netsh interface show interface > networklog.txt
ping www.qq.com -n 9 >> networklog.txt
setlocal enabledelayedexpansion
for /f  "delims=" %%i in (networklog.txt) do (
  set atmp=%%i
  set atmp=!atmp:~0,3!
  if "!atmp!"=="已禁用" (
      time /t >> network.log
      echo 网络被禁用 >> network.log
      set atmp=%%i
      set atmp=!atmp:~47,10!
      echo 尝试启用!atmp!  >> network.log
      netsh interface set interface name="!atmp!"  admin=disable  >> network.log
      netsh interface set interface name="!atmp!"  admin=enable  >> network.log
  )
  set atmp=%%i
  set atmp=!atmp:~15,5!
  if "!atmp!"=="已断开连接" (
      time /t >> network.log
      echo 网络被断开
      set atmp=%%i
      set atmp=!atmp:~47,10!
      if "!atmp!"=="WLAN" (
        echo restarting wifi  
        netsh wlan connect "****"  
      )
  )

  set atmp=%%i
  set atmp=!atmp:~25,2!
  if "!atmp!"=="丢失" (
     set atmp=%%i
     set atmp=!atmp:~30,1!
     time /t >> network.log
     echo 丢包!atmp!  >> network.log
     if "!atmp!"=="9" (
       echo new work broken  >> network.log
       echo restarting wifi   >> network.log
       netsh wlan connect "****"  >> network.log
       echo restarting China Telecom   >> network.log
       TASKKILL /f /t /IM "C+WClient.exe"  >nul 2>nuls
       echo "C:\Program Files (x86)\Chinatelecom C+W\C+WClient.exe" | cmd
     )
  )
)
choice /t 120 /d y /n >null
goto start
