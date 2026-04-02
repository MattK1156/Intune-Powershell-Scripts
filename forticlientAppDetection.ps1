$vpnName = "City of Fredericton VPN"
$vpnDescription = "City of Fredericton VPN with MFA"
$vpnServer = "connect.fredericton.ca:443"
$registryPath = "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\"


if((Test-Path -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tuxnnels\City of Fredericton VPN") -ne $true) {

New-Item "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\City of Fredericton VPN" -force -ea SilentlyContinue;

New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$($vpnName)" -Name 'Description' -Value $vpnDescription -PropertyType String -Force -ea SilentlyContinue;

New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$($vpnName)" -Name 'Server' -Value $vpnServer -PropertyType String -Force -ea SilentlyContinue;

New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$($vpnName)" -Name 'promptusername' -Value 1 -PropertyType DWord -Force -ea SilentlyContinue;

New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$($vpnName)" -Name 'promptcertificate' -Value 0 -PropertyType DWord -Force -ea SilentlyContinue;

New-ItemProperty -LiteralPath "HKLM:\SOFTWARE\Fortinet\FortiClient\Sslvpn\Tunnels\$($vpnName)" -Name 'ServerCert' -Value '1' -PropertyType String -Force -ea SilentlyContinue; 

}