Set-PSReadlineOption -Colors @{
	Operator	=	"`e[94m"
	Parameter	=	"`e[95m"
}

if (Test-Path Function:\prompt) {
    Rename-Item Function:\prompt PromptBackup
} else {
    function PromptBackup() {
        # Restore a basic prompt if the definition is missing.
        "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";
    }
}

function prompt() {
    if (![String]::IsNullOrEmpty($env:HTTP_PROXY)) {
        Write-Host -NoNewline "`e[1;32m[v2ray]`e[m "
    }
    PromptBackup;
}


Set-Alias -Name python2 -Value C:/Python27/python.exe
Set-Alias -Name python3 -Value C:/Python310/python.exe
Set-Alias -Name gedit -Value 'C:/Program Files/Notepad++/notepad++.exe'


$VcpkgProfile = "${env:Vcpkg_ROOT}\scripts\posh-vcpkg"
if (Test-Path($VcpkgProfile)) {
	Import-Module "$VcpkgProfile"
	Set-Alias -Name vcpkg -Value ${env:Vcpkg_ROOT}/vcpkg.exe
}

$CondaProfile = "${env:CONDA_ROOT}\shell\condabin\Conda.psm1"
if (Test-Path($CondaProfile)) {
	Import-Module "$CondaProfile"
	#Add-CondaEnvironmentToPrompt
}

#$ChocolateyProfile = "${env:ChocolateyInstall}\helpers\chocolateyProfile.psm1"
#if (Test-Path($ChocolateyProfile)) {
#	Import-Module "$ChocolateyProfile"
#	refreshenv
#}

function VsVarsAll($platform = "x64") {
    # get the path to vcvarsall.bat
    $file = [System.IO.Path]::Combine(${Env:VC_ROOT}, "Auxiliary", "Build", "vcvarsall.bat")
 
    # run the .bat, and return a list of all the envvars
    $cmd = "`"$file`" $platform & set"
    cmd /c $cmd | Foreach-Object -Process {
        # parse the variables, and set them in powershell
        $p, $v = $_.split('=')
        Set-Item -path env:$p -value $v
    }
 
    # cool factor: update the title
    [System.Console]::Title = "VS $platform Windows PowerShell"
}

function GetEnvironment() {
	Get-ChildItem Env: | Format-Table -Wrap -AutoSize
}
New-Alias env GetEnvironment

function GetStringFromFiles($pattern, $filename=".") {
	Get-ChildItem -Recurse $filename |Select-String -Pattern $pattern
}
New-Alias sgrep GetStringFromFiles

function ApplyV2rayProxy() {
    if ([String]::IsNullOrEmpty($env:HTTP_PROXY)) {
        Set-Item Env:HTTP_PROXY "http://127.0.0.1:10809"
        Set-Item Env:HTTPS_PROXY "http://127.0.0.1:10809"
        #Set-Item Env:all_proxy "socks5://127.0.0.1:10808"
        Write-Output "V2ray Proxy On"
    } else {
        Remove-Item Env:HTTP_PROXY
        Remove-Item Env:HTTPS_PROXY
        #Remove-Item Env:all_proxy
        Write-Output "V2ray Proxy Off"
    }
}
New-Alias v2ray ApplyV2rayProxy

function MountWSL() {
    wsl --mount \\.\PHYSICALDRIVE2
}

function UMountWSL() {
    wsl --unmount \\.\PHYSICALDRIVE2
}

function VcpkgPath($triplet=${env:VCPKG_DEFAULT_TRIPLET}) {
    $env:Path += ";$env:Vcpkg_ROOT\installed\$triplet\bin;$env:Vcpkg_ROOT\installed\$triplet\debug\bin"
    $env:INCLUDE += ";$env:Vcpkg_ROOT\installed\$triplet\include"
    $env:LIB += ";$env:Vcpkg_ROOT\installed\$triplet\lib"
    $env:LIBPATH += ";$env:Vcpkg_ROOT\installed\$triplet\lib"
}

function VcpkgTool($package, $triplet=${env:VCPKG_DEFAULT_TRIPLET}) {
    $env:Path += ";$env:Vcpkg_ROOT\installed\$triplet\tools\$package"
}

function GoogleDepotTools() {
    $env:Path += ";D:\Developer\misc\depot_tools"
}

function WsaConnect() {
    adb connect 127.0.0.1:58526
}

function WsaProxyOn() {
    $WinNetIP=$(Get-NetIPAddress -InterfaceAlias 'vEthernet (WSL)' -AddressFamily IPV4)
    #adb connect 127.0.0.1:58526
    adb shell settings put global http_proxy "$($WinNetIP.IPAddress):10811"
    #adb shell settings put global http_proxy "127.0.0.1:10809"
}

function WsaProxyOff() {
    #adb connect 127.0.0.1:58526
    #adb shell settings delete global http_proxy
    #adb shell settings delete global global_http_proxy_host
    #adb shell settings delete global global_http_proxy_port
    adb shell settings put global http_proxy :0
}