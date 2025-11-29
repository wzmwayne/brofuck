# Create RDP user with fixed password that meets complexity requirements
$password = "Aa123456!"
$securePass = ConvertTo-SecureString $password -AsPlainText -Force

try {
    New-LocalUser -Name "vum" -Password $securePass -AccountNeverExpires -ErrorAction Stop
    Write-Host "User created successfully"
} catch {
    Write-Host "Error creating user: $_"
    
    # 如果创建失败，尝试使用更复杂的密码
    $password = "VumRdp2024!"
    $securePass = ConvertTo-SecureString $password -AsPlainText -Force
    New-LocalUser -Name "vum" -Password $securePass -AccountNeverExpires
}

# 添加到管理员组和远程桌面用户组
Add-LocalGroupMember -Group "Administrators" -Member "vum" -ErrorAction SilentlyContinue
Add-LocalGroupMember -Group "Remote Desktop Users" -Member "vum" -ErrorAction SilentlyContinue

# 输出凭据到环境变量
echo "RDP_CREDS=User: vum | Password: $password" >> $env:GITHUB_ENV

# 验证用户创建
if (Get-LocalUser -Name "vum" -ErrorAction SilentlyContinue) {
    Write-Host "User creation verified successfully"
} else {
    throw "User creation failed"
}

Write-Host "Created user 'vum' with password: $password"
