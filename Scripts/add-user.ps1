# Duong dan file CSV chua th�ng tin nguoi dung
$csvFilePath = "C:\Temp\User.csv"

# �oc du lieu tu tep CSV
$userData = Import-Csv -Path $csvFilePath

# Lap qua tung dong trong tep CSV v� tao nguoi d�ng v� gia nhap v�o OU tuong ung
foreach ($user in $userData) {
    $firstName = $user.FirstName
    $lastName = $user.Lastname
    $email = $user.Email
    $password = $user.Password
    $ou = $user.OU

    # Tao ten nguoi d�ng (SamAccountName) tu FirstName v� LastName
    $username = $firstName + $lastName

    # Kiem tra xem nguoi dung da ton tai hay chua
    if (-not (Get-ADUser -Filter { SamAccountName -eq $username })) {
        # Tao mot mang hash chua th�ng tin nguoi d�ng
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
        Write-Host "�� tao nguoi d�ng: $username v� gia nhap v�o OU: $ou"
    } else {
        Write-Host "Nguoi d�ng $username da ton tai."
    }
}
