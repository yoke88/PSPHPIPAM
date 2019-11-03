function UnProtect-Rijndael256ECB {
    [cmdletbinding()]
    param(
        [STRING]$Key,
        [string]$CipherText
    )

    $RijndaelProvider = New-Object -TypeName System.Security.Cryptography.RijndaelManaged

    $RijndaelProvider.BlockSize = 256
    $RijndaelProvider.Mode = [System.Security.Cryptography.CipherMode]::ECB
    $RijndaelProvider.Key = [system.Text.Encoding]::default.GetBytes($key)
    $RijndaelProvider.Padding = [system.security.cryptography.PaddingMode]::Zeros;
    $RijndaelProvider.IV = [byte[]]@(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 )
    $Decryptor = $RijndaelProvider.CreateDecryptor($RijndaelProvider.Key, $RijndaelProvider.IV)

    # Reverse process: Base64Decode first, then populate memory stream with ciphertext and lastly read decrypted data through cryptostream
    $Cipher = [convert]::FromBase64String($CipherText) -as [byte[]]

    $DecMemoryStream = New-Object System.IO.MemoryStream -ArgumentList @(, $Cipher)
    $DecCryptoStream = New-Object System.Security.Cryptography.CryptoStream -ArgumentList $DecMemoryStream, $Decryptor, $([System.Security.Cryptography.CryptoStreamMode]::Read)
    $DecStreamWriter = New-Object System.IO.StreamReader -ArgumentList $DecCryptoStream

    $NewPlainText = $DecStreamWriter.ReadToEnd()

    $DecStreamWriter.Close()
    $DecCryptoStream.Close()
    $DecMemoryStream.Close()

    return $NewPlainText

}
