function Disable-CertsCheck {
    [cmdletbinding()]
    param(

    )
    if ($PSVersionTable.PSEdition -eq 'Core') {
        # Invoke-restmethod provide Skip certcheck param in powershell core
        $Script:PSDefaultParameterValues = @{
            "invoke-restmethod:SkipCertificateCheck" = $true
            "invoke-webrequest:SkipCertificateCheck" = $true
        }
    }
    else {
        add-type -TypeDefinition  @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    }
}
