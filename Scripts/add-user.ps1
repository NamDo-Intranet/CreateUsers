# Duong dan file CSV chua thông tin nguoi dung
$csvFilePath = "C:\Temp\User.csv"

# Ðoc du lieu tu tep CSV
$userData = Import-Csv -Path $csvFilePath

# Lap qua tung dong trong tep CSV và tao nguoi dùng và gia nhap vào OU tuong ung
foreach ($user in $userData) {
    $firstName = $user.FirstName
    $lastName = $user.Lastname
    $email = $user.Email
    $password = $user.Password
    $ou = $user.OU

    # Tao ten nguoi dùng (SamAccountName) tu FirstName và LastName
    $username = $firstName + $lastName

    # Kiem tra xem nguoi dung da ton tai hay chua
    if (-not (Get-ADUser -Filter { SamAccountName -eq $username })) {
        # Tao mot mang hash chua thông tin nguoi dùng
        $userProps = @{
            SamAccountName = $username
            UserPrincipalName = $email
            Name = "$firstName $lastName"
            GivenName = $firstName
            Surname = $lastName
            DisplayName = "$firstName $lastName"
            AccountPassword = (ConvertTo-SecureString -AsPlainText $password -Force)
            Enabled = $true
        }

        # Tao nguoi dung moi trong Active Directory
        New-ADUser @userProps -Path $ou
        Write-Host "Ðã tao nguoi dùng: $username và gia nhap vào OU: $ou"
    } else {
        Write-Host "Nguoi dùng $username da ton tai."
    }
}
